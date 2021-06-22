import 'package:covac/workerView/workerDashboard.dart';
import 'package:flutter/material.dart';
import './userView/UserDashboard.dart';
import 'welcome.dart';
import 'utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var loggedIn, userID;
bool isVerified;
dynamic role;

preprocessing() async {
  User user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc("${user.uid}")
          .get()
          .then((DocumentSnapshot ds) async {
        role = ds.data()['role'];
        isVerified = ds.data()['isVerified'];
      });
    } catch (e) {
      print(e.toString());
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  preprocessing();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid Vaccine Distribution',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Scaffold(
          body: FirebaseAuth.instance.currentUser == null
              ? Welcome()
              : role == "public" && isVerified == true
                  ? UserDashboard(FirebaseAuth.instance.currentUser)
                  : role == "worker" && isVerified == true
                      ? WorkerDashboard(FirebaseAuth.instance.currentUser)
                      : Welcome()),
    );
  }
}
