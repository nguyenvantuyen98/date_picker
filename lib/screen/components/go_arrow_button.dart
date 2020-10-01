import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class GoArrowButton extends StatelessWidget {
  final Function press;
  const GoArrowButton({
    Key key, this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 180 * pi/180,
      child: IconButton(
        onPressed: press,
        icon: SvgPicture.asset("assets/icons/icon_arrow_detail_back.svg",
          color: Colors.white,
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}
