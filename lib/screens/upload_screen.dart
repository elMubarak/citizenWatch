import 'dart:io';

// import 'package:ctz_wtch/services/databaseService.dart';
import 'package:ctz_wtch/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
// class UploadScreen extends StatefulWidget {
//   static const String id = 'UploadScreen';
//   @override
//   _UploadScreenState createState() => _UploadScreenState();
// }

// class _UploadScreenState extends State<UploadScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [],
//       ),
//     );
//   }
// }
class UploadScreen extends StatefulWidget {
  static const String id = 'UploadDiscussion';
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _auth = FirebaseAuth.instance;
  // final currentUser = FirebaseAuth.instance.currentUser;
  User loggedInUser;



  Future<User> getUserEmail() async {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
    return loggedInUser;
  }

  // String getUid() {
  //   final user = currentUser;
  //   if (user != null) {
  //     loggedInUser = user;
  //      print(loggedInUser.uid);
  //   }
  //   return loggedInUser.uid;
  // }

  Future<String> getCurrentUID() async{
    return ( _auth.currentUser).uid;
  }

  File _image;
  final _picker = ImagePicker();

  getImageFile(ImageSource source) async {
    //Clicking or Picking from Gallery

    var image = await _picker.getImage(source: source);

    //Cropping the image

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      maxWidth: 512,
      maxHeight: 512,
    );

    setState(() {
      _image = croppedFile;
      print(_image.lengthSync());
      print('test');
    });
  }

  String dropdownValue;
  @override
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;
    return FutureBuilder(
      future: getUserEmail(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            elevation: 3.0,
            titleSpacing: -3.0,
            title: Text(
              'Upload Post',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'),
            ),
          ),
          body: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(15.0),
                padding: EdgeInsets.all(25.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 5.0,
                      offset: Offset(0.0, 2.5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage('images/logo.png'),
                              radius: 30,
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              'Na mairo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.5),
                      Text(snapshot.data.email),
                      SizedBox(height: 16.5),
                      TextField(
                        maxLines: 5,
                        minLines: 2,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        showCursor: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Color(0xFF666666),
                            size: defaultIconSize,
                          ),
                          fillColor: Color(0xFFF2F3F5),
                          hintStyle: TextStyle(
                              color: Color(0xFF666666),
                              fontFamily: defaultFontFamily,
                              fontSize: defaultFontSize),
                          hintText: "What Happening ?",
                        ),
                        onChanged: (value) {
                          // email = value;
                        },
                      ),
                      AuthButton(
                        name: 'UPLOAD',
                        onTap: () {
                          getImageFile(ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(15.0),
                padding: EdgeInsets.all(25.0),
                child: (_image != null)
                    ? Image.file(_image, fit: BoxFit.fill)
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
