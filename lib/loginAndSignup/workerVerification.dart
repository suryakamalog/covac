import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covac/loginAndSignup/userVerification.dart';
import 'package:covac/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WorkerVerification extends StatefulWidget {
  final dynamic uid;
  final String uidai;
  WorkerVerification(this.uidai, this.uid);
  @override
  _WorkerVerificationState createState() => _WorkerVerificationState();
}

class _WorkerVerificationState extends State<WorkerVerification> {
  TextEditingController workerIDController = TextEditingController();
  var selectedType;
  int selectedRadio;

  pressed() {
    try {
      FirebaseFirestore.instance.collection("users").doc(widget.uid).update({
        "workerID": "${workerIDController.text}",
        "role": "worker",
      });
    } catch (e) {
      print(e.toString());
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return UserVerification(widget.uidai, widget.uid);
          // return UserDashboard(FirebaseAuth.instance.currentUser);
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
          "Worker Verification",
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
                          "Are you a ASHA/ANM worker?",
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
                          "If yes, Please provide Worker ID Number",
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
                              labelText: 'Worker ID',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.name,
                            controller: workerIDController,
                          ),
                        ),
                        SizedBox(height: size.height * 0.05),
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
