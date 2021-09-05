import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class ProviderAdmin {
  Future<void> createUserData(
      String userID, String email, String password) async {
    //Initialise the auth object from firebase SDK
    var fba = await Firebase.initializeApp();
    var fbAuth = FirebaseAuth.instanceFor(app: fba);

    //Signing in as Administration (DO NOT DO IT IN FRONTEND IN ACTUAL PRODUCT)
    // ignore: unused_local_variable
    var a = await fbAuth.signInWithEmailAndPassword(
        email: "administrator@gmail.com", password: "1234567890");

    var fbFS = FirebaseFirestore.instanceFor(app: fba);
    DocumentSnapshot doc;

    try {
      //Getting the record of the user based on 'UserID' parameter
      doc = await fbFS.collection("Users").doc(userID).get();
    } catch (e) {
      return;
    }

    //If doc exists we are going to update the email and password as a safety check
    if (doc.exists) {
      try {
        doc.get("email");
      } catch (e) {
        await fbFS.collection("Users").doc(userID).update({"email": email});
      }

      try {
        doc.get("password");
      } catch (e) {
        await fbFS
            .collection("Users")
            .doc(userID)
            .update({"password": password});
      }

      return;
      //If doc doesn't exist we are going to create a new record in the database
    } else {
      await fbFS.collection("Users").doc(userID).set(
        {
          "Name": "null",
          "Gender": "null",
          "Bio": "null",
          "email": email,
          "password": password
        },
      );

      return;
    }
  }
}
