// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ContactList extends StatefulWidget {
//   @override
//   _ContactListState createState() => _ContactListState();
// }

// class _ContactListState extends State<ContactList> {
//   @override
//   void initState() {
//     super.initState();
//     getContactList();
//   }

//   var contact = [];
//   QueryDocumentSnapshot<Object> con;

//   Future<void> getContactList() async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       querySnapshot.docs.forEach((doc) {
//         contact = doc['fullName'];
//       });
//     });

//     // setState(() {
//     //   contact = querySnapshot.docs.map((doc) => doc.data()).toList();
//     // });
//     // print(contact);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: ListView.separated(
//           separatorBuilder: (BuildContext context, int index) => Divider(),
//           itemCount: contact.length,
//           itemBuilder: (BuildContext context, int index) {
//             return ListTile(
//               title: contact[index],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
