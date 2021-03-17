import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covac/components/userDetailCard.dart';
import 'package:covac/faq.dart';
import 'package:covac/utils/constants.dart';
import 'package:covac/workerView/vaccinatedUsers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';

const textStyle = TextStyle(
  fontSize: 16,
);

class WorkerDashboard extends StatefulWidget {
  final User user;
  WorkerDashboard(this.user);
  @override
  _WorkerDashboardState createState() => _WorkerDashboardState();
}

class _WorkerDashboardState extends State<WorkerDashboard> {
  @override
  Widget build(BuildContext context) {
    print("Inside worker dashboard");
    return Scaffold(
      body: Row(children: <Widget>[
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> querySnapshot) {
              if (querySnapshot.hasError) return Text("Some Error");
              if (querySnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                final list = querySnapshot.data.docs;

                return ListView.builder(
                  itemBuilder: (context, index) {
                    // if (list[index]["role"] == "worker") {
                    //   return Container();
                    // } else
                    // return ListTile(title: Text(list[index]["name"]));
                    return GestureDetector(
                        onTap: () {
                          print("Tapped");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return UserDetailCard(list[index]);
                                ;
                              },
                            ),
                          );
                        },
                        child: list[index]["isVerified"]
                            ? Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 6.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Name: ${list[index]["firstName"]} ${list[index]["lastName"]}',
                                        style: textStyle,
                                      ),
                                      Text(
                                        'Father\'s Name: ${list[index]["fatherName"]}',
                                        style: textStyle,
                                      ),
                                      Text(
                                        'Gender: ${list[index]["gender"]}',
                                        style: textStyle,
                                      ),
                                      Text(
                                        'DOB: ${list[index]["DOB"]}',
                                        style: textStyle,
                                      ),
                                      Text(
                                        'Address: ${list[index]["addressLine1"]}, ${list[index]["addressLine2"]}, ${list[index]["city"]}, ${list[index]["state"]}',
                                        style: textStyle,
                                      ),
                                      SizedBox(
                                        //Use of SizedBox
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container());
                  },
                  itemCount: list.length,
                );
              }
            },
          ),
        ),
      ]),
      appBar: AppBar(
        title: Text(
          "Worker Dashboard",
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
              title: Text('Vaccinated Users'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return VaccinatedUsersList();
                    },
                  ),
                );
                // Update the state of the app
                // ...
                // Then close the drawer
                // Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Chat'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
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
                // Update the state of the app
                // ...
                // Then close the drawer
                // Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
