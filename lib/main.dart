import 'package:date_picker/fluro_router.dart';
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
      //home: HomePage(),
      initialRoute: "/pickdate",
      onGenerateRoute: FluroRouter.router.generator,
      //home: HomePage(),
    );
  }
}
