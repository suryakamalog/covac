import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covac/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class UserVaccinationDetails extends StatefulWidget {
  final dynamic uid;
  UserVaccinationDetails(this.uid);
  @override
  _UserVaccinationDetailsState createState() => _UserVaccinationDetailsState();
}

class _UserVaccinationDetailsState extends State<UserVaccinationDetails> {
  bool firstDosageDataAvailable = false, secondDosageDataAvailable = false;
  String firstDosageOTP,
      firstDosageDate,
      firstDosageAddress,
      firstDosageWorkerName;
  String secondDosageOTP,
      secondDosageDate,
      secondDosageAddress,
      secondDosageWorkerName;

  getDetails(dynamic uid) async {
    await FirebaseFirestore.instance
        .collection("firstDosage")
        .doc("$uid")
        .get()
        .then((DocumentSnapshot ds) async {
      setState(() {
        firstDosageDataAvailable = true;
        firstDosageOTP = ds.data()['OTP'];
        firstDosageDate = ds.data()['date'];
        firstDosageAddress = ds.data()['address'];
        firstDosageWorkerName = ds.data()['workerName'];
      });
    }).catchError((onError) {});

    await FirebaseFirestore.instance
        .collection("secondDosage")
        .doc("$uid")
        .get()
        .then((DocumentSnapshot ds) async {
      setState(() {
        secondDosageDataAvailable = true;
        secondDosageOTP = ds.data()['OTP'];
        secondDosageDate = ds.data()['date'];
        secondDosageAddress = ds.data()['address'];
        secondDosageWorkerName = ds.data()['workerName'];
      });
    }).catchError((onError) {});
  }

  @override
  void initState() {
    super.initState();
    getDetails(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          firstDosageDataAvailable
              ? Container(
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height / 6,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 6.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              "First Dosage",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Text(
                            'OTP: $firstDosageOTP',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                          SizedBox(
                            //Use of SizedBox
                            height: 10,
                          ),
                          Text(
                            'Date: $firstDosageDate',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                          SizedBox(
                            //Use of SizedBox
                            height: 10,
                          ),
                          Text(
                            'Address: $firstDosageAddress',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                          SizedBox(
                            //Use of SizedBox
                            height: 10,
                          ),
                          Text(
                            'Worker Name: $firstDosageWorkerName',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 6.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Text(
                          //   'User Name: ${a.data()["userName"]}',
                          //   style: textStyle,
                          // ),
                          Text(
                            "Thank you for registering. You are about to get vaccinated for COVID-19. You will soon be contacted by a worker.",
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          secondDosageDataAvailable
              ? Container(
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height / 6,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 6.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              "Second Dosage",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Text(
                            'OTP: $secondDosageOTP',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                          SizedBox(
                            //Use of SizedBox
                            height: 10,
                          ),
                          Text(
                            'Date: $secondDosageDate',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                          SizedBox(
                            //Use of SizedBox
                            height: 10,
                          ),
                          Text(
                            'Address: $secondDosageAddress',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                          SizedBox(
                            //Use of SizedBox
                            height: 10,
                          ),
                          Text(
                            'Worker Name: $secondDosageWorkerName',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      appBar: AppBar(
        title: Text(
          "Vaccination Details",
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
    );
  }
}
