import 'package:covac/workerView/workerDashboard.dart';
import 'package:flutter/material.dart';
import './userView/UserDashboard.dart';
import 'welcome.dart';
import 'utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var loggedIn, userID;
dynamic role;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  dynamic user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance
        .collection("users")
        .doc("${user.uid}")
        .get()
        .then((DocumentSnapshot ds) async {
      role = ds.data()['role'];
    });
  }
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
            : role == "public"
                ? UserDashboard(FirebaseAuth.instance.currentUser)
                : WorkerDashboard(FirebaseAuth.instance.currentUser),
      ),
    );
  }
}
