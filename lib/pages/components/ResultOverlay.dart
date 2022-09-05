import 'package:flutter/material.dart';
import 'package:obj_detection/pages/components/ResultText.dart';

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
          const ResultText(
              text: "Swipe up to answer correctly",
              icon: Icons.arrow_upward),
          const ResultText(
              text: "Swipe down to answer wrong",
              icon: Icons.arrow_downward),
          const ResultText(
              text: "Swipe left to repeat speech",
              icon: Icons.arrow_back),
          const ResultText(
              text: "Swipe right to scan", icon: Icons.arrow_forward),
        ],
      ),
    );
  }
}
