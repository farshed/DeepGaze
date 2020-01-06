import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'src/app.dart';

List<CameraDescription> cams;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cams = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(App(cams));
}
