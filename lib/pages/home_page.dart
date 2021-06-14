
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/helper/helper_functions.dart';
import 'package:group_chat_app/pages/authenticate_page.dart';
import 'package:group_chat_app/pages/chat_page.dart';
import 'package:group_chat_app/pages/profile_page.dart';
import 'package:group_chat_app/pages/search_page.dart';
import 'package:group_chat_app/services/auth_service.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/widgets/group_tile.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // data
  final AuthService _auth = AuthService();
  User _user;
  String _groupName;
  String _userName = '';
  String _email = '';
  Stream _groups;
  String namex='';

  // initState
  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
  }

  // widgets
  Widget noGroupWidget() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  _popupDialog(context);
                },
                child: Icon(Icons.add_circle,
                    color: Colors.grey[700], size: 75.0)),
            SizedBox(height: 20.0),
            Text(
                "You've not joined any group, tap on the 'add' icon to create a group or search for groups by tapping on the search button below."),
          ],
        ));
  }

  Widget groupsList() {
    return StreamBuilder(
      stream: _groups,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            // print(snapshot.data['groups'].length);
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex = snapshot.data['groups'].length - index - 1;
                    return Column(
                        children: [

                          Slidable(child: GroupTile(
                              userName: snapshot.data['fullName'],
                              groupId:
                              _destructureId(snapshot.data['groups'][reqIndex]),
                              groupName: _destructureName(
                                  snapshot.data['groups'][reqIndex])),
                            actionPane: SlidableScrollActionPane(),
                            actionExtentRatio: 0.25,

                            actions: <Widget>[
                              IconSlideAction(
                                caption: 'Edit',
                                color: Colors.blue,
                                icon: Icons.edit,
                                onTap: () {
//                                  print("edit");
                                  print("id........."+_destructureId(
                                      snapshot.data['groups'][reqIndex]));
                                  print("id name........."+
                                      snapshot.data['groups'][reqIndex]);
                                  _Update_Dialog(_destructureId(
                                      snapshot.data['groups'][reqIndex]),_destructureName(
                                      snapshot.data['groups'][reqIndex]),snapshot.data.id,snapshot.data['groups'][reqIndex]);
//                                  _onPressed(_destructureId(
//                                      snapshot.data['groups'][reqIndex]));

                                },
                              ),
                              IconSlideAction(
                                caption: 'Delete',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () {
                                  _showMyDialog(snapshot.data.id,snapshot.data['groups'][reqIndex],);
                                  print(snapshot.data['groups'][reqIndex]);
                                  print(snapshot.data.id);
                                },

                              ),
                              IconSlideAction(
                                caption: 'Close',
                                color: Colors.teal,
                                icon: Icons.close,

                              ),
                            ],)
                        ]);
                  });
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // functions
  _getUserAuthAndJoinedGroups() async {
    _user = await FirebaseAuth.instance.currentUser;
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _userName = value;
      });
    });
    DatabaseService(uid: _user.uid).getUserGroups().then((snapshots) {
      // print(snapshots);
      setState(() {
        _groups = snapshots;
      });
    });
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        _email = value;
      });
    });
  }

  String _destructureId(String res) {
    // print(res.substring(0, res.indexOf('_')));
    return res.substring(0, res.indexOf('_'));
  }

  String _destructureName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
  }

  void _popupDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget createButton = FlatButton(
      child: Text("Create"),
      onPressed: () async {
        if (_groupName != null) {
          await HelperFunctions.getUserNameSharedPreference().then((val) {
            DatabaseService(uid: _user.uid).createGroup(val, _groupName);
          });
          Navigator.of(context).pop();
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create a group"),
      content: TextField(
          onChanged: (val) {
            _groupName = val;
          },
          style: TextStyle(fontSize: 15.0, height: 2.0, color: Colors.black)),
      actions: [
        cancelButton,
        createButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Building the HomePage widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups',
            style: TextStyle(
                color: Colors.white,
                fontSize: 27.0,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black87,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              icon: Icon(Icons.search, color: Colors.white, size: 25.0),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchPage()));
              })
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          children: <Widget>[
            Icon(Icons.account_circle, size: 150.0, color: Colors.grey[700]),
            SizedBox(height: 15.0),
            Text(_userName,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 7.0),
            ListTile(
              onTap: () {},
              selected: true,
              contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.group),
              title: Text('Groups'),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(userName: _userName, email: _email)));
              },
              contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              onTap: () async {
                await _auth.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AuthenticatePage()),
                        (Route<dynamic> route) => false);
              },
              contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
      body: groupsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _popupDialog(context);
        },
        child: Icon(Icons.add, color: Colors.white, size: 30.0),
        backgroundColor: Colors.grey[700],
        elevation: 0.0,
      ),
    );
  }

  //delete function
  deleteData(String id, String groupval ) {
//    final collection = FirebaseFirestore.instance.collection('groups');
//    collection
//        .doc(groupval) // <-- Doc ID to be deleted.
//        .delete() // <-- Delete
//        .then((_) => print('Deleted'))
//        .catchError((error) => print('Delete failed: $error'));
    FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"groups":
    FieldValue.arrayRemove([groupval]),
    });



  }

  //confiromation for delete button
  Future<void> _showMyDialog(String id, String groupval) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Please Confirm'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Do you want to delete group?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                deleteData(id,groupval);
                Navigator.of(context).pop();

              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _Update_Dialog( String groupval,String name,String id1, String nameu) async {
    final txtGroupName=new TextEditingController();

    txtGroupName.text=name;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Group Name'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: txtGroupName,
                )
                ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Update'),
              onPressed: () {
//                deleteData(id,groupval);
                updateData(txtGroupName.text,groupval,id1,nameu);
                Navigator.of(context).pop();

              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  updateData(String name, String id,String id1, String nameu ) {
    FirebaseFirestore.instance
        .collection("groups")
        .doc(id)
        .update({"groupName":name}).then((_) {
      print("success!");
    });
    ////////////////////////
    FirebaseFirestore.instance
        .collection("users")
        .doc(id1)
        .update({"groups":
    FieldValue.arrayRemove([nameu]),
    });

    FirebaseFirestore.instance
        .collection("users")
        .doc(id1)
        .update({"groups":
    FieldValue.arrayUnion([id+"_"+name]),
    });

  }



}