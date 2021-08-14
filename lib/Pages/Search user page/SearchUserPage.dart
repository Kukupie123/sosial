import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'package:sosial/Model/ProfileOther.dart';
import 'package:sosial/Pages/Other_BioPage/OthersBaseBio.dart';
import 'package:sosial/Pages/Search%20user%20page/mini%20widgets/ProfileCard.dart';
import 'package:sosial/Providers/Provider_Firebase.dart';
import 'package:sosial/Providers/Provider_Other.dart';

class SearchUserPage extends StatefulWidget {
  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  List<ProfileOther> profiles;
  TextEditingController searchController;
  StreamController<String> resultSC;

  @override
  void initState() {
    super.initState();
    searchController = new TextEditingController();
    resultSC = new StreamController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: double.infinity,
            color: Colors.blueGrey,
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(hintText: "Enter user name"),
                )),
                IconButton(
                    icon: Icon(LineAwesomeIcons.search),
                    onPressed: onSearchPressed)
              ],
            ),
          ),
          StreamBuilder(
            stream: resultSC.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data) {
                  case "loading":
                    return Text("Loading");
                  case "done":
                    return _resultDecider();

                  default:
                    return Text(snapshot.data);
                }
              } else
                return Text("Search results shown here");
            },
          )
        ],
      ),
    );
  }

  Future<void> onSearchPressed() async {
    profiles = [];
    setState(() {});
    resultSC.add("loading");
    ProviderFirebase firebase =
        Provider.of<ProviderFirebase>(context, listen: false);

    var fbfs = FirebaseFirestore.instanceFor(app: firebase.firebaseApp);
    var docss = await fbfs.collection("Users").get();
    var docs = docss.docs;
    for (QueryDocumentSnapshot doc in docs) {
      if (doc.exists) {
        if (doc.id == "Njl8WCwoUdcWoQX1PlwE92f1wvB2") {
          print("Found admin");
          continue;
        }
        if (doc.id ==
            Provider.of<ProviderFirebase>(context, listen: false)
                .userCredential
                .user
                .uid) {
          print("Found user");
          continue;
        }
        String name = doc.get("Name");
        if (name.toLowerCase().contains(searchController.text.toLowerCase())) {
          //we will add this to list
          ProfileOther tempProfile = new ProfileOther();
          tempProfile.name = name;
          tempProfile.bio = doc.get("Bio");
          tempProfile.gender = doc.get("Gender");
          tempProfile.uid = doc.id;
          profiles.add(tempProfile);
        }
      }
    }
    resultSC.add("done");
  }

  Widget _resultDecider() {
    if (profiles == null) {
      return Text("Invalid results");
    } else if (profiles.length == 0) {
      return Text("No result found");
    } else
      return Expanded(
        child: ListView(
          children: List.generate(
              profiles.length,
              (i) => GestureDetector(
                    onTap: () {
                      Provider.of<ProviderOther>(context, listen: false)
                          .deleteData();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OthersBaseBio(
                              self: false,
                              uidIfOther: profiles[i].uid,
                            ),
                          ));
                    },
                    child: ProfileCard(
                      bio: profiles[i].bio,
                      gender: profiles[i].gender,
                      name: profiles[i].name,
                      uid: profiles[i].uid,
                    ),
                  )),
        ),
      );
  }

  // ListView(
  //             children: List.generate(20, (index) => ProfileCard(index)),
  //           ),
}
