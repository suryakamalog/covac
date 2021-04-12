import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:covac/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sms_maintained/sms.dart';
import '../main.dart';
import 'dart:io';

class FinishVaccinationProcess extends StatefulWidget {
  final String uid;
  final String phase;
  FinishVaccinationProcess(this.uid, this.phase);
  @override
  _FinishVaccinationProcessState createState() =>
      _FinishVaccinationProcessState();
}

class _FinishVaccinationProcessState extends State<FinishVaccinationProcess> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  TextEditingController otpController = TextEditingController();
  String otp;
  File _image;
  dynamic imageLink;
  bool isVaccinated = false;

  sendNotification() {
    SmsSender sender = SmsSender();
    // String address = "+91-" + widget.particularUser["mobile"].toString();
    String address = "+91-8294310526";
    String text = "${widget.phase} Dosage of COVID Vaccine given";

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

  saveToDB() {
    if (widget.phase == "first")
      FirebaseFirestore.instance
          .collection("firstDosage")
          .doc(widget.uid)
          .update({
        "isFirstDosageGiven": true,
      });
    else
      FirebaseFirestore.instance
          .collection("secondDosage")
          .doc(widget.uid)
          .update({
        "isSecondDosageGiven": true,
      });
  }

  startUpload() async {
    FirebaseStorage fs = FirebaseStorage.instance;

    Reference rootReference = fs.ref();
    Reference pictureFolderRef;
    if (widget.phase == "first")
      pictureFolderRef = rootReference.child("${widget.uid}first");
    else
      pictureFolderRef = rootReference.child("${widget.uid}second");

    pictureFolderRef.putFile(_image).then((storageTask) async {
      String link = await storageTask.ref.getDownloadURL();
      print("uploaded");

      if (widget.phase == "first") {
        FirebaseFirestore.instance
            .collection("firstDosage")
            .doc(widget.uid)
            .update({"verificationImage": link});
      } else
        FirebaseFirestore.instance
            .collection("secondDosage")
            .doc(widget.uid)
            .update({"verificationImage": link});
      setState(() {
        imageLink = link;
      });
    });
  }

  pressed() {
    print(otp);
    print(otpController.text);
    if (otp == otpController.text) {
      startUpload();
      if (widget.phase == "first") {
        FirebaseFirestore.instance
            .collection("vaccinatedUsers")
            .doc(widget.uid)
            .update({"isFirstDosageGiven": true});

        setState(() {
          isVaccinated = true;
        });
      } else {
        FirebaseFirestore.instance
            .collection("vaccinatedUsers")
            .doc(widget.uid)
            .update({"isSecondDosageGiven": true});

        setState(() {
          isVaccinated = true;
        });
      }

      saveToDB();
      // Send sms to vaccinated user

      sendNotification();
    } else {
      _scaffoldkey.currentState
          .showSnackBar(SnackBar(content: Text('Invalid OTP')));
    }
  }

  // checkIfVaccinated() async {
  //   var a = await FirebaseFirestore.instance
  //       .collection("vaccinatedUsers")
  //       .doc(widget.uid)
  //       .get();
  //   isVaccinated = a.data()['isVaccinated'];
  // }

  getOTPfromDB() async {
    if (widget.phase == "first") {
      var a = await FirebaseFirestore.instance
          .collection("firstDosage")
          .doc(widget.uid)
          .get();
      otp = a.data()['OTP'];
    } else {
      var a = await FirebaseFirestore.instance
          .collection("secondDosage")
          .doc(widget.uid)
          .get();
      otp = a.data()['OTP'];
    }
  }

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // checkIfVaccinated();
    getOTPfromDB();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldkey,
      body: isVaccinated
          ? Center(
              child: Text("User has been vaccinated."),
            )
          : Center(
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
                      validator: (val) =>
                          val.isEmpty ? 'OTP is required' : null,
                    ),
                  ),
                  Center(
                      child: _image == null
                          ? Text('No image selected.')
                          : Container(
                              width: 250.0,
                              height: 250.0,
                              child: Image.file(_image),
                              alignment: Alignment.center,
                            )),
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
                          getImage();
                        },
                        child: Text(
                          "Upload photo for verification",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
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
