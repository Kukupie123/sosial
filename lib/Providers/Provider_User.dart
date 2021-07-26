import 'package:flutter/cupertino.dart';

class ProviderUser with ChangeNotifier {
  String name;
  String gender;
  String bio;
  String dpURL;

  void setData(String name, String gender, String bio) {
    this.name = name;
    this.gender = gender;
    this.bio = bio;
    notifyListeners();
  }

  void setDP(String dpURL) {
    this.dpURL = dpURL;
    notifyListeners();
  }
}
