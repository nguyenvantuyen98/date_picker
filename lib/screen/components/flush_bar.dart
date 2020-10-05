import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

var flushbar = Flushbar(
  messageText: Center(
      child: Column(
    children: [
      Text(
        "Until date must",
        style: TextStyle(color: Colors.green),
      ),
      Text("be after start date", style: TextStyle(color: Colors.green))
    ],
  )),
  flushbarPosition: FlushbarPosition.TOP,
  flushbarStyle: FlushbarStyle.FLOATING,
  backgroundColor: Colors.black,
  duration: Duration(milliseconds: 2000),
  margin: EdgeInsets.symmetric(horizontal: 50),
  animationDuration: Duration(milliseconds: 100),
);
