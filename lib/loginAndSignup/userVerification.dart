import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covac/userView/UserDashboard.dart';
import 'package:covac/utils/constants.dart';
import 'package:covac/welcome.dart';
import 'package:covac/workerView/workerDashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class UserVerification extends StatefulWidget {
  final String uidai;
  final dynamic uid;
  UserVerification(this.uidai, this.uid);
  @override
  _UserVerificationState createState() => _UserVerificationState();
}

class _UserVerificationState extends State<UserVerification> {
  var uidaiData, enteredData;
  bool verified = false;
  String role;
  uidaiDataFetch(String uidai) async {
    await FirebaseFirestore.instance
        .collection("uidaiDB")
        .doc(uidai)
        .get()
        .then((DocumentSnapshot ds) async {
      uidaiData = ds;
    });
    print(uidaiData.data());
  }

  enteredDataFetch(dynamic uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot ds) async {
      enteredData = ds;
      role = ds.data()['role'];
      print(enteredData.data());
    });
  }

  startVerfication() {
    print("in start verification");
    try {
      if (uidaiData.exists && enteredData.exists) {
        if (uidaiData.data()["firstName"].toLowerCase() ==
                enteredData.data()["firstName"].toLowerCase() &&
            uidaiData.data()["lastName"].toLowerCase() ==
                enteredData.data()["lastName"].toLowerCase() &&
            uidaiData.data()["DOB"].toLowerCase() ==
                enteredData.data()["DOB"].toLowerCase() &&
            uidaiData.data()["gender"].toLowerCase() ==
                enteredData.data()["gender"].toLowerCase() &&
            uidaiData.data()["city"].toLowerCase() ==
                enteredData.data()["city"].toLowerCase() &&
            uidaiData.data()["fatherName"].toLowerCase() ==
                enteredData.data()["fatherName"].toLowerCase() &&
            uidaiData.data()["state"].toLowerCase() ==
                enteredData.data()["state"].toLowerCase() &&
            uidaiData.data()["mobile"].toLowerCase() ==
                enteredData.data()["mobile"].toLowerCase()) {
          try {
            FirebaseFirestore.instance
                .collection("users")
                .doc(widget.uid)
                .update({
              "isVerified": true,
            });
          } catch (e) {
            print(e.toString());
          }
          setState(() {
            verified = true;
          });
        }
      } else {
        print("Error in UIDAI Verification");
      }
    } catch (e) {
      print(e.toString());
      print("Error in uidaiData or enteredData");
    }
  }

  pressed() {}

  start() async {
    await uidaiDataFetch(widget.uidai);
    await enteredDataFetch(widget.uid);
    await startVerfication();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    start();
    print(widget.uid);
    print(widget.uidai);
    print(uidaiData);
    print(enteredData);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                  (route) => false);
            },
          )
        ],
        backgroundColor: kPrimaryColor,
        elevation: 0,
        centerTitle: true,
        textTheme: Theme.of(context).textTheme,
      ),
      body: verified
          ? Container(
              child: Center(
              child: Column(
                children: <Widget>[
                  Text("You are verified."),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: size.width * 0.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: kPrimaryColor,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return role == 'public'
                                    ? UserDashboard(
                                        FirebaseAuth.instance.currentUser)
                                    : WorkerDashboard(
                                        FirebaseAuth.instance.currentUser);
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Go To Dashboard",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ))
          : Container(
              child: Center(
                  child: Column(
                children: <Widget>[
                  Text(
                      "Your entered details do not match with UIDAI Database. Please register again with correct details."),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: size.width * 0.8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: kPrimaryColor,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 40),
                        ),
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.signOut();
                          } catch (e) {
                            print(e.toString());
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Welcome();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Go to Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              )),
            ),
    );
  }
}
