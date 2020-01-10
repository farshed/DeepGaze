import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'homepage.dart';

class App extends StatelessWidget {
  List<CameraDescription> cameras;

  App(this.cameras);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(cameras),
    );
  }
}
