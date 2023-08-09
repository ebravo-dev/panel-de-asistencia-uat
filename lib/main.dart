import 'package:dashboard_uat_asistencia/firebase_options.dart';
import 'package:dashboard_uat_asistencia/views/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // await Firebase.initializeApp(
  //   // options: DefaultFirebaseOptions.currentPlatform,
  //   options: const FirebaseOptions(
  //     apiKey: "AIzaSyBt7xlFYrlEjh61O3D3kVbJh-rGBEEtWkg",
  //     authDomain: "uatasist.firebaseapp.com",
  //     databaseURL: "https://uatasist-default-rtdb.firebaseio.com",
  //     projectId: "uatasist",
  //     storageBucket: "uatasist.appspot.com",
  //     messagingSenderId: "55444668926",
  //     appId: "1:55444668926:web:f77a21300693da54bbc0af",
  //     measurementId: "G-ZFRWHW0JLJ",
  //   ),
  // );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
  // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

  // FirebaseAppCheck.instance
  //     .activate(webRecaptchaSiteKey: '215a08dc-d619-4509-810e-e361699729eb');

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
