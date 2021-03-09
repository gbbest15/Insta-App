import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:instaapp/widgets/header.dart';

class Profile extends StatefulWidget {
  final String currentUser;
  Profile({this.currentUser});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _firestore = FirebaseFirestore.instance;
  Widget gettingUserprofile() {
    return StreamBuilder<DocumentSnapshot>(
        stream:
            _firestore.collection('User').doc(widget.currentUser).snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          Map<String, dynamic> user = snapshot.data.data();
          return Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: CircleAvatar(
                        child: Image.network('${user['photoUrl']}'),
                        radius: 50.0,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              topColum(buttom: 'Post', number: 1),
                              topColum(buttom: 'Fellowers', number: 2),
                              topColum(buttom: 'Following', number: 0),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text('fellow'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget topColum({int number, String buttom}) {
    return Column(
      children: [
        Text(
          '$number',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          buttom,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleString: "Profile"),
      body: gettingUserprofile(),
    );
  }
}
