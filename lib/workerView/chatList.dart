import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covac/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../chatScreen.dart';
import '../main.dart';

const textStyle = TextStyle(
  fontSize: 16,
);

class ChatList extends StatefulWidget {
  final dynamic uid;
  ChatList(this.uid);
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
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
                return Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Center(child: CircularProgressIndicator()));
              } else {
                final list = querySnapshot.data.docs;

                return ListView.builder(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        print("Tapped");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ChatScreen(
                                  widget.uid, list[index]["uid"], 'worker');
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
                              // Text(
                              //   'Worker Name: ${list[index]["workerName"]}',
                              //   style: textStyle,
                              // ),
                              // Text(
                              //   'Date: ${list[index]["date"]}',
                              //   style: textStyle,
                              // ),
                              // Text(
                              //   'Address: ${list[index]["address"]}',
                              //   style: textStyle,
                              // ),
                              // Text(
                              //   'isVaccinated: ${list[index]["isVaccinated"]}',
                              //   style: textStyle,
                              // ),
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
