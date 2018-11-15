//
//  WallyMLEngine.swift
//  WallyML
//
//  Created by Florian LUDOT on 11/15/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit
import CoreML
import Vision

protocol WallyMLEngineDelegate: class {
    func didConfidenceChanged(newValue: Double)
}

class WallyMLEngine {
    
    // Engine States
    enum State {
        case initialized
        case searching
        case found(timeElapsed: Double, predictions: [Prediction])
        case notFound
        case error(String)
    }
    
    weak var delegate: WallyMLEngineDelegate?
    
    let userPreferences: UserPreferences
    
    var request: VNRequest?
    var startTime: CFAbsoluteTime!
    
    // Enable the engine to start with a image of type CIImage or CVPixelBuffer
    enum ImageSource {
        case ciImage(ciImage: CIImage)
        case cvPixelBuffer(cvPixelBuffer: CVPixelBuffer)
    }
    
    init(preferences: UserPreferences = UserPreferences()) {
        self.userPreferences = preferences
    }
    
    // Launch the detection request
    func start(with imageType: ImageSource, completionHandler: @escaping (_ : State)->()) {
        
        let handler: VNImageRequestHandler!
        
        switch imageType {
        case .ciImage(let ciImage):
            handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        case .cvPixelBuffer(let cvPixelBuffer):
            handler = VNImageRequestHandler(cvPixelBuffer: cvPixelBuffer, options: [:])
        }
        
        let mlmodel = WallyML().model
        
        do {
            let model = try VNCoreMLModel(for: mlmodel)
            let confidence = self.confidenceThreshold()
            startTime = CFAbsoluteTimeGetCurrent()
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                guard let strongSelf = self else { return }
                strongSelf.request = request
                strongSelf.processDetections(for: request, withConfidenceThreshold: confidence, completionHandler: { (state) in
                    completionHandler(state)
                })
            })
            request.imageCropAndScaleOption = .scaleFill
            
            try? handler.perform([request])
            
        } catch {
            completionHandler(.error("CoreML can't perform your request"))
        }
    }
    
    // Process Detection request result
    func processDetections(for request: VNRequest, withConfidenceThreshold confidenceThreshold: Double, completionHandler: @escaping (_ : State) -> ()) {
        
        delegate?.didConfidenceChanged(newValue: confidenceThreshold)
        
        DispatchQueue.global(qos: .userInteractive).async {
            let results = request.results as! [VNCoreMLFeatureValueObservation]
            
            let coordinates = results[0].featureValue.multiArrayValue!
            let confidence = results[1].featureValue.multiArrayValue!
            
            var unorderedPredictions = [Prediction]()
            let numBoundingBoxes = confidence.shape[0].intValue
            let numClasses = confidence.shape[1].intValue
            let confidencePointer = UnsafeMutablePointer<Double>(OpaquePointer(confidence.dataPointer))
            let coordinatesPointer = UnsafeMutablePointer<Double>(OpaquePointer(coordinates.dataPointer))
            for b in 0..<numBoundingBoxes {
                var maxConfidence = 0.0
                var maxIndex = 0
                for c in 0..<numClasses {
                    let conf = confidencePointer[b * numClasses + c]
                    if conf > maxConfidence {
                        maxConfidence = conf
                        maxIndex = c
                    }
                }
                
                if maxConfidence > confidenceThreshold {
                    let x = coordinatesPointer[b * 4]
                    let y = coordinatesPointer[b * 4 + 1]
                    let w = coordinatesPointer[b * 4 + 2]
                    let h = coordinatesPointer[b * 4 + 3]
                    
                    let rect = CGRect(x: CGFloat(x - w/2), y: CGFloat(y - h/2),
                                      width: CGFloat(w), height: CGFloat(h))
                    
                    let prediction = Prediction(labelIndex: maxIndex,
                                                confidence: Float(maxConfidence),
                                                boundingBox: rect)
                    unorderedPredictions.append(prediction)
                }
            }
            
            let orderedPredictions = self.orderPredictions(unorderedPredictions)
            
            self.processOrderedPredictions(orderedPredictions, forConfidence: confidenceThreshold, completionHandler: { (state) in
                completionHandler(state)
            })
        }
    }
    
    // Set proper DetectionState return value
    private func processOrderedPredictions(_ predictions: [Prediction], forConfidence confidence: Double, completionHandler: @escaping (_ : State)->()) {
        
        DispatchQueue.main.async {
            
            guard let savedRequest = self.request else {
                completionHandler(.error("Bad request"))
                return
            }
            
            if predictions.count < 1 {
                if self.userPreferences.autoConfidenceThreshold {
                    
                    if confidence > 0 {
                        let newConfidence = (confidence - confidenceStep).truncate(places: 2)
                        self.processDetections(for: savedRequest, withConfidenceThreshold: newConfidence, completionHandler: { (state) in
                            completionHandler(state)
                        })
                    } else {
                        completionHandler(.notFound)
                    }
                    
                } else {
                    completionHandler(.notFound)
                }
            } else {
                if confidence != 0 {
                    let timeElapsed = CFAbsoluteTimeGetCurrent() - self.startTime
                    completionHandler(.found(timeElapsed: timeElapsed, predictions: predictions))
                } else {
                    completionHandler(.notFound)
                }
                
            }
        }
    }
    
    // Non-maximum suppression algorithm to remove multiple similar predictions associated with a single object instance.
    private func orderPredictions(_ unorderedPredictions: [Prediction]) -> [Prediction] {
        var predictions: [Prediction] = []
        let orderedPredictions = unorderedPredictions.sorted { $0.confidence > $1.confidence }
        var keep = [Bool](repeating: true, count: orderedPredictions.count)
        for i in 0..<orderedPredictions.count {
            if keep[i] {
                predictions.append(orderedPredictions[i])
                let bbox1 = orderedPredictions[i].boundingBox
                for j in (i+1)..<orderedPredictions.count {
                    if keep[j] {
                        let bbox2 = orderedPredictions[j].boundingBox
                        if IoU(bbox1, bbox2) > nms_threshold {
                            keep[j] = false
                        }
                    }
                }
            }
        }
        return orderedPredictions
    }
    
    // Intersection-over-Union
    private func IoU(_ a: CGRect, _ b: CGRect) -> Float {
        let intersection = a.intersection(b)
        let union = a.union(b)
        return Float((intersection.width * intersection.height) / (union.width * union.height))
    }
    
    // Return the user preferences confidence threshold
    private func confidenceThreshold() -> Double {
        if userPreferences.autoConfidenceThreshold {
            return defaultAutoConfidenceThreshold
        } else {
            return Double(userPreferences.confidenceThreshold).truncate(places: 2)
        }
    }
    
    // Create the bounding box with confidence label
    func createBoundingBoxFor(imageView: UIImageView, with predictions : [Prediction]) {
        DispatchQueue.main.async {
            let originalImageSize = imageView.getCurrentImageSize()
            var boxes = [Box]()
            for prediction in predictions {
                let box = Box(rect: prediction.boundingBox, originalImageSize: originalImageSize, confidence: prediction.confidence)
                boxes.append(box)
            }
            imageView.addBoundingBoxes(boxes)
        }
    }
    
}

