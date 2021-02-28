import 'package:covac/loginAndSignup/continue_with_phone.dart';
import 'package:covac/loginAndSignup/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'components/rounded_button.dart';
import 'components/rounded_input_field.dart';
import 'components/rounded_password_field.dart';
import 'loginAndSignup/verifty_phone.dart';
import 'utils/constants.dart';
import 'dashboard.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
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
                  phoneNumber = value;
                  print(phoneNumber);
                });
              },
            ),
            // RoundedPasswordField(
            //   onChanged: (value) {},
            // ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return VerifyPhone(phoneNumber: phoneNumber);
                    },
                  ),
                );
              },
            ),
            // SizedBox(height: size.height * 0.03),
            RoundedButton(
              text: "SIGN UP",
              color: kPrimaryLightColor,
              textColor: Colors.black,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ContinueWithPhone();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
