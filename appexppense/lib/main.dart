import 'dart:async';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:appexppense/FirebaseNotification/googlesign.dart';
import 'package:appexppense/FirebaseNotification/pushNotification.dart';
import 'package:appexppense/Screens/splashScreen.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:appexppense/Screens/HomeScreen.dart';
import 'package:appexppense/Screens/LoginPage.dart';
import 'package:appexppense/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

List<CameraDescription>? cameras;

Future<void> _FirebaseBackMessage(RemoteMessage message) async {
  final _firebaseMess = FirebaseMessaging.instance;
  await _firebaseMess.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (message.notification != null) {
    Get.snackbar("Message", "Received Message");

    final token = await _firebaseMess.getToken();
    Get.snackbar(
      "Token",
      "Your Token ",
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: 'AIzaSyD9YZ99IOKqYQRQiB8iOU0neC19wl5ncSI');

  //  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_FirebaseBackMessage);

  PushNotification.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense APP',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: user != null ? SplashScreenO() : SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff443E3E),
      body: Center(
        child: Text(
          'spendWise',
          style: GoogleFonts.italianno(color: Colors.white, fontSize: 73),
        ),
      ),
    );
  }
}
