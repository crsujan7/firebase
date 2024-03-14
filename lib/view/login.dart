import 'package:firebase_2/customui/custombutton.dart';
import 'package:firebase_2/customui/customtextformfield.dart';
import 'package:firebase_2/provider/signupprovider.dart';
import 'package:firebase_2/util/string_const.dart';
import 'package:firebase_2/view/homepage.dart';
import 'package:firebase_2/view/profile.dart';
import 'package:firebase_2/view/profile1.dart';
import 'package:firebase_2/view/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../api/networkstatus.dart';
import '../helper/helper.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Consumer<SignUpProvider>(
          builder: (context, signUpProvider1, child) => Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                SizedBox(height: 20),
                CustomForm(
                  prefixIcon: Icon(Icons.email),
                  onChanged: (value) {
                    signUpProvider1.email = value;
                  },
                  labelText: emailStr,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return emailValidationStr;
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                CustomForm(
                    prefixIcon: Icon(Icons.lock),
                    onChanged: (value) {
                      signUpProvider1.password = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return passwordValidationStr;
                      } else {
                        return null;
                      }
                    },
                    labelText: passwordStr,
                    obscureText: signUpProvider1.showPassword ? false : true,
                    suffixIcon: signUpProvider1.showPassword
                        ? IconButton(
                            onPressed: () {
                              signUpProvider1.passwordVisibility(false);
                            },
                            icon: const Icon(Icons.visibility))
                        : IconButton(
                            onPressed: () {
                              signUpProvider1.passwordVisibility(true);
                            },
                            icon: const Icon(Icons.visibility_off))),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Handle forgot password action
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 50,
                  width: 100,
                  child: Custombutton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await signUpProvider1.loginCredentials();
                        if (signUpProvider1.logInStatus ==
                                NetworkStatus.success &&
                            signUpProvider1.isUserExist) {
                          Helper.snackBarMessage(
                              "Successfully Logged in", context);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => ProfileUd()),
                              (Route<dynamic> route) => false);
                        } else if (signUpProvider1.logInStatus ==
                                NetworkStatus.success &&
                            !signUpProvider1.isUserExist) {
                          Helper.snackBarMessage("Invalid Credential", context);
                        } else if (signUpProvider1.logInStatus ==
                            NetworkStatus.error) {
                          Helper.snackBarMessage("Failed to Save", context);
                        }
                      }
                    },
                    child: Text("Login"),
                    onPrimary: Colors.white,
                    primary: Colors.orange,
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.orange, onPrimary: Colors.white),
                    onPressed: () {
                      googleLogin();
                    },
                    child: SizedBox(
                      height: 40,
                      width: 220,
                      child: Row(
                        children: [
                          Icon(FontAwesomeIcons.google),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Login with google",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    )),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(text: 'New to Urban Drive? '),
                        TextSpan(
                          text: 'Register Here',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  googleLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Sign out in case a user is already signed in with a Google account
    await googleSignIn.signOut();

    // Prompt the user to select a Google account
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
          String? token = value;
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
      if (user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileUd(),
            ));
      }
    }
  }
}
