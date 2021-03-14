import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covac/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import '../main.dart';

const textStyle = TextStyle(
  fontSize: 16,
);

class UserDetailCard extends StatefulWidget {
  final dynamic particularUser;
  UserDetailCard(this.particularUser);
  @override
  _UserDetailCardState createState() => _UserDetailCardState();
}

class _UserDetailCardState extends State<UserDetailCard> {
  String _date = "Choose Date";
  bool hasVaccinationStarted = false;
  // String _date = DateTime.now();
  String currentWorkerName;
  getName(dynamic uid) async {
    print("Inside get name fn");
    print(uid);
    await FirebaseFirestore.instance
        .collection("users")
        .doc("$uid")
        .get()
        .then((DocumentSnapshot ds) async {
      currentWorkerName = ds.data()['name'];
    });
  }

  checkIfVaccinationHasStarted(dynamic uid) async {
    print("inside check");
    var a = await FirebaseFirestore.instance
        .collection("vaccinatedUsers")
        .doc("$uid")
        .get();
    if (a.exists) {
      print("inside check ------true");
      setState(() {
        hasVaccinationStarted = true;
      });
    }
    if (!a.exists) {
      print("inside check ------false");
      setState(() {
        hasVaccinationStarted = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getName(FirebaseAuth.instance.currentUser.uid);
    checkIfVaccinationHasStarted(widget.particularUser['uid']);
  }

  gotoMap() {}
  startVaccination() {
    //input date
    print(_date);
    //send OTP to user phoneNumber
    FirebaseFirestore.instance
        .collection("vaccinatedUsers")
        .doc(widget.particularUser['uid'])
        .set({
      "userName": "${widget.particularUser["name"]}",
      "workerName": "$currentWorkerName",
      "date": "$_date",
      "address": "${widget.particularUser["address"]}",
      "isVaccinated": false,
      // "OTP": "$_date",
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    Future<void> _selectDate(BuildContext context) async {
      DateTime selectedDate = DateTime.now();

      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020, 1),
          lastDate: DateTime(2120));
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
        });
    }

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
                    'Name: ${widget.particularUser["name"]}',
                    style: textStyle,
                  ),
                  SizedBox(
                    //Use of SizedBox
                    height: 10,
                  ),
                  Text(
                    'Father\'s Name: ${widget.particularUser["fatherName"]}',
                    style: textStyle,
                  ),
                  SizedBox(
                    //Use of SizedBox
                    height: 10,
                  ),
                  Text(
                    'Gender: ${widget.particularUser["gender"]}',
                    style: textStyle,
                  ),
                  SizedBox(
                    //Use of SizedBox
                    height: 10,
                  ),
                  Text(
                    'DOB: ${widget.particularUser["DOB"]}',
                    style: textStyle,
                  ),
                  SizedBox(
                    //Use of SizedBox
                    height: 10,
                  ),
                  Text(
                    'Address: ${widget.particularUser["address"]}',
                    style: textStyle,
                  ),
                  SizedBox(
                    //Use of SizedBox
                    height: 10,
                  ),
                  Text(
                    'Affected from COVID: ${widget.particularUser["isCovidAffected"]}',
                    style: textStyle,
                  ),
                  SizedBox(
                    //Use of SizedBox
                    height: 10,
                  ),
                  Text(
                    'RTPCR-ID: ${widget.particularUser["RTPCR-ID"]}',
                    style: textStyle,
                  ),
                  SizedBox(
                    //Use of SizedBox
                    height: 10,
                  ),
                  Text(
                    'Drug Allergies: ${widget.particularUser["drugAllergies"]}',
                    style: textStyle,
                  ),
                  SizedBox(
                    //Use of SizedBox
                    height: 10,
                  ),
                  Center(
                    child: Column(children: <Widget>[
                      ElevatedButton(
                        onPressed: gotoMap,
                        child: Text("See Address on Map"),
                      ),
                      ElevatedButton(
                        onPressed: hasVaccinationStarted
                            ? null
                            : () {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime.now(),
                                    maxTime: DateTime(2023, 1, 1),
                                    onChanged: (date) {
                                  // print('change $date');
                                }, onConfirm: (date) {
                                  print('confirm $date');

                                  setState(() {
                                    String year = '$date.toLocal()'
                                        .split(' ')[0]
                                        .split('-')[0];
                                    String month = '$date.toLocal()'
                                        .split(' ')[0]
                                        .split('-')[1];
                                    String day = '$date.toLocal()'
                                        .split(' ')[0]
                                        .split('-')[2];

                                    _date = day + '-' + month + '-' + year;
                                    print(_date);
                                    checkIfVaccinationHasStarted(
                                        widget.particularUser['uid']);
                                  });
                                  startVaccination();
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en);
                              },
                        child: hasVaccinationStarted
                            ? Text("Vaccination Process Started")
                            : Text("Start Vaccination Process"),
                        style: ElevatedButton.styleFrom(
                          primary: kPrimaryColor, // background
                          onPrimary: Colors.white, // foreground
                        ),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
      appBar: AppBar(
        title: Text(
          "Worker Dashboard",
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
