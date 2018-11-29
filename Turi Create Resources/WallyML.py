import turicreate as tc

images = tc.load_images('images/')
print(images)

annotations = tc.SFrame('annotations.csv')
print(annotations)

data = images.join(annotations)
print(data)

training_data, testing_data = data.random_split(0.95)
print(training_data)
print(testing_data)

model = tc.object_detector.create(training_data, max_iterations=5000)

model.save('model/WallyML.model')

metric = model.evaluate(testing_data)
print(metric)

model.export_coreml('model/WallyML.mlmodel', include_non_maximum_suppression=False)
