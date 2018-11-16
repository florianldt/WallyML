import turicreate as tc

training_images = tc.load_images('images/')
print(training_images)

training_annotations = tc.SFrame('annotations.csv')
print(training_annotations)


training_data = training_images.join(training_annotations)
print(training_data)

testing_images = tc.load_images('eval_images/')
print(testing_images)

testing_annotations = tc.SFrame('annotations_evaluate.csv')
print(testing_annotations)

testing_data = testing_images.join(testing_annotations)
print(testing_data)

model = tc.object_detector.create(training_data, max_iterations = 10000)

model.save('model/annotationsgithu2.model')

predictions = model.predict(testing_data)
print(predictions[0])
print(predictions[1])
print(predictions[2])
print(predictions[4])

testing_data['predicted_image'] = tc.object_detector.util.draw_bounding_boxes(testing_data['image'], predictions)

testing_data['predicted_image'][0].show()
testing_data['predicted_image'][1].show()
testing_data['predicted_image'][2].show()
testing_data['predicted_image'][4].show()

metric = model.evaluate(testing_data)
print(metric)

model.export_coreml('model/annotationsgithu.mlmodel', include_non_maximum_suppression=False)
