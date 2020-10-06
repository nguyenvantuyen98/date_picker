import 'package:flutter/material.dart';

import 'components/go_arrow_button.dart';

class PlaceScreen extends StatelessWidget {
  final String title;
  final String pickedDate;

  const PlaceScreen({Key key, this.title, this.pickedDate}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.only(left: 40),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .13,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 40),
                  ),
                  Text(
                    pickedDate,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 40),
                  ),
                  TextField(
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                    decoration: InputDecoration(
                      hintText: "Place",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF232323),
                        fontSize: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .2,
              child: Align(
                alignment: Alignment.center,
                child: GoArrowButton(
                  press: () {},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey.withOpacity(.6),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.grey.withOpacity(.6),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
