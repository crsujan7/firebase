import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_2/helper/helper.dart';
import 'package:firebase_2/view/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  UploadImage({Key? key}) : super(key: key);

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? file;
  XFile? image;
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ui(context),
            Center(
              child: loader ? CircularProgressIndicator() : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    file = File(image!.path);
    setState(() {});
  }

  UploadImageToFirebase() async {
    setState(() {
      loader = true;
    });
    final storageRef = FirebaseStorage.instance.ref();
    var uploadTask = storageRef.child(image!.path).putFile(file!);
    await uploadTask.whenComplete(() async {
      var downloadUrl = await storageRef.child(image!.path).getDownloadURL();
      print(downloadUrl);
      var data = {"image": downloadUrl};
      await FirebaseFirestore.instance.collection("ImageUrl").add(data).then(
        (value) {
          setState(() {
            loader = false;
            image = null;
            file = null;
          });
        },
      );
    });
  }

  Widget ui(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
        ),
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              pickImageFromGallery();
            },
            child: DottedBorder(
              color: Colors.orange,
              padding: EdgeInsets.only(left: 50, right: 50, bottom: 30),
              child: Container(
                child: file == null
                    ? Column(
                        children: [
                          Icon(
                            Icons.upload,
                            size: 150,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            "Upload a picture",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      )
                    : Image.file(
                        file!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
        ElevatedButton(
          onPressed: () {
            UploadImageToFirebase();
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.orange,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Center(
              child: Text("Continue"),
            ),
          ),
        ),
      ],
    );
  }

  googleLogin(BuildContext context) async {
    String? token;

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        print(user!.phoneNumber);
        // var token= await user.getIdToken();
        // print(token);
        //ya mathi ko 2 line ra tal ko same ho
        await user.getIdToken().then(
          (value) {
            //aaba value ma Idtoken basxa
            token = value;
            print(token);
          },
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
      if (token != null) {
        //not equal
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()), (route) => false);
      }
    }
  }
}
