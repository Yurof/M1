import '@marcellejs/core/dist/marcelle.css';
import * as marcelle from '@marcellejs/core';


// -----------------------------------------------------------

const input = marcelle.sketchpad();
const featureExtractor = marcelle.mobilenet();

const capture = marcelle.button({ text: "Hold to record instances" });
capture.name = "Capture instances to the training set";

const instances = capture.$click
  .sample(input.$images)
  .map(async img => ({
    type: "image",
    data: img,
    label: label.$text.value,
    thumbnail: input.$thumbnails.value,
    features: await featureExtractor.process(img)
  }))
  .awaitPromises();

const store = marcelle.dataStore({ location: "localStorage" });
const trainingSet = marcelle.dataset({ name: "TrainingSet-sketch", dataStore: store });

trainingSet.capture(instances);

const label = marcelle.textfield();
label.name = "Instance label";

const trainingSetBrowser = marcelle.datasetBrowser(trainingSet);

// -----------------------------------------------------------

const classifier = marcelle.mlp({ layers: [32, 32], epochs: 20 });
const trainingButton = marcelle.button({ text: "Train" });

trainingButton.$click.subscribe(() => {
  classifier.train(trainingSet);
});

capture.$click.subscribe(() => {
  classifier.train(trainingSet);
});

const plotTraining = marcelle.trainingPlot(classifier);

// -----------------------------------------------------------

const predictions = input.$images
  .map(async img => {
    const features = await featureExtractor.process(img);
    return classifier.predict(features);
  })
  .awaitPromises();

predictions.subscribe(p => {
  label.$text.set(p.label);
});

const predViz = marcelle.classificationPlot(predictions);

// -----------------------------------------------------------

// const batchMLP = marcelle.batchPrediction({ name: "mlp", dataStore: store });
// const confMat = marcelle.confusionMatrix(batchMLP);

// predictions.subscribe(async () => {
//   await batchMLP.clear();
//   await batchMLP.predict(classifier, trainingSet);
// });

// -----------------------------------------------------------

const imgUpload = marcelle.imageUpload();
imgUpload.$images.subscribe(x => console.log("imageUpload $images:", x));

// -----------------------------------------------------------

const myDashboard = marcelle.dashboard({
  title: "Sketch",
  author: "Myself"
});

myDashboard
  .page("Data Management")
  .use("Predictions")
  .useLeft(input, label, capture, trainingButton)
  .use(predViz, plotTraining, trainingSetBrowser);
// .use(confMat);

myDashboard.page("upload").use(imgUpload);

myDashboard.start();
