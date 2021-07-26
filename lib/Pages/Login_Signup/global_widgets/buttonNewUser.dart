import 'package:flutter/material.dart';

class ButtonNewUser extends StatelessWidget {
  final Function onPress;
  final String text;
  final String type;
  final IconData icon;
  ButtonNewUser({@required this.onPress, this.icon, this.type, this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
      // ignore: deprecated_member_use
      child: FlatButton(
        onPressed: onPress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            placeWidgetBasedOnType(),
          ],
        ),
      ),
    );
  }

  Widget placeWidgetBasedOnType() {
    if (type == "text") {
      return Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      );
    } else {
      return Icon(
        icon,
        color: Colors.lightBlueAccent,
      );
    }
  }
}
