import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/widgets/message_tile.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String userName;
  final String groupName;

  ChatPage({this.groupId, this.userName, this.groupName});

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
    // return Container(
    //   width: 200,
    //   height: 300,
    //   color: Colors.black,
    //   child: Text('LLLLLL'),
    // );

    setState(() {
      width = 200.0;
    });
  }

  printLatestValue3() {
    print('Latest : ${messageEditingController.text}');
    // return Container(
    //   width: 200,
    //   height: 300,
    //   color: Colors.black,
    //   child: Text('LLLLLL'),
    // );

    setState(() {
      width = 0;
    });
  }

  List members = [];

  //get group members details
  Future<void> getGroupMembers() async {
    await FirebaseFirestore.instance
        .collection('groups')
        .get()
        .then((documentSnapshot) {
      documentSnapshot.docs.forEach((element) {
        setState(() {
          members = element.data()['members'];
          print(members);
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getGroupMembers();
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
      appBar: AppBar(
        title: Text(widget.groupName, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black87,
        elevation: 0.0,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 108.0),
              child: _chatMessages(),
            ),
            SizedBox(
              height: 400,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                color: Colors.grey[700],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Send a message ...",
                            hintStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(width: 12.0),
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
                            child: Icon(Icons.send, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
                width: width,
                height: width,
                color: Colors.greenAccent,
                child: ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        title: Text(members[index]),
                        onTap: () {
                          setState(() {
                            messageEditingController.text =
                                '@' + members[index] + ' ';
                          });
                        });
                  },
                ))
          ],
        ),
      ),
    );
  }
}
