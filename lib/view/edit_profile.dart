import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login.dart';
import 'profile.dart';

class EditProfilePage extends StatefulWidget {
  final User? user;
  final Map<String, dynamic>? userData;

  EditProfilePage({required this.user, this.userData});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _phone;
  String? _address;

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('credential');

  @override
  void initState() {
    super.initState();
    final User? user = widget.user;

    if (user != null) {
      _name = user.displayName;
      _email = user.email;
      _phone = user.phoneNumber;
    }

    // Fetch additional user data from Firestore and set the address
    if (widget.userData != null) {
      _address = widget.userData!['address'] as String?;
    }

    // Fetch additional user data from Firestore using user's UID
    FirebaseFirestore.instance
        .collection('credential')
        .doc(user!.uid)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        setState(() {
          _name = docSnapshot.get('name');
          _phone = docSnapshot.get('phone');
          _address = docSnapshot.get('address');
        });
      }
    }).catchError((error) {
      print('Error fetching user data: $error');
    });
  }

  Future<void> _updateProfile() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updateProfile(displayName: _name);

        if (_email != null) {
          await user.updateEmail(_email!);
        }

        await _usersCollection.doc(user.uid).update({
          'name': _name,
          'email': _email,
          'phone': _phone,
          'address': _address,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );

        Navigator.pop(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage()), // Pass user here
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  Future<void> _deleteProfile() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _usersCollection.doc(user.uid).delete();
        await user.delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile deleted successfully')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 75,
                  backgroundImage: NetworkImage(
                    user?.photoURL ??
                        'https://www.example.com/default-image.jpg',
                  ),
                ),
                SizedBox(height: 20),
                buildProfileField("Name", _name, (value) => _name = value),
                buildProfileField("Email", _email, (value) => _email = value),
                buildProfileField("Contact", _phone, (value) => _phone = value),
                buildProfileField(
                    "Address", _address, (value) => _address = value),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _updateProfile();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text(
                        'Update Profile',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        _deleteProfile();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text(
                        'Delete Profile',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileField(
      String label, String? value, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        initialValue: value,
        onChanged: onChanged,
        style: TextStyle(fontSize: 18),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              fontSize: 16,
              color: Colors.black), // Changed label color to black
          border: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.black), // Added outline border color
          ),
        ),
      ),
    );
  }
}
