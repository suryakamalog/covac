import 'package:covac/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class FinishVaccinationProcess extends StatefulWidget {
  @override
  _FinishVaccinationProcessState createState() =>
      _FinishVaccinationProcessState();
}

class _FinishVaccinationProcessState extends State<FinishVaccinationProcess> {
  TextEditingController otpController = TextEditingController();

  pressed() {
    print(otpController.text);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              //Use of SizedBox
              height: 15,
            ),
            Text(
              "Enter OTP to finish Vaccination Process",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                    Icons.sms,
                    color: kPrimaryColor,
                  ),
                  // hintText: "Name",
                  labelText: 'OTP',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                controller: otpController,
                validator: (val) => val.isEmpty ? 'OTP is required' : null,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: size.width * 0.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: kPrimaryColor,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
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
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Finish Vaccination",
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
