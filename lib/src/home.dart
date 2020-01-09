import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'camera.dart';
import 'Rect.dart';
import 'constants.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    switch (_model) {
      case yolo:
        await Tflite.loadModel(
          model: "assets/yolo_v2.tflite",
          labels: "assets/yolo_v2.txt",
        );
        break;

      case ssd:
        await Tflite.loadModel(
            model: "assets/ssd_mobilenet_v1.tflite",
            labels: "assets/ssd_mobilenet_v1.txt");
        break;

      case deeplab:
        await Tflite.loadModel(model: "assets/deeplab_v3.tflite");
        break;

      default:
        await Tflite.loadModel(
            model: "assets/ssd_mobilenet_v1.tflite",
            labels: "assets/ssd_mobilenet_v1.txt");
    }
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  Future<bool> onBackPress() {
    setState(() {
      _model = "";
    });
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return _model == ""
        ? Scaffold(
            appBar: AppBar(
              title: const Text('DeepGaze'),
              backgroundColor: Colors.indigo[500],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: const Text(ssd),
                    onPressed: () => onSelect(ssd),
                  ),
                  RaisedButton(
                    child: const Text(yolo),
                    onPressed: () => onSelect(yolo),
                  ),
                  RaisedButton(
                    child: const Text(deeplab),
                    onPressed: () => onSelect(deeplab),
                  ),
                ],
              ),
            ),
          )
        : WillPopScope(
            onWillPop: onBackPress,
            child: Stack(
              children: [
                Camera(
                  widget.cameras,
                  _model,
                  setRecognitions,
                ),
                Rect(
                    _recognitions == null ? [] : _recognitions,
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width,
                    _model),
              ],
            ),
          );
  }
}
