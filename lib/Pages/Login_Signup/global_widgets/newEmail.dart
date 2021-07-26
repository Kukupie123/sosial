import 'package:flutter/material.dart';

class NewEmail extends StatelessWidget {
  final TextEditingController controller;
  NewEmail({this.controller});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 50, right: 50),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: TextField(
          autocorrect: true,
          controller: controller,
          style: TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.lightBlueAccent,
            labelText: 'Email',
            labelStyle: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
