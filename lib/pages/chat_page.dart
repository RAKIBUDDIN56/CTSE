import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/widgets/group_tile.dart';
import 'package:group_chat_app/widgets/message_tile.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String userName;
  final String groupName;
  final String meassage;

  ChatPage({this.groupId, this.userName, this.groupName, this.meassage});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot> _chats;
  TextEditingController messageEditingController = new TextEditingController();

  Widget _chatMessages() {
    return StreamBuilder(
      stream: _chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.docs[index].data()["message"],
                    sender: snapshot.data.docs[index].data()["sender"],
                    sentByMe: widget.userName ==
                        snapshot.data.docs[index].data()["sender"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void dispose() {
    messageEditingController.dispose();
    super.dispose();
  }

  _sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageEditingController.text,
        "sender": widget.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  double width = 0;

  String printLatestValue() {
    print('Latest text : ${messageEditingController.text}');
    return messageEditingController.text;
  }

  printLatestValue2() {
    print('Latest : ${messageEditingController.text}');

    setState(() {
      width = 200.0;
    });
  }

  printLatestValue3() {
    print('Latest : ${messageEditingController.text}');

    setState(() {
      width = 0;
    });
  }

  List members = [];

  //get group members details
  Future<void> getGroupMembers() async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.data != null) {
        setState(() {
          members = documentSnapshot.get('members');
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getGroupMembers();
    _chatMessages();
    DatabaseService().getChats(widget.groupId).then((val) {
      // print(val);
      setState(() {
        _chats = val;
      });
    });
    messageEditingController.addListener(() {
      printLatestValue() == '@' ? printLatestValue2() : printLatestValue3();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backwardsCompatibility: true,
      //   leading: Icon(Icons.group_rounded),
      //   automaticallyImplyLeading: true,
      //   title: Text(widget.groupName.toUpperCase(),
      //       style: TextStyle(color: Colors.white)),
      //   centerTitle: false,
      //   backgroundColor: Colors.cyan[900],
      //   elevation: 0.0,
      // ),

      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              height: 130,
              width: 800,
              color: Colors.cyan[900],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      alignment: Alignment.bottomLeft,
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context, true);
                      }),
                  Padding(
                    padding: const EdgeInsets.only(right: 3.0),
                    child: Icon(
                      Icons.group_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 30.0, right: 200, bottom: 5),
                        child: Text(
                          widget.groupName,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 300,
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: members.length - 1,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(
                                members[index] + ', ' + 'You',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              );
                            },
                          )),
                    ],
                  )
                ],
              ),
            ),

            ///chat list
            Padding(
              padding: const EdgeInsets.only(bottom: 108.0, top: 140),
              child: _chatMessages(),
            ),
            SizedBox(
              height: 400,
            ),

            ///Tag the user
            Positioned(
              top: 250,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.teal[200]),
                  width: width,
                  height: width,
                  child: ListView.builder(
                    itemCount: members.length - 1,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          hoverColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 9.0, vertical: 0.0),
                          leading: Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 40,
                          ),
                          title: Text(
                            members[index],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            setState(() {
                              messageEditingController.text =
                                  '@' + members[index] + ' ';
                            });
                          });
                    },
                  )),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.indigo[300],
                ),
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.black,
                        controller: messageEditingController,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            hintText: "Send a message ...",
                            hintStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    GestureDetector(
                      onTap: () {
                        _sendMessage();
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                            child: Icon(
                                messageEditingController.text == ''
                                    ? Icons.camera_alt
                                    : Icons.send,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
