//
//  FinderViewController.swift
//  WallyML
//
//  Created by Florian LUDOT on 11/15/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit

class FinderViewController: UIViewController {
    
    let waldoMLEngine: WallyMLEngine
    
    let imageToAnalyse: UIImage
    let userPreferences: UserPreferences
    
    var predictions: [Prediction]?
    
    var infoBarButton: UIBarButtonItem!
    var dismissBarButton: UIBarButtonItem!
    var settingBarButton: UIBarButtonItem!
    var toggleBoundingBoxBarButton: UIBarButtonItem!
    var activityIndictor: UIActivityIndicatorView!
    var loadingBarButton: UIBarButtonItem!
    
    private var imageScrollView: ImageScrollView!
    
    let findWaldoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 195/255, green: 46/255, blue: 38/255, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        return button
    }()
    
    let confidenceView = ConfidenceView(frame: .zero)
    
    init(preferences: UserPreferences = UserPreferences(), waldoMLEngine: WallyMLEngine = WallyMLEngine(), imageToAnalyse image: UIImage) {
        self.imageToAnalyse = image
        self.userPreferences = preferences
        self.waldoMLEngine = waldoMLEngine
        super.init(nibName: nil, bundle: nil)
        title = "WallyML"
        self.waldoMLEngine.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = .black
        setupBarButtonItems()
        
        navigationItem.leftBarButtonItem = dismissBarButton
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 195/255, green: 46/255, blue: 38/255, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        imageScrollView = ImageScrollView(image: self.imageToAnalyse)
        
        view.backgroundColor = UIColor(red: 195/255, green: 46/255, blue: 38/255, alpha: 1)
        
        view.addSubview(findWaldoButton)
        view.addSubview(imageScrollView)
        view.addSubview(confidenceView)
        
        findWaldoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        findWaldoButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        findWaldoButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        findWaldoButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: findWaldoButton.topAnchor, constant: 0).isActive = true
        
        confidenceView.topAnchor.constraint(equalTo: imageScrollView.topAnchor, constant: 0).isActive = true
        confidenceView.leftAnchor.constraint(equalTo: imageScrollView.leftAnchor, constant: 0).isActive = true
        confidenceView.rightAnchor.constraint(equalTo: imageScrollView.rightAnchor, constant: 0).isActive = true
        confidenceView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.updateDetectionState(with:.initialized)
        
    }
    
    override func viewDidLayoutSubviews() {
        imageScrollView.setZoomScale()
    }
    
    @objc func dismissFinderViewController() {
        dismiss(animated: true) {
            return
        }
    }
    
    private func setupBarButtonItems() {
        self.infoBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "list"), style: .plain, target: self, action: #selector(displayPredictionsDetail))
        self.dismissBarButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissFinderViewController))
        self.settingBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "setting"), style: .plain, target: self, action: #selector(displaySettings))
        
        let toggleBoundingBoxButton = UIButton()
        toggleBoundingBoxButton.setImage(#imageLiteral(resourceName: "visibility"), for: .normal)
        toggleBoundingBoxButton.addTarget(self, action: #selector(hideBoundingBox), for: .touchDown)
        toggleBoundingBoxButton.addTarget(self, action: #selector(showBoundingBox), for: .touchUpInside)
        self.toggleBoundingBoxBarButton = UIBarButtonItem(customView: toggleBoundingBoxButton)
        self.activityIndictor = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        self.loadingBarButton = UIBarButtonItem(customView: self.activityIndictor)
    }
    
    @objc func displaySettings() {
        let settingsViewController = SettingsViewController()
        self.navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    @objc func displayPredictionsDetail() {
        guard let predictions = self.predictions else {
            return
        }
        let predictionsViewController = PredictionDetailViewController(predictions: predictions)
        self.navigationController?.pushViewController(predictionsViewController, animated: true)
    }
    
    @objc func process() {
        self.updateDetectionState(with:.searching)
        guard let image = self.imageScrollView.getCurrentImage(), let ciImage = CIImage(image: image) else {
            updateDetectionState(with: .error("Something is wrong with the image"))
            return
        }
        
        waldoMLEngine.start(with: .ciImage(ciImage: ciImage)) { [weak self] (state) in
            guard let strongSelf = self else { return }
            strongSelf.updateDetectionState(with: state)
        }
    }
    
    @objc func hideBoundingBox() {
        self.imageScrollView.hideBoundingBox()
    }
    
    @objc func showBoundingBox() {
        self.imageScrollView.showBoundingBox()
    }
    
    private func updateDetectionState(with state: WallyMLEngine.State) {
        switch state {
        case .initialized:
            setInitializesState()
        case .searching:
            setSearchingState()
        case .found(let timeElapsed, let predictions):
            setFoundState(timeElapsed: timeElapsed, predictions: predictions)
        case .notFound:
            setNoFoundState()
        case .error(let error):
            setErrorState(error)
        }
    }
    
    @objc private func reinitialiseSearch () {
        self.imageScrollView.clearBoundingBoxes()
        updateDetectionState(with: .initialized)
    }
    
    private func setInitializesState() {
        self.predictions = nil
        self.navigationItem.rightBarButtonItems = [settingBarButton]
        self.findWaldoButton.isEnabled = true
        self.findWaldoButton.setImage(nil, for: .normal)
        self.findWaldoButton.setTitle("Find him", for: .normal)
        self.findWaldoButton.removeTarget(self, action: #selector(reinitialiseSearch), for: .touchUpInside)
        self.findWaldoButton.addTarget(self, action: #selector(process), for: .touchUpInside)
        self.confidenceView.confidenceLabel.text = "Confidence threshold: \(userPreferences.confidenceThreshold)"
    }
    
    private func setSearchingState() {
        self.findWaldoButton.isEnabled = false
        self.navigationItem.rightBarButtonItems = [loadingBarButton]
        self.activityIndictor.startAnimating()
        self.findWaldoButton.setTitle("Searching...", for: .normal)
    }
    
    private func setFoundState(timeElapsed: Double, predictions: [Prediction]) {
        self.predictions = predictions
        waldoMLEngine.createBoundingBoxFor(imageView: self.imageScrollView.imageView, with: predictions)
        self.navigationItem.rightBarButtonItems = [infoBarButton, toggleBoundingBoxBarButton]
        self.findWaldoButton.setImage(#imageLiteral(resourceName: "refresh"), for: .normal)
        self.findWaldoButton.adjustsImageWhenHighlighted = false
        self.findWaldoButton.setTitle(" Found! (\(timeElapsed.truncate(places: 4))s)", for: .normal)
        self.findWaldoButton.removeTarget(self, action: #selector(process), for: .touchUpInside)
        self.findWaldoButton.addTarget(self, action: #selector(reinitialiseSearch), for: .touchUpInside)
        self.findWaldoButton.isEnabled = true
    }
    
    private func setNoFoundState() {
        self.navigationItem.rightBarButtonItems = [settingBarButton]
        self.findWaldoButton.setImage(#imageLiteral(resourceName: "refresh"), for: .normal)
        self.findWaldoButton.setTitle(" Not found!", for: .normal)
        self.findWaldoButton.isEnabled = true
        self.findWaldoButton.removeTarget(self, action: #selector(process), for: .touchUpInside)
        self.findWaldoButton.addTarget(self, action: #selector(reinitialiseSearch), for: .touchUpInside)
    }
    
    private func setErrorState(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.reinitialiseSearch()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension FinderViewController: WallyMLEngineDelegate {
    
    func didConfidenceChanged(newValue: Double) {
        self.confidenceView.confidenceLabel.text = "Confidence threshold: \(newValue)"
    }
    
}
