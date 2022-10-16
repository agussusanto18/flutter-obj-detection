import 'package:flutter/material.dart';
import 'package:obj_detection/pages/components/ResultText.dart';
import 'package:obj_detection/utils/Strings.dart';

class ResultOverlay extends StatelessWidget {
  final String detectedClass;

  const ResultOverlay({Key key, this.detectedClass}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(50)),
              child: Center(
                child: Text(
                  detectedClass,
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white.withOpacity(0.3)),
                ),
              ),
            ),
          ),
          ResultText(
              text: AppText.overlaySwipeUp,
              icon: Icons.arrow_upward),
          ResultText(
              text: AppText.overlaySwipeDown,
              icon: Icons.arrow_downward),
          ResultText(
              text: AppText.overlaySwipeLeft,
              icon: Icons.arrow_back),
          ResultText(
              text: AppText.overlaySwipeRight,
              icon: Icons.arrow_forward),
        ],
      ),
    );
  }
}
