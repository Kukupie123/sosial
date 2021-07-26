import 'package:flutter/material.dart';

class VerticalText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 10),
      child: RotatedBox(
          quarterTurns: -1,
          child: Text(
            'SOSIAL',
            style: TextStyle(
                color: Colors.black,
                fontSize: 38,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic),
          )),
    );
  }
}
