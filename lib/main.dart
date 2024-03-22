import 'package:firebase_2/provider/signupprovider.dart';
import 'package:firebase_2/view/credentialdetails.dart';
import 'package:firebase_2/view/googlemaps.dart';
import 'package:firebase_2/view/hello.dart';
import 'package:firebase_2/view/homepage.dart';
import 'package:firebase_2/view/login.dart';
import 'package:firebase_2/view/otp.dart';
import 'package:firebase_2/view/profile.dart';
import 'package:firebase_2/view/profile1.dart';
import 'package:firebase_2/view/register.dart';
import 'package:firebase_2/view/signup.dart';
import 'package:firebase_2/view/uploadimage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late bool isUserExist;

  @override
  void initState() {
    NotificationSetting();
    listenNotification();
    super.initState();
    readValueFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SignUpProvider>(
          create: (_) => SignUpProvider(),
        ),
      ],
      child: Consumer<SignUpProvider>(
        builder: (context, signUpProvider, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
                useMaterial3: true,
              ),
              // home: signUpProvider.isUserExist ? HomePage() : Login(),
              home: Login());
        },
      ),
    );
  }

  Future<void> readValueFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isUserExist = prefs.getBool('isUserExist') ?? false;
    });
  }

  NotificationSetting() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  listenNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message);
    });
  }

  getToken() async {
    String? token = await messaging.getToken();
  }
}
