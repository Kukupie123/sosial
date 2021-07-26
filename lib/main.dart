import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosial/Pages/Edit_ProfilePage/EditProfilePage.dart';
// ignore: unused_import
import 'package:sosial/Pages/Login_Signup/Login/BaseLogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sosial/Pages/Story_Page/Add%20Story%20Page/AddStoryPage.dart';
import 'package:sosial/Providers/Provider_Firebase.dart';
import 'package:sosial/Providers/Provider_User.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: unused_field
  final Future<FirebaseApp> _init = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ProviderFirebase>(
          create: (context) => ProviderFirebase(),
        ),
        ChangeNotifierProvider<ProviderUser>(create: (_) => ProviderUser()),
        ChangeNotifierProvider<ProviderTEMPEDIT>(
            create: (_) => ProviderTEMPEDIT())
      ],
      child: MaterialApp(
        title: 'SOSIAL',
        theme: ThemeData(),
        home: FutureBuilder<FirebaseApp>(
          future: _init,
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Backend failed to Talk to frontend");
            } else if (snapshot.connectionState == ConnectionState.done) {
              context.read<ProviderFirebase>().setFirebaseApp(snapshot.data);
              return BaseLogin();
            } else
              return Text("Loading");
          },
        ),
      ),
    );
  }
}
