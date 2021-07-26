import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosial/Pages/Edit_ProfilePage/EditProfilePage.dart';
import 'package:sosial/Pages/Other_BioPage/OthersBaseBio.dart';
import 'package:sosial/Providers/Provider_Firebase.dart';
import 'package:sosial/Providers/Provider_User.dart';

class ProfilePageDecider extends StatefulWidget {
  const ProfilePageDecider() : super();

  @override
  _ProfilePageDeciderState createState() => _ProfilePageDeciderState();
}

class _ProfilePageDeciderState extends State<ProfilePageDecider> {
  ///returns true if user has profile setup and false if not, takes data from Provider User & Provider Firebase
  Future<bool> hasProfileSetup() async {
    //Firebase provider
    ProviderFirebase providerFB =
        Provider.of<ProviderFirebase>(context, listen: false);
    FirebaseFirestore fbfs =
        FirebaseFirestore.instanceFor(app: providerFB.firebaseApp);

    //User provider
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);

    var doc = await fbfs
        .collection("Users")
        .doc(providerFB.userCredential.user.uid)
        .get();

    String name = doc.get("Name");
    if (name == "null")
      return false;
    else
      providerUser.name = name;

    String bio = doc.get("Bio");
    if (bio == "null")
      return false;
    else
      providerUser.bio = bio;

    String gender = doc.get("Gender");
    if (gender == "null")
      return false;
    else
      providerUser.gender = gender;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: hasProfileSetup(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error When trying to read profile data");
        } else if (snapshot.hasData) {
          if (snapshot.data == true) {
            return OthersBaseBio(
              self: true,
              generateFakeInfo: false,
            );
          } else
            return EditProfilePage();
        } else {
          return Text("Loading data");
        }
      },
    );
  }
}
