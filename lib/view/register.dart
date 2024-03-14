import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../customui/custombutton.dart';
import '../customui/customtextformfield.dart';
import '../util/string_const.dart';
import 'login.dart';
import 'otpcode.dart';

class logUp extends StatefulWidget {
  logUp({super.key});

  @override
  State<logUp> createState() => _logUpState();
}

class _logUpState extends State<logUp> {
  String? phoneCode = "+977";
  String? phoneNumber = "";
  bool _isConnected = true; // Default to true assuming there's internet

  @override
  void initState() {
    super.initState();
    checkInternetConnectivity(); // Check internet connectivity when widget initializes
  }

  Future<void> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConnected) {
      return Scaffold(
        body: Center(
          child: 
          Text(
            "No internet connection",
            
            style: TextStyle(fontSize: 20),
            
          ),
        ),
      );
    }

    return Scaffold(
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/CR.jpg"),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Image.asset("assets/images/UDR.png"),
              ),
              SizedBox(height: 300), // Adjust spacing according to your needs
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Enter your phone Number",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 25,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 7),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "We will send you a confirmation code",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 120),
                child: Text(
                  "Phone Number",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 17),
                width: 350,
                child: CustomForm(
                  obscureText: false,
                  labelText: "Enter phone number",
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icon(
                    Icons.phone_android,
                    color: Colors.white,
                  ),
                  fillColor: Colors.white,
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return contactValidationStr;
                    } else if (value.length != 10) {
                      return passwordLengthStr;
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  height: 45,
                  width: 350,
                  child: Custombutton(
                    onPrimary: Colors.white,
                    primary: colorStr,
                    onPressed: () {
                      sendVerificationCode(context);
                    },
                    child: Text(
                      "Next",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: colorStr,
                        thickness: 1.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        " Sign in with",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: colorStr,
                        thickness: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: colorStr,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  GoogleLogin(context);
                },
                child: SizedBox(
                  height: 40,
                  width: 220,
                  child: Row(
                    children: [
                      Icon(FontAwesomeIcons.google),
                      SizedBox(width: 20),
                      Text(
                        "Login with google",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GoogleLogin(BuildContext context) async {
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

        //to get token
        // var token =await user.getIdToken();
        // print(token);
        //or

        await user.getIdToken().then((value) {
          token = value;
          print(token);
        });
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    }
  }

  sendVerificationCode(context) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: Duration(seconds: 119),
        phoneNumber: phoneCode! + phoneNumber!,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-verification-code') {
            // Invalid verification code (OTP is incorrect), show a Snackbar
            showSnackbar('Invalid OTP. Please try again.');
          } else {
            // Handle other verification failures (e.g., SMS sending failure) here
            print('Verification failed with error code: ${e.code}');
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpCode(
                phoneNumber: phoneNumber,
                verificationId: verificationId,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {}
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
