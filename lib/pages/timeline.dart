import 'package:flutter/material.dart';

import 'package:instaapp/pages/home.dart';
import 'package:instaapp/widgets/header.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, title: true),
      body: Container(
        child: TextButton(
          onPressed: () {
            googleSignIn.signOut();
          },
          child: Text('Logo out'),
        ),
      ),
    );
  }
}
