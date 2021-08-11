import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:sosial/Pages/Other_BioPage/gloabal_widgets/ListStory.dart';
import 'package:sosial/Pages/Story_Page/Add%20Story%20Page/AddStoryPage.dart';
import 'package:sosial/Providers/Provider_Firebase.dart';
import 'package:sosial/Providers/Provider_User.dart';

import 'gloabal_widgets/othersTopDeck.dart';

class OthersBaseBio extends StatefulWidget {
  final bool self;
  final String uidIfOther;
  final bool generateFakeInfo;

  OthersBaseBio({this.self, this.uidIfOther, this.generateFakeInfo});
  @override
  _OthersBaseBioState createState() => _OthersBaseBioState();
}

class _OthersBaseBioState extends State<OthersBaseBio> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    await Future.delayed(Duration(seconds: 2));

    // if (fakeInfo) {
    //   //DEBUG PURPOSE
    //   providerUser.setData("Fake name", "Fake Gender", "Fake Bio");
    //   return;
    // }
    if (widget.self) {
      ProviderFirebase providerFirebase =
          Provider.of<ProviderFirebase>(context, listen: false);
      var fbfs =
          FirebaseFirestore.instanceFor(app: providerFirebase.firebaseApp);
      var doc = await fbfs
          .collection("Users")
          .doc(providerFirebase.userCredential.user.uid)
          .get();

      String bio = doc.get("Bio");
      String gender = doc.get("Gender");
      String name = doc.get("Name");

      providerUser.setData(name, gender, bio);

      String email = providerFirebase.userCredential.user.email;

      String dpURL =
          await FirebaseStorage.instanceFor(app: providerFirebase.firebaseApp)
              .ref("dp/" + email + ".jpeg")
              .getDownloadURL();

      //ENABLE CORS IN FBS

      providerUser.setDP(dpURL);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("other bio page buit");
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Stack(children: [
                  OthersTopDeck(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: IconButton(
                        color: Colors.black,
                        icon: Icon(LineAwesomeIcons.refresh),
                        onPressed: () => onRefresh(context)),
                  )
                ]),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 20),
                        child: Icon(
                          LineAwesomeIcons.sort_desc,
                          size: 40,
                        ),
                      ),
                      Consumer<ProviderUser>(
                        builder: (context, value, child) => Text(
                          value.bio == null || value.bio.trim().length <= 0
                              ? "Loading"
                              : value.bio,
                        ),
                      ),
                    ],
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
                      Consumer<ProviderUser>(
                        builder: (context, value, child) => Text(
                          _genderDecider(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: _postStoryButtonDecider(),
                ),
                ListStory(
                  userID: widget.self
                      ? Provider.of<ProviderFirebase>(context, listen: false)
                          .userCredential
                          .user
                          .uid
                      : widget.uidIfOther,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onRefresh(BuildContext context) {}

  String _genderDecider() {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    if (providerUser.gender == null) {
      return "Loading";
    }
    return providerUser.gender;
  }

  Widget _postStoryButtonDecider() {
    if (widget.self)
      // ignore: deprecated_member_use
      return RaisedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LineAwesomeIcons.plus,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text("Add new story"),
              )
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddStoryPage(),
                ));
          });
    return Container();
  }

  Widget _searchButtonDecider() {
    if (widget.self) {
      return IconButton(icon: Icon(LineAwesomeIcons.search), onPressed: () {});
    } else {
      return Row(
        children: [
          IconButton(icon: Icon(LineAwesomeIcons.search), onPressed: () {}),
          IconButton(icon: Icon(LineAwesomeIcons.home), onPressed: () {})
        ],
      );
    }
  }
}
