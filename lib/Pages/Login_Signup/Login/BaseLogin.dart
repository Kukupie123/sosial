import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosial/Pages/Login_Signup/Signup/NewUserPage.dart';
import 'package:sosial/Pages/Login_Signup/global_widgets/first.dart';
import 'package:sosial/Pages/Login_Signup/global_widgets/loginButton.dart';
import 'package:sosial/Pages/Login_Signup/global_widgets/newEmail.dart';
import 'package:sosial/Pages/Login_Signup/global_widgets/password.dart';
import 'package:sosial/Pages/Login_Signup/global_widgets/textLogin.dart';
import 'package:sosial/Pages/Login_Signup/global_widgets/verticalText.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sosial/Pages/Wrappers/ProfilePageDecider.dart';
import 'package:sosial/Providers/Provider_Admin.dart';
import 'package:sosial/Providers/Provider_Firebase.dart';

class BaseLogin extends StatefulWidget {
  @override
  _BaseLoginState createState() => _BaseLoginState();
}

class _BaseLoginState extends State<BaseLogin> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("login builder");
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.white,
                Colors.white70,
                Colors.white60,
                Colors.black87,
              ]),
        ),
        child: ListView(
          children: <Widget>[
            LoginUI() //Stateful widget that is going to be updated as per the needs. while the rest of the UI remains static
          ],
        ),
      ),
    );
  }
}

class LoginUI extends StatefulWidget {
  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final TextEditingController emailController = new TextEditingController();

  final TextEditingController passwordController = new TextEditingController();

  StreamController loginButtonSC;
  StreamController navSC;
  Stream navStream;
  Stream loginButtonStream;
  StreamSubscription navSubscription;

  @override
  void initState() {
    super.initState();
    loginButtonSC = new StreamController();
    loginButtonStream = loginButtonSC.stream;
    navSC = new StreamController();
    navStream = navSC.stream;
    navSubscription = navStream.listen((event) {
      if (event == "success") {
        Navigator.pushNamedAndRemoveUntil(
            context, "/baseNav", (route) => false);
      } else if (event == "firstLogin") {
        Navigator.pushNamedAndRemoveUntil(
            context, "/editProfilePage", (route) => false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    loginButtonSC.close();
    navSC.close();
    navSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            VerticalText(),
            TextLogin(),
          ]),
          NewEmail(
            controller: emailController,
          ),
          PasswordInput(controller: passwordController),
          StreamBuilder(
              stream: loginButtonStream,
              builder: (context, snapshot) =>
                  loginButtonDecider(context, snapshot)),
          FirstTime(
            onPressed: signUPPressed,
          )
        ],
      ),
    );
  }

  Widget loginButtonDecider(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData == false) {
      return Container(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonLogin(
            onPress: () =>
                loginPressed(emailController.text, passwordController.text),
            icon: Icons.adjust,
            label: "Login",
          ),
        ),
      );
    }
    if (snapshot.data == "success") {
      return ButtonLogin(
        onPress: () {},
        icon: Icons.arrow_drop_down_circle,
        label: "Done",
      );
    } else if (snapshot.data == "loading") {
      return Container(
        alignment: Alignment.centerRight,
        child: ButtonLogin(
          onPress: () {},
          icon: Icons.refresh,
          label: "Loading",
        ),
      );
    } else if (snapshot.data == 'default') {
      return Container(
        alignment: Alignment.centerRight,
        child: ButtonLogin(
          onPress: () =>
              loginPressed(emailController.text, passwordController.text),
          icon: Icons.refresh,
          label: "Login",
        ),
      );
    } else {
      _resetLoginButton(5);
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.5,
                alignment: Alignment.centerLeft,
                child: Text(snapshot.data)),
            Container(
              alignment: Alignment.centerRight,
              child: ButtonLogin(
                onPress: () =>
                    loginPressed(emailController.text, passwordController.text),
                icon: Icons.add_alert,
                label: "Failed",
              ),
            ),
          ],
        ),
      );
    }
  }

  _resetLoginButton(int seconds) async {
    await Future.delayed(Duration(seconds: seconds));
    loginButtonSC.add("default");
  }

  signUPPressed() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewUserPage(),
        ));
  }

  loginPressed(String email, String password) async {
    loginButtonSC.add("loading");

    try {
      var fbAuth = FirebaseAuth.instanceFor(
          app: Provider.of<ProviderFirebase>(context, listen: false)
              .firebaseApp);
      UserCredential userCredential = await fbAuth.signInWithEmailAndPassword(
          email: email, password: password);

//Create User record if doesn't exist as Admin
      await ProviderAdmin()
          .createUserData(userCredential.user.uid, email, password);

//Store the necessary variables in provider
      Provider.of<ProviderFirebase>(context, listen: false).userCredential =
          userCredential;
      Provider.of<ProviderFirebase>(context, listen: false).firebaseAuth =
          fbAuth;

      loginButtonSC.add("success");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePageDecider(),
          ),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      loginButtonSC.add(e.message);
    }
  }
}
