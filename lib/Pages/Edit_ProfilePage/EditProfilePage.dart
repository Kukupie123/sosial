import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:sosial/Pages/Other_BioPage/OthersBaseBio.dart';
import 'package:sosial/Providers/Provider_Firebase.dart';

import 'globla_widgets/EditTopDeck.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Stream stream;
  StreamController sc;
  TextEditingController nickName;
  TextEditingController description;
  TextEditingController gender;

  bool isUploading = false;

  FocusNode focusName;
  FocusNode focusID;
  FocusNode focusDesc;

  FocusNode focusLoc;

  FocusNode focusGen;

  FocusNode focusPro;

  FocusNode focusDOB;

  @override
  void initState() {
    focusName = new FocusNode();

    focusID = new FocusNode();

    focusDesc = new FocusNode();

    focusLoc = new FocusNode();

    focusGen = new FocusNode();

    focusPro = new FocusNode();

    focusDOB = new FocusNode();

    super.initState();
    sc = new StreamController();
    stream = sc.stream;
    {
      nickName = TextEditingController();

      description = TextEditingController();

      gender = TextEditingController();
    }
  }

  @override
  void dispose() {
    focusName.dispose();

    focusID.dispose();

    focusDesc.dispose();

    focusLoc.dispose();

    focusGen.dispose();

    focusPro.dispose();

    focusDOB.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Edit page buit");
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    StreamBuilder(
                      stream: stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData == false) {
                          return Container();
                        } else if (snapshot.data == "loading") {
                          return CircularProgressIndicator();
                        } else if (snapshot.data == "success") {
                          return Icon(LineAwesomeIcons.heart);
                        } else {
                          return Text(snapshot.data);
                        }
                      },
                    ),
                    EditTopDeck(
                      nextFocusNode: focusDesc,
                      nickName: nickName,
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            color: Colors.white,
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                focusNode: focusDesc,
                                onSubmitted: (value) => FocusScope.of(context)
                                    .requestFocus(focusGen),
                                controller: description,
                                decoration: InputDecoration(hintText: "Bio"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 20),
                                  child: Icon(
                                    LineAwesomeIcons.female,
                                    size: 40,
                                  ),
                                ),
                                Expanded(
                                    child: TextField(
                                        focusNode: focusGen,
                                        controller: gender,
                                        onSubmitted: (value) =>
                                            focusPro.requestFocus(),
                                        decoration: InputDecoration(
                                            hintText: "Gender"))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    iconSize: 30,
                    icon: Icon(LineAwesomeIcons.gamepad),
                    onPressed: () => finalizeUpload(context)),
              ],
            )
          ],
        ),
      ),
    );
  }

  ///Assembles all the changes and turns them into maps and then sends this to the provider who will then talk to the backend
  finalizeUpload(BuildContext context) async {
    if (isUploading) return;
    isUploading = true;
    sc.add("loading");

    ProviderTEMPEDIT providerTEMPEDIT =
        Provider.of<ProviderTEMPEDIT>(context, listen: false);

    if (providerTEMPEDIT.selectedImage == null) {
      sc.add("Please Select a Picture");
      isUploading = false;

      return;
    } else if (nickName.text == null || nickName.text.trim().length <= 0) {
      sc.add("missing fields for Name");
      isUploading = false;

      return;
    } else if (description.text == null ||
        description.text.trim().length <= 0) {
      sc.add("Missing fields for Bio");
      isUploading = false;

      return;
    } else if (gender.text == null || gender.text.trim().length <= 0) {
      sc.add("Missing fields for Gender");
      isUploading = false;

      return;
    } else {
      //All fields are valid so we upload

      ProviderFirebase providerFirebase = Provider.of<ProviderFirebase>(context,
          listen: false); //Firebase provider

      var fbs = FirebaseStorage.instanceFor(app: providerFirebase.firebaseApp);

      var fbfs = FirebaseFirestore.instanceFor(
          app: providerFirebase
              .firebaseApp); //Firestore instance where instance is based on our FirebaseApp instance we created earlier

      try {
        await fbs
            .ref("dp/" + providerFirebase.userCredential.user.email + ".jpeg")
            .putData(providerTEMPEDIT.selectedImage); //uploading image
        await fbfs
            .collection("Users")
            .doc(providerFirebase.userCredential.user.uid)
            .update({
          "Name": nickName.text,
          "Bio": description.text,
          "Gender": gender.text,
        });
        //Getting Doc based on UID of User which is stored in UserCredential.user.uid and since FBApp has FBAuth set up when we login it is going to send UID as header
        //Backend has rule setup in a way that only uid header can access uid doc of
        sc.add("success");

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => OthersBaseBio(
                self: true,
              ),
            ),
            (route) => false);
        isUploading = false;

        return;
      } catch (e) {
        sc.add(e);
        isUploading = false;

        return;
      }
    }
  }
}

class ProviderTEMPEDIT extends ChangeNotifier {
  Uint8List selectedImage;
  String ext;

  setImageSeleced(Uint8List imageByte) {
    selectedImage = imageByte;
    notifyListeners();
  }
}
