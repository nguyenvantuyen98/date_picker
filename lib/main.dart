import 'package:date_picker/fluro_router.dart';
import 'package:date_picker/screen/pick_date.dart';
import 'package:flutter/material.dart';

void main() {
  FluroRouter().setRouter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Date Picker',
      theme: ThemeData(
        primaryColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      home: PickDate(),
      //initialRoute: "/pickdate",
      initialRoute: "/",
      onGenerateRoute: FluroRouter.router.generator,
      //home: HomePage(),
    );
  }
}
