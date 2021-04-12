import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covac/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'main.dart';

class ChatScreen extends StatefulWidget {
  final dynamic workerUID;
  final dynamic uid;
  final String role;
  ChatScreen(this.workerUID, this.uid, this.role);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream messageStream;
  String workerName, userName, messageId = "", chatRoomID;
  TextEditingController messageController = TextEditingController();

  getWorkerInfo2(dynamic workerUID, dynamic uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(workerUID)
        .get()
        .then((DocumentSnapshot ds) async {
      setState(() {
        workerName = ds.data()['firstName'];
      });
    }).catchError((onError) {});

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot ds) async {
      setState(() {
        userName = ds.data()['firstName'] + " " + ds.data()['lastName'];
      });
    }).catchError((onError) {});
  }

  getWorkerInfo1(dynamic uid) async {
    await FirebaseFirestore.instance
        .collection("firstDosage")
        .doc("$uid")
        .get()
        .then((DocumentSnapshot ds) async {
      setState(() {
        workerName = ds.data()['workerName'];
        userName = ds.data()['userName'];
      });
    }).catchError((onError) {});
  }

  Future addMessageToDB(chatRoomID, messageId, messageInfoMap) {
    print("adding message to db");
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomID)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap)
        .catchError((onError) {});
  }

  Future updateLastMessageSend(String chatRoomId, Map lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomID) async {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomID)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  addMessage(bool sendClicked) {
    print("inside addMessage()");
    if (messageController.text != "") {
      print("inside this");
      // chatRoomID = userName + "_" + workerName;
      String message = messageController.text;
      var lastMessageTime = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": userName,
        "ts": lastMessageTime
      };

      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      addMessageToDB(chatRoomID, messageId, messageInfoMap).then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTime,
          "lastMessageSendBy": userName
        };
        updateLastMessageSend(chatRoomID, lastMessageInfoMap);

        if (sendClicked) {
          messageController.text = "";

          messageId = "";
        }
      });
    }
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomRight:
                      sendByMe ? Radius.circular(0) : Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft:
                      sendByMe ? Radius.circular(24) : Radius.circular(0),
                ),
                color: sendByMe ? Colors.blue : Colors.grey,
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 70, top: 16),
                reverse: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  print(ds.data());
                  return chatMessageTile(
                      ds.data()['message'], userName == ds.data()['sendBy']);
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  getAndSetMessages() async {
    messageStream = await getChatRoomMessages(chatRoomID);
    setState(() {});
  }

  doAtStart() async {
    if (widget.role == 'public') {
      await getWorkerInfo1(widget.uid);
      chatRoomID = userName + "_" + workerName;
    } else {
      await getWorkerInfo2(widget.workerUID, widget.uid);
      chatRoomID = userName + "_" + workerName;
      userName = workerName;
    }

    getAndSetMessages();
  }

  @override
  void initState() {
    super.initState();
    doAtStart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat Screen",
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
      body: Container(
        child: Stack(
          children: <Widget>[
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.deepPurple.withOpacity(0.9),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                            controller: messageController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "type a message",
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.6))))),
                    GestureDetector(
                      onTap: () {
                        print("sending message");
                        addMessage(true);
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
