import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosial/Model/Story.dart';
import 'package:sosial/Pages/Mini%20widgets/BookLabel.dart';
import 'package:sosial/Pages/Story_Page/View%20Story%20Page/ViewStory.dart';
import 'package:sosial/Providers/Provider_Firebase.dart';

class ListStory extends StatefulWidget {
  final String userID;

  ListStory({this.userID});
  @override
  _ListStoryState createState() => _ListStoryState();
}

class _ListStoryState extends State<ListStory> {
  @override
  void initState() {
    super.initState();
    getStories();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SizedBox(
      height: 500,
      child: Consumer<TempStoryListProvider>(
          builder: (context, value, child) => childDecider()),
    ));
  }

  Widget childDecider() {
    if (Provider.of<TempStoryListProvider>(context, listen: false).stories !=
        null)
      return ListView(
        children: List.generate(
            Provider.of<TempStoryListProvider>(context, listen: false)
                .stories
                .length,
            (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewStoryPage(
                              storyID: Provider.of<TempStoryListProvider>(
                                      context,
                                      listen: false)
                                  .stories[index]
                                  .getStoryID(),
                            ),
                          ));
                    },
                    child: BookLabel(
                      hearts: 2,
                      isHearted: true,
                      summary: Provider.of<TempStoryListProvider>(context,
                              listen: false)
                          .stories[index]
                          .getSummary(),
                      title: Provider.of<TempStoryListProvider>(context,
                              listen: false)
                          .stories[index]
                          .getTitle(),
                    ),
                  ),
                )),
      );
    else
      return Text("Loading pelase waiting");
  }

  Future<void> getStories() async {
    print("Generating story for ID: " + widget.userID);
    List<Story> stories = [];
    ProviderFirebase firebase =
        Provider.of<ProviderFirebase>(context, listen: false);

    FirebaseFirestore fireStore =
        FirebaseFirestore.instanceFor(app: firebase.firebaseApp);

    QuerySnapshot docs = await fireStore.collection("Stories").get();
    for (DocumentSnapshot doc in docs.docs) {
      try {
        if (doc.id == "PLACE_HOLDER")
          continue;
        else {
          if (doc.get("UID") == widget.userID) {
            Story story = new Story(
              story: doc.get("Story"),
              storyID: doc.id,
              title: doc.get("Title"),
              userID: doc.get("UID"),
              summary: doc.get("Summary"),
            );

            stories.add(story);
          }
        }
      } catch (e) {
        print("Error in getStories in List story page");
      }
    }

    TempStoryListProvider tempStoryListProvider =
        Provider.of<TempStoryListProvider>(context, listen: false);
    tempStoryListProvider.updateStories(stories);

    print(stories.toString());
  }
}

class TempStoryListProvider with ChangeNotifier {
  List<Story> stories;

  updateStories(List<Story> stories) {
    this.stories = stories;
    notifyListeners();
  }
}
