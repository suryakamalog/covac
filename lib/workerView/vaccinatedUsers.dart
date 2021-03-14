import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covac/components/userDetailCard.dart';
import 'package:covac/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'finishVaccinationProcess.dart';

const textStyle = TextStyle(
  fontSize: 16,
);

class VaccinatedUsersList extends StatefulWidget {
  @override
  _VaccinatedUsersListState createState() => _VaccinatedUsersListState();
}

class _VaccinatedUsersListState extends State<VaccinatedUsersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: <Widget>[
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("vaccinatedUsers")
                .snapshots(),
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
                      onTap: list[index]["isVaccinated"]
                          ? null
                          : () {
                              print("Tapped");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return FinishVaccinationProcess();
                                    ;
                                  },
                                ),
                              );
                            },
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
                              Text(
                                'User Name: ${list[index]["userName"]}',
                                style: textStyle,
                              ),
                              Text(
                                'Worker Name: ${list[index]["workerName"]}',
                                style: textStyle,
                              ),
                              Text(
                                'Date: ${list[index]["date"]}',
                                style: textStyle,
                              ),
                              Text(
                                'Address: ${list[index]["address"]}',
                                style: textStyle,
                              ),
                              Text(
                                'isVaccinated: ${list[index]["isVaccinated"]}',
                                style: textStyle,
                              ),
                              SizedBox(
                                //Use of SizedBox
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
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
          "Vaccinated Users",
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