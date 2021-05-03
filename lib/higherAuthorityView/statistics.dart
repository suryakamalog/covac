import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covac/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

const textStyle = TextStyle(
  fontSize: 16,
);

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  int totalUsersRegistered,
      totalWorkersRegistered,
      firstDosageCount,
      bothDosageCount,
      totalDosagesGiven;
  getData() async {
    await FirebaseFirestore.instance
        .collection("statistics")
        .doc("totalUsersRegistered")
        .get()
        .then((DocumentSnapshot ds) async {
      totalUsersRegistered = ds.data()['count'];
    });
    await FirebaseFirestore.instance
        .collection("statistics")
        .doc("totalWorkersRegistered")
        .get()
        .then((DocumentSnapshot ds) async {
      totalWorkersRegistered = ds.data()['count'];
    });
    await FirebaseFirestore.instance
        .collection("statistics")
        .doc("firstDosageCount")
        .get()
        .then((DocumentSnapshot ds) async {
      firstDosageCount = ds.data()['count'];
    });
    await FirebaseFirestore.instance
        .collection("statistics")
        .doc("bothDosageCount")
        .get()
        .then((DocumentSnapshot ds) async {
      bothDosageCount = ds.data()['count'];
    });
    setState(() {});
    totalDosagesGiven = firstDosageCount + bothDosageCount;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: <Widget>[
        Expanded(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 6.0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Total Users Registered: $totalUsersRegistered ',
                    style: textStyle,
                  ),
                  SizedBox(
                    //Use of SizedBox
                    height: 10,
                  ),
                  Text(
                    'Total Workers registered: $totalWorkersRegistered',
                    style: textStyle,
                  ),
                  SizedBox(
                    //Use of SizedBox
                    height: 10,
                  ),
                  Text(
                    'Number of users who got their first dosage: $firstDosageCount',
                    style: textStyle,
                  ),
                  SizedBox(
                    //Use of SizedBox
                    height: 10,
                  ),
                  Text(
                    'Number of users who got both dosages: $bothDosageCount',
                    style: textStyle,
                  ),
                  SizedBox(
                    //Use of SizedBox
                    height: 10,
                  ),
                  Text(
                    'Total Dosages given: $totalDosagesGiven',
                    style: textStyle,
                  ),
                  SizedBox(
                    //Use of SizedBox
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
      appBar: AppBar(
        title: Text(
          "Statistics",
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
