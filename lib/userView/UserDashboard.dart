import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covac/userView/userVaccinationDetails.dart';
import 'package:covac/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../chatScreen.dart';
import '../faq.dart';
import '../main.dart';

const textStyle = TextStyle(
  fontSize: 16,
);

class UserDashboard extends StatefulWidget {
  final User user;
  UserDashboard(this.user);
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  var a;
  bool hasVaccinationStarted = false;
  // checkIfVaccinationHasStarted(dynamic uid) async {
  //   print("inside check");
  //   a = await FirebaseFirestore.instance
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

  @override
  void initState() {
    super.initState();
    // checkIfVaccinationHasStarted(widget.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: hasVaccinationStarted
          ? Container(
              // width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height / 6,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 6.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Text(
                      //   'User Name: ${a.data()["userName"]}',
                      //   style: textStyle,
                      // ),
                      Text(
                        "Thank you for registering. You are about to get vaccinated for COVID-19. You will soon be contacted by a worker.",
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              // width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height / 10,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 6.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Text(
                      //   'User Name: ${a.data()["userName"]}',
                      //   style: textStyle,
                      // ),
                      Text(
                        "Thank you for registering. You will be informed when your vaccination process starts.",
                        style: textStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
      appBar: AppBar(
        title: Text(
          "Dashboard",
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 90.0,
              child: DrawerHeader(
                child: Text('COVAC', style: TextStyle(color: Colors.white)),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                ),
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                print(widget.user);
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('COVID-19 Details'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Vaccination Details'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return UserVaccinationDetails(widget.user.uid);
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Chat'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ChatScreen('', widget.user.uid, 'public');
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: Text('FAQs'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return FAQPage();
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
