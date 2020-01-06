import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'home.dart';

class App extends StatelessWidget {
  final List<CameraDescription> cameras;

  App(this.cameras);

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'tflite real-time detection',
  //     theme: ThemeData(
  //       brightness: Brightness.dark,
  //     ),
  //     home: HomePage(cameras),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DeepGaze'),
        ),
        body: HomePage(cameras),
      ),
    );
  }
}
