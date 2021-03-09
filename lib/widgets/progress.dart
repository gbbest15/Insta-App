import 'package:flutter/material.dart';

Widget circularProgress() {
  return Container(
    alignment: Alignment.center,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

Widget linearProgress() {
  return Container(
    child: LinearProgressIndicator(),
  );
}
