import 'dart:io';
import 'package:Kahani_App/login/Loading.dart';
import 'package:hive/hive.dart';
import 'package:Kahani_App/login/SignIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FirebaseAdMob.instance
  //     .initialize(appId: 'ca-app-pub-6817011623931622~1985322943');
  Directory appDocDirectory = await getApplicationDocumentsDirectory();
//   print(appDocDirectory);
//   new Directory(appDocDirectory.path + '/' + 'dir').create(recursive: true)
// // The created directory is returned as a Future.
//       .then((Directory directory) {
//     print(directory);
//     print(directory.path);
//     print(directory.absolute);
//     Hive..init('/data/user/0/com.example.Story/');
//   });
  Hive.init(appDocDirectory.path);

  await Hive.openBox('UserData');
  Hive.openBox('DiaryPassword');
  Hive.openBox('AllGoogleLogins');
  Box UserData = Hive.box('UserData');
  String UserID = UserData.get('UserID');
  print(UserID);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoadingWidget(),
      home: UserID == null ? App() : MyApp2(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {}

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return SignIn();
        }

        // Otherwise, show something whilst waiting for initialization to complete

        return LoadingWidget();
      },
    );
  }
}

class MyApp2 extends StatelessWidget {
  MyApp2({this.UserEmail, this.UserID, this.UserName, this.UserPhoto});

  final String UserEmail;
  final String UserID;
  final String UserName;
  final String UserPhoto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        // Initialize FlutterFire
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            print('SomethingWentWrong()');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return LoadingWidget();
          }

          return LoadingWidget();
        },
      ),
    );
  }
}
