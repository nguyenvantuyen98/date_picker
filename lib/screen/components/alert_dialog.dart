import 'dart:io';

import 'package:flutter/material.dart';
showAlert({BuildContext context}) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
    onPressed: () {
      exit(0);
    },
  );
  Widget noButton = FlatButton(
    child: Text("NO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
    ),
    title: Text("Are you sure ?",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    actions: [
      okButton,
      noButton
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}