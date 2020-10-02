import 'package:flutter/material.dart';

class TextItem {
  final String text;
  TextStyle textStyle;
  bool isFocus;
  TextItem(
      {this.text,
      this.textStyle = const TextStyle(
          fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF232323)),
      this.isFocus = false});
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

  Container get buildItem {
    return Container(
      padding: EdgeInsets.only(right: 20),
      child: Text(
        text,
        style: isFocus
            ? TextStyle(
                fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)
            : textStyle,
      ),
    );
  }
}
