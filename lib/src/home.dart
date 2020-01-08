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
    String res;
    switch (_model) {
      case yolo:
        res = await Tflite.loadModel(
          model: "assets/yolo_v2.tflite",
          labels: "assets/yolo_v2.txt",
        );
        break;

      case ssd:
        res = await Tflite.loadModel(
            model: "assets/ssd_mobilenet_v1.tflite",
            labels: "assets/ssd_mobilenet_v1.txt");
        break;

      case deeplab:
        res = await Tflite.loadModel(model: "assets/deeplab_v3.tflite");
        break;

      default:
        res = await Tflite.loadModel(
            model: "assets/ssd_mobilenet_v1.tflite",
            labels: "assets/ssd_mobilenet_v1.txt");
    }
    // print(res);
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

  onBackPress() {
    this.setState(() {
      _model = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
        body: _model == ""
            ? Center(
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
              )
            : WillPopScope(
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
                onWillPop: onBackPress,
              ));
  }
}
