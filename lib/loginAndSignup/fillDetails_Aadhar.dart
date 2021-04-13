import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covac/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:ui';
import 'package:covac/models/aadharForm.dart';

import 'fillDetails_Covid_Gov.dart';

class FillDetailsAadhar extends StatefulWidget {
  final String phoneNumber;
  final dynamic uid;
  FillDetailsAadhar(this.phoneNumber, this.uid);
  @override
  _FillDetailsAadharState createState() => _FillDetailsAadharState();
}

class _FillDetailsAadharState extends State<FillDetailsAadhar> {
  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  var selectedType;
  String _date = "01-01-2000";
  DateTime dobTimestamp;
  List<String> _genderItems = <String>[
    'Male',
    'Female',
    'Others',
  ];
  TextEditingController aadharController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController fathersnameController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  AadharFormVal formVal = new AadharFormVal();
  pressed() {
    print('Do form validation here');
    print('Aadhar Number :${aadharController.text}');
    print('First Name :${firstNameController.text}');
    print('Last Name :${lastNameController.text}');
    print('Father\'s name :${fathersnameController.text}');
    print('Gender :${formVal.gender}');
    print('DOB :$_date');
    print('Address Line 1 :${addressLine1Controller.text}');
    print('Address Line 2 :${addressLine2Controller.text}');
    print('City :${cityController.text}');
    print('State :${stateController.text}');

    FirebaseFirestore.instance.collection("users").doc(widget.uid).update({
      "aadharNumber": "${aadharController.text}",
      "firstName": "${firstNameController.text}",
      "lastName": "${lastNameController.text}",
      "fatherName": "${fathersnameController.text}",
      "gender": "${formVal.gender}",
      "DOB": "$_date",
      "DOBTimestamp": "$dobTimestamp",
      "uid": "${widget.uid}",
      "role": "public",
      "addressLine1": "${addressLine1Controller.text}",
      "addressLine2": "${addressLine2Controller.text}",
      "city": "${cityController.text}",
      "state": "${stateController.text}",
      "mobile": "${widget.phoneNumber}",
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return FillDetailsCovidGov(aadharController.text, widget.uid);
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("in init!!!!");
    FirebaseFirestore.instance.collection("users").doc(widget.uid).set({
      "isVerified": false,
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
                    Stack(
                      children: [
                        Center(
                          child: ClipOval(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                              child: CircleAvatar(
                                radius: size.width * 0.14,
                                backgroundColor: Colors.grey[400].withOpacity(
                                  0.4,
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: size.width * 0.1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: size.height * 0.08,
                          left: size.width * 0.56,
                          child: Container(
                            height: size.width * 0.1,
                            width: size.width * 0.1,
                            decoration: BoxDecoration(
                              color: Color(0xff5663ff),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              Icons.arrow_upward,
                              color: Color(0xff5663ff),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.05),
                    Form(
                        child: Column(
                      children: <Widget>[
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
                                Icons.perm_identity,
                                color: kPrimaryColor,
                              ),
                              // hintText: "Name",
                              labelText: 'Aadhar Number',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.number,
                            controller: aadharController,
                            validator: (val) => val.isEmpty
                                ? 'Aadhar Number is required'
                                : null,
                            onSaved: (val) => formVal.aadharNumber = val,
                          ),
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
                                Icons.person,
                                color: kPrimaryColor,
                              ),
                              // hintText: "Name",
                              labelText: 'First Name',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.name,
                            controller: firstNameController,
                            validator: (val) =>
                                val.isEmpty ? 'First name is required' : null,
                            onSaved: (val) => formVal.firstName = val,
                          ),
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
                                Icons.person,
                                color: kPrimaryColor,
                              ),
                              // hintText: "Name",
                              labelText: 'Last Name',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.name,
                            controller: lastNameController,
                            validator: (val) =>
                                val.isEmpty ? 'Last name is required' : null,
                            onSaved: (val) => formVal.lastName = val,
                          ),
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
                                Icons.person,
                                color: kPrimaryColor,
                              ),
                              labelText: 'Father\'s name',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.name,
                            controller: fathersnameController,
                            validator: (val) => val.isEmpty
                                ? 'Father\'s name is required'
                                : null,
                            onSaved: (val) => formVal.fathersname = val,
                          ),
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
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton(
                                isExpanded: false,
                                items: _genderItems
                                    .map((value) => DropdownMenuItem(
                                          child: Text(
                                            value,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          value: value,
                                        ))
                                    .toList(),
                                onChanged: (selectedGender) {
                                  setState(() {
                                    selectedType = selectedGender;
                                    formVal.gender = selectedType;
                                  });
                                },
                                value: selectedType,
                                hint: Text(
                                  'Gender',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.5)),
                                ),
                              ),
                            ),
                          ),
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
                          child: Row(children: <Widget>[
                            Icon(
                              Icons.date_range,
                              color: kPrimaryColor,
                            ),
                            TextButton(
                              // splashColor: Colors.white10,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'DOB: $_date',
                                ),
                              ),
                              style: TextButton.styleFrom(
                                primary: Colors.black.withOpacity(0.5),
                              ),
                              onPressed: () {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime(1980, 1, 1),
                                    maxTime: DateTime.now(), onChanged: (date) {
                                  // print('change $date');
                                }, onConfirm: (date) {
                                  print('confirm $date');

                                  setState(() {
                                    dobTimestamp = date;
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
                                    formVal.dob = _date;
                                    print(_date);
                                  });
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en);
                              },
                            ),
                          ]),
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
                              maxLines: 2,
                              // onChanged: onChanged,
                              cursorColor: kPrimaryColor,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.place,
                                  color: kPrimaryColor,
                                ),
                                hintText: "Address Line 1",
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.streetAddress,
                              controller: addressLine1Controller,
                              validator: (val) =>
                                  val.isEmpty ? 'Address is required' : null,
                              onSaved: (val) {
                                setState(() {
                                  formVal.addressLine1 = val;
                                });
                              },
                              onChanged: (val) {
                                setState(() {
                                  formVal.addressLine1 = val;
                                });
                              }),
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
                              maxLines: 2,
                              // onChanged: onChanged,
                              cursorColor: kPrimaryColor,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.place,
                                  color: kPrimaryColor,
                                ),
                                hintText: "Address Line 2",
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.streetAddress,
                              controller: addressLine2Controller,
                              validator: (val) =>
                                  val.isEmpty ? 'Address is required' : null,
                              onSaved: (val) {
                                setState(() {
                                  formVal.addressLine2 = val;
                                });
                              },
                              onChanged: (val) {
                                setState(() {
                                  formVal.addressLine2 = val;
                                });
                              }),
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
                              maxLines: 1,
                              // onChanged: onChanged,
                              cursorColor: kPrimaryColor,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.location_city,
                                  color: kPrimaryColor,
                                ),
                                hintText: "City",
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.streetAddress,
                              controller: cityController,
                              validator: (val) =>
                                  val.isEmpty ? 'City is required' : null,
                              onSaved: (val) {
                                setState(() {
                                  formVal.city = val;
                                });
                              },
                              onChanged: (val) {
                                setState(() {
                                  formVal.city = val;
                                });
                              }),
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
                              maxLines: 1,
                              // onChanged: onChanged,
                              cursorColor: kPrimaryColor,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.place,
                                  color: kPrimaryColor,
                                ),
                                hintText: "State",
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.streetAddress,
                              controller: stateController,
                              validator: (val) =>
                                  val.isEmpty ? 'State is required' : null,
                              onSaved: (val) {
                                setState(() {
                                  formVal.state = val;
                                });
                              },
                              onChanged: (val) {
                                setState(() {
                                  formVal.state = val;
                                });
                              }),
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
