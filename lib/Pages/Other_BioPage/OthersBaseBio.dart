import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:sosial/Pages/Edit_ProfilePage/EditProfilePage.dart';
import 'package:sosial/Pages/Other_BioPage/gloabal_widgets/ListStory.dart';
import 'package:sosial/Pages/Search%20user%20page/SearchUserPage.dart';
import 'package:sosial/Pages/Story_Page/Add%20Story%20Page/AddStoryPage.dart';
import 'package:sosial/Providers/Provider_Firebase.dart';
import 'package:sosial/Providers/Provider_Other.dart';
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
    print("Loading data");
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);
    ProviderOther providerOther =
        Provider.of<ProviderOther>(context, listen: false);
    await Future.delayed(Duration(seconds: 2));

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
    } else {
      print("Loading profile of other " + widget.uidIfOther);
      ProviderFirebase providerFirebase =
          Provider.of<ProviderFirebase>(context, listen: false);
      var fbfs =
          FirebaseFirestore.instanceFor(app: providerFirebase.firebaseApp);
      var doc = await fbfs.collection("Users").doc(widget.uidIfOther).get();

      String bio = doc.get("Bio");
      String gender = doc.get("Gender");
      String name = doc.get("Name");
      providerOther.setData(name, gender, bio);
      String email = doc.get("email");
      String dpURL =
          await FirebaseStorage.instanceFor(app: providerFirebase.firebaseApp)
              .ref("dp/" + email + ".jpeg")
              .getDownloadURL();

      //ENABLE CORS IN FBS

      providerOther.setDP(dpURL);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.self == false) {
      Provider.of<ProviderOther>(context, listen: false).deleteData();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("other bio page buit");
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.lightBlueAccent,
                Colors.lightBlue,
                Colors.black87
              ]),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.lightBlue[200],
                      Colors.pink[50],
                      Colors.black12
                    ]),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Stack(children: [
                    OthersTopDeck(widget.self),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          _iconButtonDecider(),
                          _searchButtonDecider()
                        ],
                      ),
                    ),
                  ]),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 20),
                          child: Icon(
                            LineAwesomeIcons.sort_desc,
                            size: 40,
                          ),
                        ),
                        _bioDecider()
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 20),
                          child: Icon(
                            LineAwesomeIcons.female,
                            size: 40,
                          ),
                        ),
                        Consumer<ProviderOther>(
                          builder: (context, value, child) =>
                              Consumer<ProviderUser>(
                            builder: (context, value, child) => Text(
                              _genderDecider(),
                            ),
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
      ),
    );
  }

  Widget _iconButtonDecider() {
    if (widget.self) {
      return IconButton(
        color: Colors.black,
        icon: Icon(LineAwesomeIcons.edit),
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfilePage(),
              ))
        },
      );
    } else
      return Container();
  }

  Widget _bioDecider() {
    if (widget.self) {
      return Consumer<ProviderUser>(
        builder: (context, value, child) => Text(
          value.bio == null || value.bio.trim().length <= 0
              ? "Loading"
              : value.bio,
        ),
      );
    } else
      return Consumer<ProviderOther>(
        builder: (context, value, child) => Text(
          value.bio == null || value.bio.trim().length <= 0
              ? "Loading"
              : value.bio,
        ),
      );
  }

  onRefresh(BuildContext context) {
    loadData();
  }

  String _genderDecider() {
    if (widget.self) {
      ProviderUser providerUser =
          Provider.of<ProviderUser>(context, listen: false);
      if (providerUser.gender == null) {
        return "Loading";
      }
      return providerUser.gender;
    } else {
      ProviderOther providerUser =
          Provider.of<ProviderOther>(context, listen: false);
      if (providerUser.gender == null) {
        return "Loading";
      }
      return providerUser.gender;
    }
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
      return Row(
        children: [
          IconButton(
              icon: Icon(LineAwesomeIcons.search),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchUserPage(),
                    ));
              }),
        ],
      );
    } else {
      return Row(
        children: [
          IconButton(icon: Icon(LineAwesomeIcons.search), onPressed: () {}),
          IconButton(
              icon: Icon(LineAwesomeIcons.home),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OthersBaseBio(
                        self: true,
                      ),
                    ),
                    (route) => false);
              })
        ],
      );
    }
  }
}
