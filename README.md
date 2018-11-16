# Solving “Where’s Wally?” with Turi Create (iOS)
Source code used for my talk: Solving “Where’s Wally?” with Turi Create

## Overview
This project uses the Machine Learning framework [Turi Create](https://github.com/apple/turicreate) in order to solve the game  [“Where’s Wally?”](https://en.wikipedia.org/wiki/Where%27s_Wally%3F).

The support of this talk can be found here(soon).

The video of the talk can be found here(soon).

As explained during this talk, solving "Where's Wally?" using Machine Learning is a tough challenge for multiple reasons:
- Not a lot of data available to train the model
- Not a lot of good resolution data available
- Wally size on each picture is really small
- The complicity of the whole picture. Many colors and shapes used to make the real Wally difficult to find

As a Machine Learning novice, the goal of this project was not to have a bullet proof Wally finder, but more to see the possibilities of the Machine Learning technology and the Turi Create framwork with an interesting and fun project. 

## Create the Turi Create model on your own machine

If you want to create the Turi Create model used for this project in your own machine, the annotations files and images are also available in the [repository](https://github.com/FlorianLdt/WallyML/tree/master/Turi%20Create%20Resources).

Here are the simple steps to create it:
1. Check the [System Requirements](https://github.com/apple/turicreate#system-requirements) to check if your machine and/or Python version can run Turi Create
2. Follow the [guide](https://github.com/apple/turicreate#installation) to install Turi Create (I also recommend using virtualenv to use, install, or build Turi Create.)
3. In the `Turi Create Resources` folder, run `python WallyML.py`

## References
Turi Create documentation: https://github.com/apple/turicreate

Turi Create (Object Detection): https://apple.github.io/turicreate/docs/userguide/object_detection/

Repository containing "Where's Wally?" images for training: https://github.com/tadejmagajna/HereIsWally

## Further reading
Finding Waldo Using Semantic Segmentation & Tiramisu: https://hackernoon.com/wheres-waldo-terminator-edition-8b3bd0805741

Tensorflow project that includes a model for solving Where's Wally puzzles: https://github.com/tadejmagajna/HereIsWally

How to Find Wally with a Neural Network: https://towardsdatascience.com/how-to-find-wally-neural-network-eddbb20b0b90

## Contact
If you have a question or any comment, feel free to open an issue or to DM me on [@florianldt](https://twitter.com/florianldt).
