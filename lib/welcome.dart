import 'package:covac/loginAndSignup/otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'components/rounded_button.dart';
import 'components/rounded_input_field.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldkey,
      body: Container(
        height: size.height,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.05),
              Text(
                "WELCOME TO COVAC",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.05),
              SvgPicture.asset(
                "assets/vaccine.svg",
                height: size.height * 0.3,
              ),
              SizedBox(height: size.height * 0.05),
              RoundedInputField(
                inputType: TextInputType.number,
                hintText: "Enter Phone Number",
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value.toString();
                  });
                },
              ),
              // RoundedPasswordField(
              //   onChanged: (value) {},
              // ),
              RoundedButton(
                text: "LOGIN",
                press: () {
                  if (phoneNumber.length == 10)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return OTPScreen(phoneNumber);
                        },
                      ),
                    );
                  else
                    _scaffoldkey.currentState.showSnackBar(
                        SnackBar(content: Text('Invalid Phone Number')));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
