import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:obj_detection/utils/constants.dart';
import 'package:vibration/vibration.dart';


Future loadModel(String _model) async {
  Tflite.close();
  try {
    String res;
    switch (_model) {
      case yolo:
        res = await Tflite.loadModel(
          model: "assets/yolov2_tiny.tflite",
          labels: "assets/yolov2_tiny.txt",
          // useGpuDelegate: true,
        );
        break;
      case ssd:
        res = await Tflite.loadModel(
          model: "assets/ssd_mobilenet.tflite",
          labels: "assets/ssd_mobilenet.txt",
          // useGpuDelegate: true,
        );
        break;
    }
    print(res);
  } on PlatformException {
    print('Failed to load model.');
  }
}


Future<void> showVibration(BuildContext context) async {
  if (await Vibration.hasVibrator()) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Vibrate!')));
    Vibration.vibrate();
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Not Vibrate!')));
  }
}