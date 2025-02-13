# DeepGaze

An experiment in real-time object detection & classification with Flutter and Tensorflow
<br><br>
You can check it out here: https://play.google.com/store/apps/details?id=com.axiom.deepgaze

## A little background

I decided to do this as a combined semester project for my _Mobile Computing (CS-471)_ and _Artificial Intelligence (CS-632)_ courses. I originally planned on using React Native but couldn't because react-native-camera doesn't expose a way to recieve the camera feed in real-time. Apparently, streaming data to the JS thread locks up the bridge (see [#135](https://github.com/react-native-community/react-native-camera/issues/135#issuecomment-165710613)).
<br><br>
Fortunately, I found this [article](https://blog.usejournal.com/real-time-object-detection-in-flutter-b31c7ff9ef96) by [Sha Qian](https://github.com/shaqian), which meant this was possible to achieve with Flutter.

## Install

Clone repo & run

```
flutter packages get
```

## Models

1. **Object Detection & Classification**
   -  _SSD MobileNet v1_ (Good performance but relatively <sup>:poop:</sup> accuracy)
   -  _YOLO v2_ (A little heavy on the resources but better accuracy)

[//]: <> (2. **Image Segmentation**- _DeepLab v3_)

## Todo

-  [x] Allow users to switch between cameras
-  [ ] Add support for image segmentation
