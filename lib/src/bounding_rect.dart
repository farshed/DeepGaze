import 'package:flutter/material.dart';
import 'dart:math' as math;

class BoundingRect extends StatelessWidget {
  final List<dynamic> results;
  final int previewHeight;
  final int previewWidth;
  final double screenHeight;
  final double screenWidth;
  final String model;

  BoundingRect(this.results, this.previewHeight, this.previewWidth,
      this.screenHeight, this.screenWidth, this.model);

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: results.map((res) {
      var _x = res["rect"]["x"];
      var _w = res["rect"]["w"];
      var _y = res["rect"]["y"];
      var _h = res["rect"]["h"];
      var scaleX, scaleY, x, y, w, h;

      if (screenHeight / screenWidth > previewHeight / previewWidth) {
        scaleX = screenHeight / previewHeight * previewWidth;
        scaleY = screenHeight;
        var difW = (scaleX - screenWidth) / scaleX;
        x = (_x - difW / 2) * scaleX;
        w = _w * scaleX;
        if (_x < difW / 2) w -= (difW / 2 - _x) * scaleX;
        y = _y * scaleY;
        h = _h * scaleY;
      } else {
        scaleY = screenWidth / previewWidth * previewHeight;
        scaleX = screenWidth;
        var difH = (scaleY - screenHeight) / scaleY;
        x = _x * scaleX;
        w = _w * scaleX;
        y = (_y - difH / 2) * scaleY;
        h = _h * scaleY;
        if (_y < difH / 2) h -= (difH / 2 - _y) * scaleY;
      }

      return Positioned(
        left: math.max(0, x),
        top: math.max(0, y),
        width: w,
        height: h,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue[900],
              width: 3.0,
            ),
          ),
          child: Text(
            "${res["detectedClass"]} ${(res["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.blue[900].withOpacity(0.9),
                decoration: TextDecoration.none),
          ),
        ),
      );
    }).toList());
  }
}
