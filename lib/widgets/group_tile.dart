import 'package:flutter/material.dart';
import 'package:group_chat_app/pages/chat_page.dart';

class GroupTile extends StatelessWidget {
  final String userName;
  final String groupId;
  final String groupName;
  final String message;

  GroupTile({this.userName, this.groupId, this.groupName, this.message});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                    groupId: groupId,
                    userName: userName,
                    groupName: groupName,
                    meassage: message)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListTile(
          leading: CircleAvatar(
              radius: 30.0,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.group_rounded,
                color: Colors.grey[200],
                size: 35,
              )),
          title: Text(groupName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          subtitle: Text("$userName has joined to the group",
              style: TextStyle(fontSize: 13.0)),
        ),
      ),
    );
  }
}
