import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_2/view/change_password.dart';
import 'package:firebase_2/view/login.dart';
import 'package:firebase_2/view/profile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'aboutus.dart';
import 'changePassword.dart';

class ProfileUd extends StatefulWidget {
  @override
  _ProfileUdState createState() => _ProfileUdState();
}

class _ProfileUdState extends State<ProfileUd> {
  late User user;
  late String userName;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    userName = "Loading...";
    _fetchUserName(user).then((name) {
      setState(() {
        userName = name;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.photoURL ?? ""),
            ),
            SizedBox(height: 16),
            Text(
              userName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                "Manage Profile",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
                // After returning from EditProfilePage, update the user name
                _fetchUserName(user).then((name) {
                  setState(() {
                    userName = name;
                  });
                });
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(FontAwesomeIcons.lock),
              title: Text(
                "Change Password",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(FontAwesomeIcons.infoCircle),
              title: Text(
                "About Us",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutUsPage()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                "Logout",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Logout"),
                      content: Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("No"),
                        ),
                        TextButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: Text("Yes"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _fetchUserName(User user) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('credential')
        .where('email', isEqualTo: user.email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first['name'];
    }
    // Return 'Name not found' if user is not signed in or name not found in Firestore
    return 'Name not found';
  }
}
