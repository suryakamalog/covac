import 'package:covac/components/rounded_input_field.dart';
import 'package:covac/components/text_field_container.dart';
import 'package:covac/dashboard.dart';
import 'package:covac/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:ui';
import 'package:covac/models/aadharForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../userView/UserDashboard.dart';

class FillDetailsCovidGov extends StatefulWidget {
  final dynamic uid;
  FillDetailsCovidGov(this.uid);
  @override
  _FillDetailsCovidGovState createState() => _FillDetailsCovidGovState();
}

class _FillDetailsCovidGovState extends State<FillDetailsCovidGov> {
  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  var selectedType;
  int selectedRadio;
  TextEditingController rtpcrController = TextEditingController();
  TextEditingController drugAllergyController = TextEditingController();
  AadharFormVal formVal = new AadharFormVal();
  pressed() {
    print('Do form validation here');
    print('RTPCR ID :${rtpcrController.text}');
    print('Drug Allergies :${drugAllergyController.text}');
    print('Affected with COVID: ');
    selectedRadio == 1 ? print("Yes") : print("No");

    try {
      FirebaseFirestore.instance.collection("users").doc(widget.uid).update({
        "isVerified": true,
        "isCovidAffected": selectedRadio == 1 ? true : false,
        "RTPCR-ID": "${rtpcrController.text}",
        "drugAllergies": "${drugAllergyController.text}",
      });
    } catch (e) {
      print(e.toString());
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return UserDashboard(FirebaseAuth.instance.currentUser);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
  }

// Changes the selected value on 'onChanged' click on each radio button
  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fill Details for verification",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        textTheme: Theme.of(context).textTheme,
      ),
      body: Container(
        child: Stack(children: <Widget>[
          Positioned(
            top: size.height * 0.35,
            left: size.width * 0.2,
            child: Container(
                child: Align(
                    alignment: Alignment.center,
                    child: Opacity(
                        opacity: 0.3,
                        child: SvgPicture.asset(
                          "assets/coronavirus.svg",
                          height: size.height * 0.3,
                          fit: BoxFit.fill,
                        )))),
          ),
          Container(
              height: size.height,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Divider(
                      color: Colors.grey,
                      height: 20,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                    ),
                    SizedBox(height: size.height * 0.02),
                    Form(
                        child: Column(
                      children: <Widget>[
                        Text(
                          "Were you affected with COVID?",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: size.height * 0.02),
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Radio(
                              value: 1,
                              groupValue: selectedRadio,
                              onChanged: (val) {
                                print("Radio $val");
                                setSelectedRadio(val);
                              },
                            ),
                            Text(
                              "Yes",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            Radio(
                              value: 2,
                              groupValue: selectedRadio,
                              onChanged: (val) {
                                print("Radio $val");
                                setSelectedRadio(val);
                              },
                            ),
                            Text(
                              "No",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          "If yes, Please provide RT-PCR Test ID",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            color: Color(0xFFF1E6FF).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(29),
                          ),
                          child: TextFormField(
                            enabled: selectedRadio == 1 ? true : false,
                            // onChanged: onChanged,
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.confirmation_number,
                                color: selectedRadio == 1
                                    ? kPrimaryColor
                                    : Colors.grey,
                              ),
                              // hintText: "Name",
                              labelText: 'RT-PCR Test ID',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.name,
                            controller: rtpcrController,

                            onSaved: (val) => formVal.name = val,
                          ),
                        ),
                        SizedBox(height: size.height * 0.05),
                        Text(
                          "Mention any drug allergy you have",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            color: Color(0xFFF1E6FF).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(29),
                          ),
                          child: TextFormField(
                            // onChanged: onChanged,
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.medical_services_rounded,
                                color: kPrimaryColor,
                              ),
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.name,
                            controller: drugAllergyController,

                            onSaved: (val) => formVal.fathersname = val,
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                          height: 20,
                          thickness: 1,
                          indent: 0,
                          endIndent: 0,
                        ),
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
                                pressed();
                              },
                              child: Text(
                                "SUBMIT",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ))
                  ],
                ),
              ))
        ]),
      ),
    );
  }
}
