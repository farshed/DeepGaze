import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as math;
import 'constants.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  List<CameraDescription> cameras;
  final Callback setRecognitions;
  final String model;

  Camera(this.cameras, this.model, this.setRecognitions);

  @override
  CameraState createState() => new CameraState();
}

class CameraState extends State<Camera> {
  CameraController controller;
  bool isDetecting = false;
  int camIndex = 0;

  @override
  void initState() {
    super.initState();

    if (widget.cameras == null || widget.cameras.length < 1) {
      Fluttertoast.showToast(
          msg: "No cameras found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16.0);
    } else {
      controller = new CameraController(
        widget.cameras[camIndex],
        ResolutionPreset.medium,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) {
          if (!isDetecting) {
            isDetecting = true;

            Tflite.detectObjectOnFrame(
              bytesList: img.planes.map((plane) {
                return plane.bytes;
              }).toList(),
              model: widget.model == yolo ? "YOLO" : "SSDMobileNet",
              imageHeight: img.height,
              imageWidth: img.width,
              imageMean: widget.model == yolo ? 0 : 127.5,
              imageStd: widget.model == yolo ? 255.0 : 127.5,
              numResultsPerClass: 1,
              threshold: widget.model == yolo ? 0.2 : 0.4,
            ).then((recognitions) {
              widget.setRecognitions(recognitions, img.height, img.width);
              isDetecting = false;
            });
          }
        });
      });
    }
  }

  void switchCam() {
    if (widget.cameras.length > 1) {
      setState(() {
        camIndex = camIndex == 0 ? 1 : 0;
      });
    } else {
      Fluttertoast.showToast(
          msg: "No other cameras available",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16.0);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: Stack(
        children: <Widget>[
          CameraPreview(controller),
          Positioned(
            right: 100.0,
            bottom: 100.0,
            height: 35.0,
            width: 35.0,
            child: GestureDetector(
              onTap: switchCam,
              child: Icon(
                Icons.sync,
                size: 35,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
