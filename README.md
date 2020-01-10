# DeepGaze

An experiment in real-time object detection & classification with Flutter and Tensorflow

## A little background

I decided to do this as a joint semester project for my _Mobile Computing (CS-471)_ and _Artificial Intelligence (CS-632)_ courses. I was originally planning on using React Native but react-native-camera doesn't expose a way to recieve the camera feed in real-time because apparently, it locks up the bridge (see [#135](https://github.com/react-native-community/react-native-camera/issues/135#issuecomment-165710613))
<br>
Fortunately, I found this [article](https://blog.usejournal.com/real-time-object-detection-in-flutter-b31c7ff9ef96) by [Sha Qian](https://github.com/shaqian), which meant this was possible to achieve with Flutter.

## Install

Clone repo & run

```
flutter packages get
```

## Models

**1. Object Detection & Classification**<br>

	- SSD MobileNet v1 (Good performance but <sup>:poop:</sup> accuracy)
	- YOLO v2 (A little heavy on the resources but better accuracy)

**2. Image Segmentation**<br>

	- DeepLab v3