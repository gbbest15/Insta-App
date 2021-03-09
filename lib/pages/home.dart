import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instaapp/models/user.dart';
import 'package:instaapp/pages/activity_feed.dart';
import 'package:instaapp/pages/create_account.dart';
import 'package:instaapp/pages/profile.dart';
import 'package:instaapp/pages/search.dart';
import 'package:instaapp/pages/timeline.dart';
import 'package:instaapp/pages/upload.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

GoogleSignIn googleSignIn = GoogleSignIn();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  GlobalKey _bottomNavigationKey = GlobalKey();
  PageController _pageController = PageController();
  Users current;
  bool isAuth = false;
  int pageIndex = 0;
  login() {
    googleSignIn.signIn();
  }

  @override
  void initState() {
    super.initState();

    _auth.authStateChanges().listen((user) {
      if (user != null) {
        print("user is logged in");
        setState(() {
          isAuth = true;
        });
        //navigate to home page using Navigator Widget
      }
    });
    googleSignIn.onCurrentUserChanged.listen((event) {
      if (event != null) {
        storeusersInfo();
        setState(() {
          isAuth = true;
        });
      } else {
        setState(() {
          isAuth = false;
        });
      }
    });

    // googleSignIn.signInSilently(suppressErrors: false).then((value) {
    //   if (value != null) {
    //     storeusersInfo();
    //     setState(() {
    //       isAuth = true;
    //     });
    //   } else {
    //     setState(() {
    //       isAuth = false;
    //     });
    //   }
    // }).onError((error, stackTrace) {
    //   print('this is the error $error');
    // });
  }

  storeusersInfo() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final User user = (await _auth.signInWithCredential(credential)).user;

    DocumentSnapshot doc =
        await _firestore.collection('Users').doc(user.uid).get();
    if (doc == null) {
      final username = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAccount(),
        ),
      );
      _firestore.collection('User').doc(user.uid).set({
        'id': user.uid,
        'username': username,
        'photoUrl': user.photoURL,
        'email': user.email,
        'displayName': user.displayName,
        'bio': '',
        'timeStamp': DateTime.now(),
      });
      doc = await _firestore.collection('Users').doc(user.uid).get();
    }
    current = Users.fromJson(doc);
  }

  // end of the firestore

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.horizontal,
        children: [
          Timeline(),
          ActivityFeedItem(),
          Search(),
          Upload(),
          Profile(
            currentUser: _auth.currentUser.uid,
          ),
        ],
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        physics: BouncingScrollPhysics(),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: pageIndex,
        height: 50.0,
        color: Theme.of(context).primaryColor,
        items: [
          Icon(Icons.whatshot, color: Colors.white),
          Icon(Icons.notifications_active, color: Colors.white),
          Icon(Icons.search, color: Colors.white),
          Icon(Icons.photo_camera, color: Colors.white),
          Icon(Icons.account_circle, color: Colors.white),
        ],
        animationDuration: Duration(milliseconds: 200),
        buttonBackgroundColor: Theme.of(context).accentColor,
        backgroundColor: Colors.white,
        onTap: (int pageIndex1) {
          _pageController.animateToPage(pageIndex1,
              duration: Duration(microseconds: 300), curve: Curves.bounceInOut);
        },
      ),
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Insta App',
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 90.0,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 260.0,
                height: 60.0,
                child: Text('Login with Gogole'),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
