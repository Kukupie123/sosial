import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:sosial/Providers/Provider_Firebase.dart';

class AddStoryPage extends StatefulWidget {
  @override
  _AddStoryPageState createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  Uint8List cover;

  bool uploadPressed = false;

  StreamController<String> progressSC;
  Stream progressS;

  TextEditingController titleController;
  TextEditingController summaryController;

  TextEditingController storyController;

  @override
  void initState() {
    super.initState();
    progressSC = new StreamController();
    progressS = progressSC.stream;

    titleController = new TextEditingController();
    summaryController = new TextEditingController();
    storyController = new TextEditingController();
  }

  @override
  void dispose() {
    progressSC.close();
    super.dispose();
  }

  Future<void> getImage() async {
    try {
      var image = await ImagePickerWeb.getImage(outputType: ImageType.bytes);

      cover = image;

      setState(() {});
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              icon: Icon(LineAwesomeIcons.upload),
              onPressed: () => _uploadStory(storyController.text,
                  summaryController.text, titleController.text))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: progressS,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == "loading")
                    return CircularProgressIndicator();
                  else if (snapshot.data == "done")
                    return Container();
                  else
                    return Text(snapshot.data);
                } else
                  return Container();
              },
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: getImage,
                        child: SizedBox(
                          height: 300,
                          width: 300,
                          child: cover == null
                              ? Image(
                                  image: AssetImage("assets/tits.gif"),
                                )
                              : Image(
                                  image: MemoryImage(cover),
                                ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: TextField(
                              controller: titleController,
                              decoration: InputDecoration(hintText: "Title"),
                              onChanged: (value) {
                                if (value.length > 100) {
                                  titleController.text = value.substring(0, 10);
                                  titleController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: titleController.text.length));
                                }
                              },
                            ),
                          ),
                          Container(
                            child: SizedBox(
                              width: 300,
                              child: TextField(
                                controller: summaryController,
                                maxLines: 8,
                                decoration:
                                    InputDecoration(hintText: "Summary"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    child: SizedBox(
                      width: double.infinity,
                      child: TextField(
                        controller: storyController,
                        maxLines: 20,
                        decoration: InputDecoration(
                            hintText: "Story", fillColor: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadStory(String story, String summary, String title) async {
    print(uploadPressed);
    if (uploadPressed) return;

    uploadPressed = true;
    progressSC.add("loading");

    if (cover == null ||
        story.trim().length <= 0 ||
        summary.trim().length <= 0 ||
        title.trim().length <= 0) {
      progressSC.add("Missing field or Story Cover");
      return;
    }

    ProviderFirebase providerFirebae =
        Provider.of<ProviderFirebase>(context, listen: false);

    print(providerFirebae.userCredential.user.uid);

    try {
      var firestore =
          FirebaseFirestore.instanceFor(app: providerFirebae.firebaseApp);
      var doc = await firestore.collection("Stories").add({
        "UID": providerFirebae.userCredential.user.uid,
        "Title": title,
        "Summary": summary,
        "Story": story,
      });

      await FirebaseStorage.instanceFor(app: providerFirebae.firebaseApp)
          .ref("StoryCovers/" +
              providerFirebae.userCredential.user.uid +
              "/" +
              doc.id)
          .putData(cover);
      uploadPressed = false;
      progressSC.add("done");
    } catch (e) {
      print("Error at Add story : " + e.toString());
      uploadPressed = false;
    }
  }
}






//Rule where we allow update and delete only if UID matches

// rules_version = '2';
// service cloud.firestore {
//   match /databases/{database}/documents {
  
  
// //Only Allow if uid matches the docID
//   match /Stories/{s}{
//       allow read,create : if request.auth.uid != null;
//       allow update,delete : if request.auth.uid == resource.data.UID
      
      

//     }
    
    
  
//   //Only Allow if uid matches the docID
//   match /Users/{userId}/{g} {
//       allow read, write: if request.auth.uid == userId;
      
      

//     }
    
    
    
//     //Allow any collection and any doc to be accessed if admin uid as created
//     // in auth section
//     match /{Collection}/{doc} {
//       allow read, write: if request.auth.uid == "Njl8WCwoUdcWoQX1PlwE92f1wvB2";

//     }

//   }
// }