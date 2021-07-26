/*Stateless NewUser page which is only built once
The widgets which are going to be updated are stacked into another class found in Stateful_implementation folder
It is done to make sure that only the parts of UI that need to be updated is updated instead of the whole page.*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sosial/Pages/Login_Signup/Login/BaseLogin.dart';
import 'package:sosial/Pages/Login_Signup/global_widgets/buttonNewUser.dart';
import 'package:sosial/Pages/Login_Signup/global_widgets/newEmail.dart';
import 'package:sosial/Pages/Login_Signup/global_widgets/newName.dart';
import 'package:sosial/Pages/Login_Signup/global_widgets/password.dart';

import 'package:sosial/Pages/Login_Signup/global_widgets/singup.dart';
import 'package:sosial/Pages/Login_Signup/global_widgets/textNew.dart';

import 'package:line_awesome_icons/line_awesome_icons.dart';

import 'package:firebase_auth/firebase_auth.dart';

class NewUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.lightBlueAccent,
                Colors.pinkAccent,
                Colors.black87
              ]),
        ),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SingUp(),
                    TextNew(),
                  ],
                ),
                NewUserBody() //The widget that is stateful and which is going to change as per the needs.
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NewUserBody extends StatefulWidget {
  NewUserBody();
  @override
  _NewUserBodyState createState() => _NewUserBodyState();
}

class _NewUserBodyState extends State<NewUserBody> {
  // ignore: unused_field
  bool _isResending;
  TextEditingController passwordController;
  TextEditingController nameController;
  TextEditingController emailController;

  StreamController signUPSC;
  StreamController signUPListenerSC;

  Stream signUPStream;
  Stream signUPListenerStream;

  StreamSubscription signupStreamSubscribtion;

  @override
  void initState() {
    super.initState();
    signUPSC = new StreamController();
    signUPListenerSC = new StreamController();
    signUPStream = signUPSC.stream;
    signUPListenerStream = signUPListenerSC.stream;
    passwordController = TextEditingController();
    nameController = TextEditingController();
    emailController = TextEditingController();
    _onSignupStreamListener();
  }

  @override
  void dispose() {
    if (!signUPSC.isClosed) signUPSC.close();
    if (!signUPListenerSC.isClosed) signUPListenerSC.close();
    signupStreamSubscribtion.cancel();
    super.dispose();
  }

  ///Will listen to the signupStream to navigate to new page when stream sends "Sucess" as data
  _onSignupStreamListener() {
    signupStreamSubscribtion = signUPListenerStream.listen((e) {
      if (e == "success") {
        Navigator.of(context).push(customCodeRoute(context));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NewName(controller: nameController),
        NewEmail(controller: emailController),
        PasswordInput(controller: passwordController),
        StreamBuilder(
          stream: signUPStream,
          initialData: "default",
          builder: (context, snapshot) {
            return _buttomSectionDecider(snapshot);
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          // ignore: deprecated_member_use
          child: FlatButton(
            onPressed: () => onSendVerificationPressed(emailController.text),
            child: Text("Resend Verification Code"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          // ignore: deprecated_member_use
          child: FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Back',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ],
    );
  }

  signupPressed(
      String name, String email, String password, BuildContext context) async {
    signUPSC.add("loading");
    print("Email : " + email + " password : " + password);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user.sendEmailVerification();

      signUPSC.add("success");
    } on FirebaseAuthException catch (e) {
      signUPSC.add(e.message);
      await Future.delayed(Duration(seconds: 2));
      signUPSC.add("default");
    }
  }

  _buttomSectionDecider(AsyncSnapshot snapshot) {
    if (snapshot.hasData == false) {
      return Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text(
              "",
              maxLines: 2,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ButtonNewUser(
              onPress: () => signupPressed(nameController.text,
                  emailController.text, passwordController.text, context),
              type: "icon",
              icon: Icons.error,
            ),
          ),
        ],
      );
    } else {
      switch (snapshot.data) {
        case "default":
          return Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  "",
                  maxLines: 2,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ButtonNewUser(
                  onPress: () => signupPressed(nameController.text,
                      emailController.text, passwordController.text, context),
                  type: "text",
                  icon: Icons.error,
                  text: "Signup",
                ),
              ),
            ],
          );
        case "loading":
          return Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  "",
                  maxLines: 2,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ButtonNewUser(
                  onPress: () => {},
                  type: "icon",
                  icon: Icons.refresh,
                ),
              ),
            ],
          );
        case "success":
          return Padding(
            padding: const EdgeInsets.fromLTRB(200, 0, 0, 0),
            child: Column(
              children: [
                Text(
                  "Verification sent!",
                  maxLines: 2,
                ),
                ButtonNewUser(
                  onPress: () {},
                  type: "icon",
                  icon: Icons.favorite,
                ),
              ],
            ),
          );
        default: //When we aren't sucessful we want to show message
          return Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  snapshot.data,
                  maxLines: 2,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: ButtonNewUser(
                  onPress: () => signupPressed(nameController.text,
                      emailController.text, passwordController.text, context),
                  type: "icon",
                  icon: Icons.error,
                ),
              ),
            ],
          );
      }
    }
  }

  customCodeRoute(BuildContext context) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => CodePage(
        codeController: TextEditingController(),
        email: emailController.text,
        name: nameController.text,
        password: passwordController.text,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        double startScale = 0.0;
        double endScale = 1.0;
        double startRotate = 0.0;
        double endRotate = 10.0;
        var scaleCurve = Curves.ease;
        var rotateCurve = Curves.slowMiddle;
        var scaleTween = Tween(begin: startScale, end: endScale)
            .chain(CurveTween(curve: scaleCurve));
        var rotateTween = Tween(begin: startRotate, end: endRotate)
            .chain(CurveTween(curve: rotateCurve));

        return ScaleTransition(
          scale: animation.drive(scaleTween),
          child: RotationTransition(
            turns: animation.drive(rotateTween),
            child: child,
          ),
        );
      },
    );
  }

  onSendVerificationPressed(String email) async {}
}

class CodePage extends StatefulWidget {
  final String name;
  final String password;
  final String email;
  final TextEditingController codeController;
  CodePage(
      {@required this.codeController,
      @required this.email,
      @required this.name,
      @required this.password});

  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  StreamController responseSC;
  Stream responseStream;

  @override
  void initState() {
    super.initState();
    responseSC = new StreamController();
    responseStream = responseSC.stream;
  }

  @override
  void dispose() {
    super.dispose();
    responseSC.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.lightBlueAccent,
                    Colors.pinkAccent,
                    Colors.black87
                  ]),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: TextField(
                      controller: widget.codeController,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        hintText: "......",
                        labelText: 'Verification Code',
                        alignLabelWithHint: true,
                        focusColor: Colors.amber,
                        labelStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.blueGrey),
                    child: GestureDetector(
                      onTap: () => onConfirmPress(widget.name, widget.email,
                          widget.codeController.text, widget.password),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LineAwesomeIcons.lightbulb_o,
                            size: 40,
                          ),
                          Text(
                            "Confirm",
                            style: TextStyle(fontSize: 30),
                          )
                        ],
                      ),
                    ),
                  ),
                  StreamBuilder(
                    stream: responseStream,
                    initialData: "default",
                    builder: (context, snapshot) =>
                        _streamDecider(snapshot, context),
                  ),
                ],
              ),
            )));
  }

  onConfirmPress(
      String name, String username, String code, String password) async {}

  _streamDecider(AsyncSnapshot snapshot, BuildContext context) {
    if (snapshot.hasData == false)
      return Container();
    else if (snapshot.data == "success") {
      _startTimer(context);
      return (Text("Verified. Returning in few sec..."));
    } else if (snapshot.data == "loading")
      return Text("Please wait verification in progress.");
    else if (snapshot.data == "default") {
      return Text("Type your code and press Confirm");
    } else {
      return Text(snapshot.data);
    }
  }

  void _startTimer(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pop(context);
    setState(() {
      Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => BaseLogin(),
          ));
    });
  }
}
