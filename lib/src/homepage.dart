import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import 'camera.dart';
import 'constants.dart';
import 'cards_list.dart';
import 'package:deepgaze/src/bounding_rect.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<dynamic> recognitions;
  int imageHeight = 0;
  int imageWidth = 0;
  String _model = "";

  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    switch (_model) {
      case yolo:
        await Tflite.loadModel(
          model: "assets/models/yolo_v2.tflite",
          labels: "assets/models/yolo_v2.txt",
        );
        break;

      case ssd:
        await Tflite.loadModel(
            model: "assets/models/ssd_mobilenet_v1.tflite",
            labels: "assets/models/ssd_mobilenet_v1.txt");
        break;

      // case deeplab:
      //   await Tflite.loadModel(model: "assets/deeplab_v3.tflite");
      //   break;

      default:
        await Tflite.loadModel(
            model: "assets/models/ssd_mobilenet_v1.tflite",
            labels: "assets/models/ssd_mobilenet_v1.txt");
    }
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  setRecognitions(recogs, imgHeight, imgWidth) {
    setState(() {
      recognitions = recogs;
      imageHeight = imgHeight;
      imageWidth = imgWidth;
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
              backgroundColor: Colors.blue[700],
            ),
            body: CardList(onSelect),
            // body: Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       RaisedButton(
            //         child: const Text(ssd),
            //         onPressed: () => onSelect(ssd),
            //       ),
            //       RaisedButton(
            //         child: const Text(yolo),
            //         onPressed: () => onSelect(yolo),
            //       ),
            //       RaisedButton(
            //         child: const Text(deeplab),
            //         onPressed: () => onSelect(deeplab),
            //       ),
            //     ],
            //   ),
            // ),
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
                BoundingRect(
                    recognitions == null ? [] : recognitions,
                    math.max(imageHeight, imageWidth),
                    math.min(imageHeight, imageWidth),
                    screen.height,
                    screen.width,
                    _model),
              ],
            ),
          );
  }
}
