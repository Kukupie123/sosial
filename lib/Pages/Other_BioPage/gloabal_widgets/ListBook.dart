import 'package:flutter/material.dart';
import 'package:sosial/Pages/Mini%20widgets/BookLabel.dart';

class ListBook extends StatefulWidget {
  final String userID;

  ListBook({this.userID});
  @override
  _ListBookState createState() => _ListBookState();
}

class _ListBookState extends State<ListBook> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SizedBox(
      height: 500,
      child: ListView(
        children: List.generate(
            10,
            (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: BookLabel(
                    hearts: 2,
                    isHearted: true,
                    summary: "The summary of randomness is great",
                    title: "Working hours",
                  ),
                )),
      ),
    ));
  }
}
