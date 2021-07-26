import 'package:flutter/material.dart';

class PasswordInput extends StatelessWidget {
  final TextEditingController controller;
  PasswordInput({@required this.controller});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 50, right: 50),
        child: Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          child: TextField(
            controller: controller,
            style: TextStyle(
              color: Colors.black,
            ),
            obscureText: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: 'Password',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
