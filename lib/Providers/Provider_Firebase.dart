import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class ProviderFirebase {
  FirebaseApp firebaseApp;
  UserCredential userCredential;
  FirebaseAuth firebaseAuth;

  setFirebaseApp(FirebaseApp fba) {
    firebaseApp = fba;
    print("New FBA set");
  }
}


//For Authentication and Firestore to work it needs to use this "firebaseApp" instance and not create it's own instance