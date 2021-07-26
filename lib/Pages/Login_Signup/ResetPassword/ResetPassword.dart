import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sosial/Pages/Login_Signup/Login/BaseLogin.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController codeController;

  StreamController resetSC;
  Stream resetStream;

  StreamController confirmSC;
  Stream confirmStream;
  StreamSubscription confirmSubscription;
  @override
  void initState() {
    super.initState();
    resetSC = new StreamController();
    resetStream = resetSC.stream;
    confirmSC = new StreamController();
    confirmStream = confirmSC.stream;
    confirmSubscription = confirmStream.listen((event) {
      if (event == 'success') {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BaseLogin(),
            ));
      }
    });
    emailController = new TextEditingController();
    passwordController = new TextEditingController();
    codeController = new TextEditingController();
  }

  @override
  void dispose() {
    resetSC.close();
    confirmSubscription.cancel();
    confirmSC.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    resetStream = resetSC.stream;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.black87,
                Colors.white,
                Colors.white70,
                Colors.white60,
              ]),
        ),
        child: SafeArea(
            child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    "Reset Password",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: (InputDecoration(hintText: "Email")),
                        ),
                        StreamBuilder(
                            stream: resetStream,
                            builder: (context, snapshot) => AnimatedSwitcher(
                                duration: Duration(milliseconds: 300),
                                child: _bottomDecider(snapshot)))
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        )),
      ),
    );
  }

  _bottomDecider(AsyncSnapshot snapshot) {
    if (snapshot.hasData == false) {
      // ignore: deprecated_member_use
      return FlatButton(
          onPressed: () => _onsendCodePressed(emailController.text),
          child: Text("Send verification code"));
    } else {
      switch (snapshot.data) {
        case "success":
          return Column(
            children: [
              TextField(
                controller: codeController,
                decoration: InputDecoration(hintText: "Confirmation Code"),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(hintText: "New Password"),
              ),
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () => _onConfirmChanges(emailController.text,
                      codeController.text, passwordController.text),
                  child: Text("Confirm changes")),
            ],
          );
          break;
        default:
          return Column(
            children: [
              Text(snapshot.data),
              TextField(
                controller: codeController,
                decoration: InputDecoration(hintText: "Confirmation Code"),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(hintText: "New Password"),
              ),
              // ignore: deprecated_member_use
              FlatButton(
                  onPressed: () => _onConfirmChanges(emailController.text,
                      codeController.text, passwordController.text),
                  child: Text("Confirm changes")),
            ],
          );
      }
    }
  }

  _onsendCodePressed(String email) async {}

  _onConfirmChanges(String email, String code, String password) async {}
}
