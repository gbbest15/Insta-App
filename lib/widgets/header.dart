import 'package:flutter/material.dart';

AppBar header(context, {bool title = false, String titleString}) {
  return AppBar(
    title: Text(
      title ? 'Insta App' : titleString,
      style: TextStyle(
        fontSize: 20.0,
        color: Colors.white,
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).primaryColor,
  );
}
