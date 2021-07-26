import 'dart:async';

import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class BookLabel extends StatefulWidget {
  final String title;
  final int hearts;
  final String summary;
  final bool isHearted;
  final String id;
  const BookLabel(
      {this.hearts, this.isHearted, this.summary, this.title, this.id})
      : super();

  @override
  _BookLabelState createState() => _BookLabelState();
}

class _BookLabelState extends State<BookLabel> {
  Stream heartStatus;
  StreamController heartStatusSC;

  bool heartPressed = false;

  @override
  initState() {
    super.initState();
    heartStatusSC = new StreamController();
    heartStatus = heartStatusSC.stream;
    heartStatusSC.add("SUP");
    heartStatusSC.add("SzUP");
  }

  @override
  dispose() {
    heartStatusSC.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Colors.blueGrey[600],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 2, top: 5),
            child: Text(widget.title),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      LineAwesomeIcons.heart,
                      color: widget.isHearted ? Colors.red : Colors.black,
                    ),
                    onPressed: () async {
                      if (heartPressed == true) return;
                      heartPressed = false;
                      heartStatusSC.add("loading");
                      if (widget.isHearted) {
                      } else {}
                    },
                  ),
                  Text(widget.hearts.toString()),
                ],
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: StreamBuilder(
                    stream: heartStatus,
                    builder: (context, snapshot) {
                      if (snapshot.data == "loading")
                        return Row(
                          children: [
                            CircularProgressIndicator(),
                            Text("Please wait"),
                          ],
                        );
                      else
                        return Container();
                    },
                  ))
            ],
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Colors.blue[200]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 100,
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Text(widget.summary),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
