import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class ProfileCard extends StatelessWidget {
  final String uid;
  final String name;
  final String gender;
  final String bio;
  ProfileCard({this.gender, this.name, this.uid, this.bio});
  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      color: Colors.blue[50],
      elevation: 1000,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(LineAwesomeIcons.user),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(name,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(gender),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(bio),
              )
            ],
          )
        ],
      ),
    );
  }
}
