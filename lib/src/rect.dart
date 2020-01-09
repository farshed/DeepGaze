import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'constants.dart';

class Rect extends StatelessWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final String model;

  Rect(this.results, this.previewH, this.previewW, this.screenH, this.screenW,
      this.model);

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: results.map((res) {
      var _x = res["rect"]["x"];
      var _w = res["rect"]["w"];
      var _y = res["rect"]["y"];
      var _h = res["rect"]["h"];
      var scaleW, scaleH, x, y, w, h;

      if (screenH / screenW > previewH / previewW) {
        scaleW = screenH / previewH * previewW;
        scaleH = screenH;
        var difW = (scaleW - screenW) / scaleW;
        x = (_x - difW / 2) * scaleW;
        w = _w * scaleW;
        if (_x < difW / 2) w -= (difW / 2 - _x) * scaleW;
        y = _y * scaleH;
        h = _h * scaleH;
      } else {
        scaleH = screenW / previewW * previewH;
        scaleW = screenW;
        var difH = (scaleH - screenH) / scaleH;
        x = _x * scaleW;
        w = _w * scaleW;
        y = (_y - difH / 2) * scaleH;
        h = _h * scaleH;
        if (_y < difH / 2) h -= (difH / 2 - _y) * scaleH;
      }

      return Positioned(
        left: math.max(0, x),
        top: math.max(0, y),
        width: w,
        height: h,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(4, 64, 223, 1.0),
              width: 3.0,
            ),
          ),
          child: Text(
            "${res["detectedClass"]} ${(res["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                backgroundColor: Color.fromRGBO(4, 64, 223, 1.0),
                decoration: TextDecoration.none),
          ),
        ),
      );
    }).toList());
  }
}
