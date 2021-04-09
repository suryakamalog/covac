import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covac/utils/constants.dart';
import 'package:covac/workerView/finishVaccinationProcess.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sms_maintained/sms.dart';

import '../main.dart';

const textStyle = TextStyle(
  fontSize: 16,
);

class DosagePage extends StatefulWidget {
  final String mobile;
  final String uid;
  DosagePage(this.mobile, this.uid);
  @override
  _DosagePageState createState() => _DosagePageState();
}

class _DosagePageState extends State<DosagePage> {
  bool isFirstDosageGiven = false;
  bool isSecondDosageGiven = false;
  getData(dynamic uid) async {
    print("Inside get name fn");
    print(uid);
    await FirebaseFirestore.instance
        .collection("vaccinatedUsers")
        .doc("${widget.uid}")
        .get()
        .then((DocumentSnapshot ds) async {
      setState(() {
        isFirstDosageGiven = ds.data()['isFirstDosageGiven'];
        isSecondDosageGiven = ds.data()['isSecondDosageGiven'];
      });
    });

    print(isFirstDosageGiven);
  }

  @override
  void initState() {
    super.initState();
    getData(FirebaseAuth.instance.currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Select Dosage",
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: isFirstDosageGiven
                  ? null
                  : () {
                      print("give 1st dosage");
                      // sendOTP();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return FinishVaccinationProcess(
                                widget.uid, "first");
                            // FinishVaccinationProcess(
                            //     list[index]["OTP"], list[index]["uid"]);
                          },
                        ),
                      );
                    },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 6.0,
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        "Give First Dosage",
                        style: textStyle,
                      ),
                    )),
              ),
            ),
            GestureDetector(
              onTap: !isFirstDosageGiven || isSecondDosageGiven
                  ? null
                  : () {
                      print("give 2nd dosage");
                      // sendOTP();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return FinishVaccinationProcess(
                                widget.uid, "second");
                            // FinishVaccinationProcess(
                            //     list[index]["OTP"], list[index]["uid"]);
                          },
                        ),
                      );
                    },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 6.0,
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                        child: Text("Give Second Dosage", style: textStyle))),
              ),
            ),
          ],
        ));
  }
}
