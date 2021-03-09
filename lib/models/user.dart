import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String username;
  String displayName;
  String bio;
  String photoUrl;
  String email;
  String id;

  Users(
      {this.username,
      this.bio,
      this.photoUrl,
      this.email,
      this.id,
      this.displayName});

  factory Users.fromJson(DocumentSnapshot doc) => Users(
      bio: doc['bio'],
      photoUrl: doc['photoUrl'],
      email: doc['email'],
      displayName: doc['displayName'],
      username: doc['username'],
      id: doc['id']);
}
