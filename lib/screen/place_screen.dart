import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

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
        padding: EdgeInsets.only(left: ScreenUtil().screenWidth * .121),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    height: ScreenUtil().screenHeight * .14,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: ScreenUtil().screenHeight * .056),
                  ),
                  Text(
                    pickedDate,
                    style: TextStyle(
                        height: 1.28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: ScreenUtil().screenHeight * .056),
                  ),
                  TextField(
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().screenHeight * .056),
                    decoration: InputDecoration(
                      hintText: "Place",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF232323),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: ScreenUtil().screenHeight * 0.193,
              child: Align(
                alignment: Alignment.topCenter,
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
