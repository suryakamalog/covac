import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covac/higherAuthorityView/higherAuthorityDashboard.dart';
import 'package:covac/loginAndSignup/fillDetails_Aadhar.dart';
import 'package:covac/userView/UserDashboard.dart';
import 'package:covac/workerView/workerDashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  OTPScreen(this.phone);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

  bool isVerified = false;
  String role;
  getRoleAndIsVerified(User user) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc("${user.uid}")
          .get()
          .then((DocumentSnapshot ds) async {
        setState(() {
          isVerified = ds.data()['isVerified'];
        });
      });
    } catch (e) {}

    if (isVerified) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc("${user.uid}")
          .get()
          .then((DocumentSnapshot ds) async {
        setState(() {
          role = ds.data()['role'];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                'Verify +91-${widget.phone}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount: 6,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
              onSubmit: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: _verificationCode, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      await getRoleAndIsVerified(value.user);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => !isVerified
                                  ? FillDetailsAadhar(
                                      widget.phone, value.user.uid)
                                  : role == "worker"
                                      ? WorkerDashboard(value.user)
                                      : role == "higherAuthority"
                                          ? HigherAuthorityDashboard(value.user)
                                          : UserDashboard(value.user)),
                          (route) => false);
                    }
                  });
                } catch (e) {
                  print(e);
                  FocusScope.of(context).unfocus();
                  _scaffoldkey.currentState
                      .showSnackBar(SnackBar(content: Text('invalid OTP')));
                }
              },
            ),
          )
        ],
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              await getRoleAndIsVerified(value.user);

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => !isVerified
                          ? FillDetailsAadhar(widget.phone, value.user.uid)
                          : role == "worker"
                              ? WorkerDashboard(value.user)
                              : role == "higherAuthority"
                                  ? HigherAuthorityDashboard(value.user)
                                  : UserDashboard(value.user)),
                  (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}
