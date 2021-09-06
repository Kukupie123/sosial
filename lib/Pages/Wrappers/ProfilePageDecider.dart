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
    //Using the persistent Firebase object
    ProviderFirebase providerFB =
        Provider.of<ProviderFirebase>(context, listen: false);
    FirebaseFirestore fbfs =
        FirebaseFirestore.instanceFor(app: providerFB.firebaseApp);

    //Using persistent User object where user's informations are stored
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);

    //Using the persistent firebase object and userID stored on persistent user object, we get the data of the user
    var doc = await fbfs
        .collection("Users")
        .doc(providerFB.userCredential.user.uid)
        .get();
    //If any of the field is "null" which will be true if we are loggin in for the first time we are going to be sent to edit profile page
    //or else we are going to go to homepage which is then going to load data again based on persistent user object's userID
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
          return Scaffold(
            body: Column(
              children: [
                CircularProgressIndicator(),
                Text("Loading Please wait"),
              ],
            ),
          );
        }
      },
    );
  }
}
