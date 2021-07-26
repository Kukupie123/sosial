import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class ProviderAdmin {
  Future<void> createUserData(
      String userID, String email, String password) async {
    var fba = await Firebase.initializeApp();
    var fbAuth = FirebaseAuth.instanceFor(app: fba);

    var a = await fbAuth.signInWithEmailAndPassword(
        email: "administrator@gmail.com", password: "1234567890");

    var fbFS = FirebaseFirestore.instanceFor(app: fba);
    print(a.user.uid);
    DocumentSnapshot doc;

    try {
      doc = await fbFS.collection("Users").doc(userID).get();
    } catch (e) {
      print(e.toString());
      return;
    }

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




//Firestore rule

// rules_version = '2';
// service cloud.firestore {
//   match /databases/{database}/documents {
  
//   //Only Allow if uid matches the docID
//   match /Users/{userId} {
//       allow read, write: if request.auth.uid == userId;

//     }
    
//     //Allow any collection and any doc to be accessed if admin uid as created
//     // in auth section
//     match /{Collection}/{doc} {
//       allow read, write: if request.auth.uid == "Njl8WCwoUdcWoQX1PlwE92f1wvB2";

//     }

//   }
// }