import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:sosial/Providers/Provider_Firebase.dart';

class ViewStoryPage extends StatefulWidget {
  ViewStoryPage({this.storyID});
  final String storyID;
  @override
  _ViewStoryPageState createState() => _ViewStoryPageState();
}

class _ViewStoryPageState extends State<ViewStoryPage> {
  String story;
  String title;
  String uid;
  Uint8List cover;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title == null ? Text("Loading") : Text(title),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [Icon(LineAwesomeIcons.heart), Text("Like")],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 400,
                  width: 400,
                  child: Image(
                    image: cover == null
                        ? AssetImage("assets/tits.gif")
                        : MemoryImage(cover),
                    fit: BoxFit.fill,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    story == null ? "Loading" : story,
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> loadData() async {
    ProviderFirebase providerFirebase =
        Provider.of<ProviderFirebase>(context, listen: false);
    var fbfs = FirebaseFirestore.instanceFor(app: providerFirebase.firebaseApp);
    var doc = await fbfs.collection("Stories").doc(widget.storyID).get();

    if (doc.exists) {
      story = doc.get("Story");
      title = doc.get("Title");
      uid = doc.id;

      var fbs = FirebaseStorage.instanceFor(app: providerFirebase.firebaseApp);
      cover = await fbs
          .ref("StoryCovers/" + doc.get("UID") + "/" + doc.id)
          .getData();

      setState(() {});
    }
  }
}
