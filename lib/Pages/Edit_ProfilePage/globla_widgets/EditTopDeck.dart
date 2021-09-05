import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

import '../EditProfilePage.dart';

class EditTopDeck extends StatefulWidget {
  //PICTURE FOR FUTURE
  final Function onExpandBio;
  final String userName, bio;
  final int known, knows;
  final IconData bioIcon;
  final nextFocusNode;

  final TextEditingController nickName;

  EditTopDeck({
    this.nextFocusNode,
    this.bio,
    this.known,
    this.knows,
    this.userName,
    this.onExpandBio,
    this.bioIcon,
    this.nickName,
  });

  @override
  _TopDeckState createState() => _TopDeckState();
}

class _TopDeckState extends State<EditTopDeck> {
  // variable to hold image to be displayed

  Uint8List uploadedImage;

//method to load image and update `uploadedImage`

  //Image Picker
  final picker = ImagePicker();
  Color followColor = Colors.white24;
  bool isFollowing = false;
  Color bioColor = Colors.white;
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white30,
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
              ),
              Consumer<ProviderTEMPEDIT>(
                builder: (context, value, child) => GestureDetector(
                  onTap: () => getImage(),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage: value.selectedImage == null
                        ? AssetImage("assets/tits.gif")
                        : MemoryImage(value.selectedImage),
                  ),
                ),
              ),
              Card(
                borderOnForeground: true,
                semanticContainer: true,
                elevation: 0,
              ),
            ],
          ),
          TextField(
            onSubmitted: (value) =>
                FocusScope.of(context).requestFocus(widget.nextFocusNode),
            controller: widget.nickName,
            decoration: InputDecoration(hintText: "Nick Name"),
          ),
        ],
      ),
    );
  }

  Future<void> getImage() async {
    var providerTempEdit =
        Provider.of<ProviderTEMPEDIT>(context, listen: false);

    var pickedImage =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 30);

    if (pickedImage != null) {
      try {
        var byte = await pickedImage.readAsBytes();

        providerTempEdit.setImageSeleced(byte);
      } catch (e) {
        providerTempEdit.setImageSeleced(null);
      }
    }
  }

  ImageProvider dpDecider() {
    var providerTempEdit =
        Provider.of<ProviderTEMPEDIT>(context, listen: false);

    if (providerTempEdit.selectedImage == null) {
      return AssetImage("assets/tits.gif");
    } else {
      return MemoryImage(providerTempEdit.selectedImage);
    }
  }
}
