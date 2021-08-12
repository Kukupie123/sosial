import 'dart:typed_data';

class Story {
  Story(
      {String title,
      String summary,
      String story,
      Uint8List dp,
      String userID,
      String storyID}) {
    this._dp = dp;
    this._story = story;
    this._summary = summary;
    this._title = title;
    this._userID = userID;
    this._storyID = storyID;
  }

  // ignore: unused_field
  String _userID;

  String _storyID;

  String _title;
  String _summary;
  // ignore: unused_field
  String _story;

  // ignore: unused_field
  Uint8List _dp;

  String getSummary() {
    return _summary;
  }

  String getTitle() {
    return _title;
  }

  String getStoryID() {
    return _storyID;
  }
}
