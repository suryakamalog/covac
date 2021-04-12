import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covac/workerView/userDetailCard.dart';
import 'package:flutter/material.dart';

class SearchResultWidget extends StatefulWidget {
  final query;
  SearchResultWidget(this.query);
  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget> {
  @override
  Widget build(BuildContext context) {
    print("called search widget");
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where('aadharNumber', isEqualTo: widget.query)
            // .orderBy('lastName')
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                        : Container(
                            // child: Text("Inside search widget"),
                            ));
              },
              itemCount: list.length,
            );
          }
        },
      ),
    );
  }
}
