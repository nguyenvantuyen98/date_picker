import 'package:date_picker/time.dart';
import 'package:flutter/material.dart';
import 'custom_scroll.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List View Example',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List<String> inputText = time.getHourList();

    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: CustomScroll(
        inputText: inputText,
        callBack: (index) {
          print(index);
        },
      )),
    );
  }
}
