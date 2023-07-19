import 'package:dashboard_uat_asistencia/views/home_page.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
    options: const FirebaseOptions(
      apiKey: "AIzaSyBt7xlFYrlEjh61O3D3kVbJh-rGBEEtWkg",
      authDomain: "uatasist.firebaseapp.com",
      databaseURL: "https://uatasist-default-rtdb.firebaseio.com",
      projectId: "uatasist",
      storageBucket: "uatasist.appspot.com",
      messagingSenderId: "55444668926",
      appId: "1:55444668926:web:f77a21300693da54bbc0af",
      measurementId: "G-ZFRWHW0JLJ",
    ),
  );
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  FirebaseAppCheck.instance
      .activate(webRecaptchaSiteKey: 'recaptcha-v3-site-key');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
