import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class TextItem {
  final String text;
  TextStyle textStyle = TextStyle(
      fontSize: ScreenUtil().screenHeight * .056,
      fontWeight: FontWeight.bold,
      color: Color(0xFF232323));

  TextItem({this.text});
  Size getSize(BuildContext context) {
    return (TextPainter(
            text: TextSpan(
              text: text,
              style: textStyle,
            ),
            maxLines: 1,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.ltr)
          ..layout())
        .size;
  }

  TextItemWidget buildItem(bool isFocus) {
    return TextItemWidget(
      text: text,
      isFocus: isFocus,
      textStyle: textStyle,
    );
  }
}

class TextItemWidget extends StatelessWidget {
  final String text;
  final bool isFocus;
  final TextStyle textStyle;
  TextItemWidget({this.text, this.isFocus, this.textStyle});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: ScreenUtil().screenWidth * .085),
      child: Text(
        text,
        style: isFocus
            ? TextStyle(
                fontSize: ScreenUtil().screenHeight * .056,
                fontWeight: FontWeight.bold,
                color: Colors.white)
            : textStyle,
      ),
    );
  }
}
