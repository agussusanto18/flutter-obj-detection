import 'package:flutter/material.dart';

class ResultText extends StatelessWidget {
  const ResultText({Key key, this.text, this.icon}) : super(key: key);
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.3),
          size: 35,
        ),
        Padding(padding: EdgeInsets.only(right: 15)),
        Text(
          text,
          style: TextStyle(
              fontSize: 25,
              color: Colors.white.withOpacity(0.3)),
        )
      ],
    );
  }
}
