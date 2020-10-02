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

  TextItemWidget get buildItem {
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
