import 'package:flutter/material.dart';

class FirstTime extends StatelessWidget {
  final Function onPressed;
  final Function onForgotPressed;
  FirstTime({@required this.onPressed, this.onForgotPressed});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Your first time?',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: onPressed,
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
