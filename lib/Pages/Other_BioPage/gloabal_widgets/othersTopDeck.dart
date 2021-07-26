import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosial/Providers/Provider_User.dart';

class OthersTopDeck extends StatefulWidget {
  @override
  _TopDeckState createState() => _TopDeckState();
}

class _TopDeckState extends State<OthersTopDeck> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            //DATA + DP
            children: <Widget>[
              Card(
                borderOnForeground: true,
                semanticContainer: true,
                elevation: 0,
              ),
              Card(
                borderOnForeground: true,
                semanticContainer: true,
                elevation: 0,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Knows",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      // Text(
                      //   _knowsDecider(),
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              Consumer<ProviderUser>(
                builder: (context, value, child) => CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  backgroundImage: _dpDecider(),
                ),
              ),
              Card(
                borderOnForeground: true,
                semanticContainer: true,
                elevation: 0,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Known",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      // Text(
                      //   _knownDecider(),
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Consumer<ProviderUser>(
            builder: (context, value, child) => Text(
              value.name == null ? "Loading" : value.name,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Row(
            //FOLOLOW BUTTON WILL ANIMATE WHEN CLICKED
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //The follow button
              // AnimatedContainer(
              //   duration: Duration(milliseconds: 300),
              //   color: followColor,
              //   child: StreamBuilder(
              //     stream: followButtonStream,
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData == false) {
              //         return ClipRRect(
              //           borderRadius: BorderRadius.horizontal(
              //               left: Radius.circular(20),
              //               right: Radius.circular(20)),
              //           child: Text("Loading"),
              //         );
              //       } else {
              //         switch (snapshot.data) {
              //           case "loading":
              //             return ClipRRect(
              //               borderRadius: BorderRadius.horizontal(
              //                   left: Radius.circular(20),
              //                   right: Radius.circular(20)),
              //               // ignore: deprecated_member_use
              //               child: FlatButton(
              //                   onPressed: () => {}, child: Text("Loading")),
              //             );
              //           case "follows":
              //             return ClipRRect(
              //               borderRadius: BorderRadius.horizontal(
              //                   left: Radius.circular(20),
              //                   right: Radius.circular(20)),
              //               // ignore: deprecated_member_use
              //               child: FlatButton(
              //                   onPressed: () =>
              //                       onFollowPress(snapshot, followButtonSC),
              //                   color: Colors.yellow,
              //                   child: Text("Unfollow")),
              //             );
              //           case "not follows":
              //             return ClipRRect(
              //               borderRadius: BorderRadius.horizontal(
              //                   left: Radius.circular(20),
              //                   right: Radius.circular(20)),
              //               // ignore: deprecated_member_use
              //               child: FlatButton(
              //                   onPressed: () =>
              //                       onFollowPress(snapshot, followButtonSC),
              //                   color: Colors.blue,
              //                   child: Text("follow")),
              //             );
              //           default:
              //             return ClipRRect(
              //               borderRadius: BorderRadius.horizontal(
              //                   left: Radius.circular(20),
              //                   right: Radius.circular(20)),
              //               child: Text("Loading"),
              //             );
              //         }
              //       }
              //     },
              //   ),
              // ),
            ],
          )
        ],
      ),
    );
  }

  ImageProvider _dpDecider() {
    ProviderUser providerUser =
        Provider.of<ProviderUser>(context, listen: false);

    if (providerUser.dpURL != null) return NetworkImage(providerUser.dpURL);
    return AssetImage("assets/tits.gif");
  }
}
