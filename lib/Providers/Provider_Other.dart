import 'package:flutter/cupertino.dart';

class ProviderOther with ChangeNotifier {
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

  void deleteData() {
    this.dpURL = null;
    this.bio = null;
    this.gender = null;
    this.name = null;
    notifyListeners();
  }
}
