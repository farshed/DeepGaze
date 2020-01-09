import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'home.dart';

class App extends StatelessWidget {
  final List<CameraDescription> cameras;

  App(this.cameras);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(cameras),
    );
  }
}
