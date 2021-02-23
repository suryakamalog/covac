import 'package:covac/loginAndSignup/fillDetails_Aadhar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../dashboard.dart';
import '../components/numeric_pad.dart';
import '../utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerifyPhone extends StatefulWidget {
  final String phoneNumber;

  VerifyPhone({@required this.phoneNumber});

  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;
  String code = "";
  User currentUser;
  dynamic isVerified;
  Future<void> _submit() async {
    print("IN SUBMIT");
    try {
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: _verificationCode, smsCode: code))
          .then((value) async {
        print(value.user);
        setState(() {
          currentUser = value.user;
        });
        if (value.user != null) {
          print('user uid is --->' + '${value.user.uid}');

          try {
            await FirebaseFirestore.instance
                .collection("users")
                .doc("${value.user.uid}")
                .get()
                .then((DocumentSnapshot ds) async {
              isVerified = ds.data()['isVerified'];
            });
            print("is this user verified ? " + '$isVerified');
            if (isVerified == 0)
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FillDetailsAadhar(
                          widget.phoneNumber, value.user.uid)),
                  (route) => false);
            else if (isVerified == 1)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Dashboard();
                  },
                ),
              );
          } catch (e) {
            print("user not found");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        FillDetailsAadhar(widget.phoneNumber, value.user.uid)),
                (route) => false);
          }
        }
      });
    } catch (e) {
      print(e);
      print("failed");
      // print(currentUser.uid);
      if (currentUser != null && isVerified == 0) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FillDetailsAadhar(widget.phoneNumber, currentUser.uid)),
            (route) => false);
      } else if (currentUser != null && isVerified == 1) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
            (route) => false);
      } else
        _scaffoldkey.currentState
            .showSnackBar(SnackBar(content: Text('Invalid OTP')));
    }
  }

  Future<void> _verifyPhone() async {
    print("IN AUTO VERIFY");
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91' + '${widget.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            setState(() {
              currentUser = value.user;
            });
            if (value.user != null) {
              print('user uid is --->' + '${value.user.uid}');

              try {
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc("${value.user.uid}")
                    .get()
                    .then((DocumentSnapshot ds) async {
                  isVerified = ds.data()['isVerified'];
                });
                print("is this user verified ? " + '$isVerified');
                if (isVerified == 0)
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FillDetailsAadhar(
                              widget.phoneNumber, value.user.uid)),
                      (route) => false);
                else if (isVerified == 1)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Dashboard();
                      },
                    ),
                  );
              } catch (e) {
                print("user not found");
                _scaffoldkey.currentState
                    .showSnackBar(SnackBar(content: Text('User Not Found')));
              }
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
        timeout: Duration(seconds: 60));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Verify phone",
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
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      "Code is sent to " + widget.phoneNumber,
                      style: TextStyle(
                        fontSize: 22,
                        color: Color(0xFF818181),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildCodeNumberBox(
                            code.length > 0 ? code.substring(0, 1) : ""),
                        buildCodeNumberBox(
                            code.length > 1 ? code.substring(1, 2) : ""),
                        buildCodeNumberBox(
                            code.length > 2 ? code.substring(2, 3) : ""),
                        buildCodeNumberBox(
                            code.length > 3 ? code.substring(3, 4) : ""),
                        buildCodeNumberBox(
                            code.length > 4 ? code.substring(4, 5) : ""),
                        buildCodeNumberBox(
                            code.length > 5 ? code.substring(5, 6) : ""),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Didn't recieve code? ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF818181),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            print("Resend the code to the user");
                          },
                          child: Text(
                            "Request again",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.13,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: _submit,
                      child: Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Verify and Create Account",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          NumericPad(
            onNumberSelected: (value) {
              print(value);
              setState(() {
                if (value != -1) {
                  if (code.length < 6) {
                    code = code + value.toString();
                  }
                } else {
                  code = code.substring(0, code.length - 1);
                }
                print(code);
              });
            },
          ),
        ],
      )),
    );
  }

  Widget buildCodeNumberBox(String codeNumber) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: 45,
        height: 45,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF6F5FA),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 25.0,
                  spreadRadius: 1,
                  offset: Offset(0.0, 0.75))
            ],
          ),
          child: Center(
            child: Text(
              codeNumber,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
        ),
      ),
    );
  }
}