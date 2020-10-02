import 'package:date_picker/custom_scroll.dart';
import 'package:date_picker/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'components/go_arrow_button.dart';

class PickDate extends StatefulWidget {
  final String title;

  const PickDate({Key key, this.title = "Hello World"}) : super(key: key);
  @override
  _PickDateState createState() => _PickDateState();
}

class _PickDateState extends State<PickDate> with TickerProviderStateMixin {
  Time time = Time();
  List<String> _8hrs = [
    "1hr",
    "2hrs",
    "3hrs",
    "4hrs",
    "5hrs",
    "6hrs",
    "7hrs",
    "8hrs"
  ];
  bool isVisibleHourList = false;
  bool isVisibleDayList = true;
  bool isVisibleMonthList = false;
  bool isVisibleUntileButton = true;

  int _focusHourIndex = 0;
  int _focusDayIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.only(left: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 40),
                    ),
                    isVisibleDayList
                        ? Container(
                            height: 50,
                            child: CustomScroll(
                                inputText: time.getDayList(),
                                callBack: (index) {
                                  _focusDayIndex = index;
                                  if (index != null && index != 0) {
                                    setState(() {
                                      isVisibleHourList = true;
                                    });
                                  } else {
                                    setState(() {
                                      isVisibleHourList = false;
                                    });
                                  }
                                }))
                        : SizedBox(),
                    isVisibleMonthList
                        ? Container(
                            //color: Colors.white,
                            height: 50,
                            child: CustomScroll(
                              inputText: time.getMonthList(),
                              callBack: (index) => (print(index)),
                            ))
                        : SizedBox(),
                    isVisibleHourList
                        ? Container(
                            //color: Colors.white,
                            height: 50,
                            child: CustomScroll(
                              inputText: time.getMonthList(),
                              callBack: (index) => (print(index)),
                            ))
                        : SizedBox(),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: isVisibleHourList
                          ? Container(
                              //color: Colors.white,
                              height: 50,
                              child: CustomScroll(
                                inputText: time.getHourList(),
                                callBack: (index) => (print(index)),
                              ))
                          : SizedBox(),
                    ),
                    isVisibleUntileButton
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: SvgPicture.asset(
                                    "assets/icons/btn_plus.svg"),
                                onPressed: () {
                                  print(_focusDayIndex);
                                  if (_focusDayIndex == 0) {
                                    setState(() {
                                      isVisibleDayList = false;
                                      isVisibleUntileButton = false;
                                    });
                                  } else {}
                                },
                              ),
                              Text(
                                "UNTIL",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          )
                        : SizedBox(),
                    isVisibleDayList
                        ? SizedBox()
                        : Text("Now for",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 40)),
                    isVisibleDayList
                        ? SizedBox()
                        : Container(
                            height: 50,
                            child: CustomScroll(
                              inputText: _8hrs,
                              callBack: (index) {},
                            ),
                          )
                  ]),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .2,
              child: Center(
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
        )
      ],
    );
  }
}
