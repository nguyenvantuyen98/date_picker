import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class GoArrowButton extends StatelessWidget {
  final Function press;
  const GoArrowButton({
    Key key,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        height: ScreenUtil().screenWidth * .222,
        width: ScreenUtil().screenHeight * .103,
        //color: Colors.red,
        child: Center(
          child: SvgPicture.asset(
            "assets/icons/icon_arrow_go.svg",
            color: Colors.white,
            width: ScreenUtil().screenWidth * .101,
            height: ScreenUtil().screenHeight * .04,
          ),
        ),
      ),
    );
  }
}
