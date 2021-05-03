import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covac/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../main.dart';
import 'package:sms_maintained/sms.dart';

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
  int bothDosageCount, firstDosageCount;
  String _date = "Choose Date";
  String firstJabDate = "Choose Date";
  String secondJabDate = "Choose Date";
  int sixDigitOTP = 0;
  // bool hasVaccinationStarted = false;
  bool isFirstDosageGiven = false;
  bool isSecondDosageGiven = false;
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
      currentWorkerName = ds.data()['firstName'];
    });
  }

  // checkIfVaccinationHasStarted(dynamic uid) async {
  //   print("inside check");
  //   var a = await FirebaseFirestore.instance
  //       .collection("vaccinatedUsers")
  //       .doc("$uid")
  //       .get();
  //   if (a.exists) {
  //     print("inside check ------true");
  //     setState(() {
  //       hasVaccinationStarted = true;
  //     });
  //   }
  //   if (!a.exists) {
  //     print("inside check ------false");
  //     setState(() {
  //       hasVaccinationStarted = false;
  //     });
  //   }
  // }

  getDosageDate(dynamic uid) async {
    await FirebaseFirestore.instance
        .collection("firstDosage")
        .doc("$uid")
        .get()
        .then((DocumentSnapshot ds) async {
      setState(() {
        firstJabDate = ds.data()['date'];
      });
    }).catchError((onError) {});

    await FirebaseFirestore.instance
        .collection("secondDosage")
        .doc("$uid")
        .get()
        .then((DocumentSnapshot ds) async {
      setState(() {
        secondJabDate = ds.data()['date'];
      });
    }).catchError((onError) {});
  }

  checkIfFirstDosageGiven(dynamic uid) async {
    await FirebaseFirestore.instance
        .collection("vaccinatedUsers")
        .doc("$uid")
        .get()
        .then((DocumentSnapshot ds) async {
      setState(() {
        isFirstDosageGiven = ds.data()['isFirstDosageGiven'];
        isSecondDosageGiven = ds.data()['isSecondDosageGiven'];
      });
    }).catchError((onError) {});
  }

  sendOTP() {
    var rnd = new Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    sixDigitOTP = next.toInt();
    print(sixDigitOTP);

    SmsSender sender = SmsSender();
    String address = "+91-" + widget.particularUser["mobile"].toString();
    // String address = "+91-8294310526";
    String text = "OTP for vaccination verification is $sixDigitOTP.";

    SmsMessage message = SmsMessage(address, text);
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }
    });
    sender.sendSms(message);
  }

  @override
  void initState() {
    super.initState();
    getName(FirebaseAuth.instance.currentUser.uid);
    // checkIfVaccinationHasStarted(widget.particularUser['uid']);
    checkIfFirstDosageGiven(widget.particularUser['uid']);

    getDosageDate(widget.particularUser['uid']);
  }

  gotoMap() {}
  startFirstVaccination() async {
    //input date
    print(firstJabDate);
    //send OTP to user phoneNumber
    sendOTP();
    FirebaseFirestore.instance
        .collection("vaccinatedUsers")
        .doc(widget.particularUser['uid'])
        .set({
      "mobile": widget.particularUser["mobile"],
      "uid": widget.particularUser["uid"],
      "userName":
          "${widget.particularUser["firstName"]} ${widget.particularUser["lastName"]}",
      "isFirstDosageGiven": false,
      "isSecondDosageGiven": false,
    });

    FirebaseFirestore.instance
        .collection("firstDosage")
        .doc(widget.particularUser['uid'])
        .set({
      "mobile": widget.particularUser["mobile"],
      "uid": widget.particularUser["uid"],
      "userName":
          "${widget.particularUser["firstName"]} ${widget.particularUser["lastName"]}",
      "workerName": "$currentWorkerName",
      "date": "$firstJabDate",
      "address":
          "${widget.particularUser["addressLine1"]}, ${widget.particularUser["addressLine2"]}, ${widget.particularUser["city"]}, ${widget.particularUser["state"]}",
      "OTP": "$sixDigitOTP",
      "isFirstDosageGiven": false,
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
        .doc("firstDosageCount")
        .update({
      "count": firstDosageCount + 1,
    });
  }

  startSecondVaccination() async {
    sendOTP();
    FirebaseFirestore.instance
        .collection("secondDosage")
        .doc(widget.particularUser['uid'])
        .set({
      "mobile": widget.particularUser["mobile"],
      "uid": widget.particularUser["uid"],
      "userName":
          "${widget.particularUser["firstName"]} ${widget.particularUser["lastName"]}",
      "workerName": "$currentWorkerName",
      "date": "$secondJabDate",
      "address":
          "${widget.particularUser["addressLine1"]}, ${widget.particularUser["addressLine2"]}, ${widget.particularUser["city"]}, ${widget.particularUser["state"]}",
      "OTP": "$sixDigitOTP",
      "isSecondDosageGiven": false,
    });

    await FirebaseFirestore.instance
        .collection("statistics")
        .doc("bothDosageCount")
        .get()
        .then((DocumentSnapshot ds) async {
      bothDosageCount = ds.data()['count'];
    });
    await FirebaseFirestore.instance
        .collection("statistics")
        .doc("bothDosageCount")
        .update({
      "count": bothDosageCount + 1,
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
                    'Name: ${widget.particularUser["firstName"]} ${widget.particularUser["lastName"]}',
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
                    'Address: ${widget.particularUser["addressLine1"]}, ${widget.particularUser["addressLine2"]}, ${widget.particularUser["city"]}, ${widget.particularUser["state"]}',
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
                      // ElevatedButton(
                      //   onPressed: isFirstDosageGiven
                      //       ? null
                      //       : () {
                      //           setState(() {
                      //             isFirstDosageGiven = true;
                      //           });
                      //         },
                      //   child: isFirstDosageGiven
                      //       ? Text("Vaccination Process Started")
                      //       : Text("Start Vaccination Process"),
                      //   style: ElevatedButton.styleFrom(
                      //     primary: kPrimaryColor, // background
                      //     onPrimary: Colors.white, // foreground
                      //   ),
                      // ),
                      SizedBox(
                        //Use of SizedBox
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "First Jab:",
                            style: textStyle,
                          ),
                          SizedBox(
                            //Use of SizedBox
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: isFirstDosageGiven
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

                                        firstJabDate =
                                            day + '-' + month + '-' + year;
                                        print(firstJabDate);
                                        // checkIfVaccinationHasStarted(
                                        //     widget.particularUser['uid']);
                                      });
                                      startFirstVaccination();
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.en);
                                  },
                            child: isFirstDosageGiven
                                ? Text("Date Selected")
                                : Text("Select Date"),
                            style: ElevatedButton.styleFrom(
                              primary: kPrimaryColor, // background
                              onPrimary: Colors.white, // foreground
                            ),
                          ),
                          SizedBox(
                            //Use of SizedBox
                            width: 10,
                          ),
                          Text(
                            "$firstJabDate",
                            style: textStyle,
                          ),
                        ],
                      ),
                      SizedBox(
                        //Use of SizedBox
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Second Jab:",
                            style: textStyle,
                          ),
                          SizedBox(
                            //Use of SizedBox
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed:
                                !isFirstDosageGiven || isSecondDosageGiven
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

                                            secondJabDate =
                                                day + '-' + month + '-' + year;
                                            print(secondJabDate);
                                            // checkIfVaccinationHasStarted(
                                            //     widget.particularUser['uid']);
                                          });
                                          startSecondVaccination();
                                        },
                                            currentTime: DateTime.now(),
                                            locale: LocaleType.en);
                                      },
                            child: !isFirstDosageGiven || isSecondDosageGiven
                                ? Text("Date Selected")
                                : Text("Select Date"),
                            style: ElevatedButton.styleFrom(
                              primary: kPrimaryColor, // background
                              onPrimary: Colors.white, // foreground
                            ),
                          ),
                          SizedBox(
                            //Use of SizedBox
                            width: 10,
                          ),
                          Text(
                            "$secondJabDate",
                            style: textStyle,
                          ),
                        ],
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
