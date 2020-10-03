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

  List<String> hoursList = [
    "1hr",
    "2hrs",
    "3hrs",
    "4hrs",
    "5hrs",
    "6hrs",
    "7hrs",
    "8hrs"
  ];
  List<String> endDayList = [];
  List<String> endHourList = [];
  List<String> endMonthList = [];

  bool isVisibleStartDayList = true;
  bool isVisibleUntilButton = true;
  bool isVisibleStartHourList = false;
  bool isVisibleStartMonthList = false;
  bool isPlusOrCloseButton = true;

  bool isVisibleEndDayList = false;
  bool isVisibleEndHourList = false;
  bool isVisibleEndMonthList = false;

  int _focusStartHourIndex = 0;
  int _focusStartDayIndex = 0;
  int _focusStartMonthIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _handleVisibleStartTimeList() {
    setState(() {
      if (_focusStartDayIndex != null && _focusStartDayIndex != 0) {
        isVisibleStartHourList = true;
      } else {
        isVisibleStartHourList = false;
      }
      if (_focusStartDayIndex > 2) {
        isVisibleStartMonthList = true;
      } else {
        isVisibleStartMonthList = false;
      }
    });
  }

  _getEndListTime() {
    endDayList = [];
    endHourList = [];
    endMonthList = [];
    for (int i = _focusStartDayIndex;
        i < time.getDayList()["dayStringList"].length;
        i++) {
      endDayList.add(time.getDayList()["dayStringList"][i]);
    }
    for (int i = _focusStartHourIndex; i < time.getHourList().length; i++) {
      endHourList.add(time.getHourList()[i]);
    }
    for (int i = _focusStartMonthIndex; i < time.getMonthList().length; i++) {
      endMonthList.add(time.getMonthList()[i]);
    }
  }

  _handleUntilButton() {
    _getEndListTime();
    setState(() {
      if (_focusStartDayIndex == 0) {
        isVisibleStartDayList = false;
        isVisibleUntilButton = false;
        isVisibleEndDayList = false;
        isVisibleEndHourList = false;
        isVisibleEndMonthList = false;
      } else {
        isPlusOrCloseButton = !isPlusOrCloseButton;
        if (!isPlusOrCloseButton) {
          if (_focusStartDayIndex < 3) {
            isVisibleEndDayList = true;
            isVisibleEndHourList = true;
          } else {
            isVisibleEndDayList = true;
            isVisibleEndHourList = true;
            isVisibleEndMonthList = true;
          }
        } else {
          isVisibleEndDayList = false;
          isVisibleEndHourList = false;
          isVisibleEndMonthList = false;
        }
      }
    });
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
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .15,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.white, Colors.transparent])),
                    ),
                  ),
                  ListView(children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .15,
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 40),
                    ),
                    isVisibleStartDayList
                        ? Container(
                            height: 50,
                            child: CustomScroll(
                                inputText: time.getDayList()["dayStringList"],
                                callBack: (index) {
                                  _focusStartDayIndex = index;
                                  //print(_focusStartDayIndex);
                                  _handleVisibleStartTimeList();
                                }))
                        : SizedBox(),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: isVisibleStartMonthList
                          ? Container(
                              //color: Colors.white,
                              height: 50,
                              child: CustomScroll(
                                inputText: time.getMonthList(),
                                callBack: (index) {
                                  _focusStartMonthIndex = index;
                                },
                              ))
                          : SizedBox(),
                    ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: isVisibleStartHourList
                          ? Container(
                              //color: Colors.white,
                              height: 50,
                              child: CustomScroll(
                                inputText: time.getHourList(),
                                callBack: (index) =>
                                    (_focusStartHourIndex = index),
                              ))
                          : SizedBox(),
                    ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: isVisibleStartDayList
                          ? SizedBox()
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Now for",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 40)),
                            ),
                    ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: isVisibleStartDayList
                          ? SizedBox()
                          : Container(
                              height: 50,
                              child: CustomScroll(
                                inputText: hoursList,
                                callBack: (index) {},
                              ),
                            ),
                    ),
                    isVisibleUntilButton
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: isPlusOrCloseButton
                                    ? SvgPicture.asset(
                                        "assets/icons/btn_plus.svg")
                                    : SvgPicture.asset(
                                        "assets/icons/btn_close.svg"),
                                onPressed: () {
                                  _handleUntilButton();
                                },
                              ),
                              Text(
                                "UNTIL",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          )
                        : SizedBox(),

                    // End date picker

                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: isVisibleEndDayList
                          ? Container(
                              height: 50,
                              child: CustomScroll(
                                  inputText: endDayList,
                                  callBack: (index) {
                                    // _focusDayIndex = index;
                                    // _handleVisibleStartTimeList();
                                  }))
                          : SizedBox(),
                    ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: isVisibleEndMonthList
                          ? Container(
                              //color: Colors.white,
                              height: 50,
                              child: CustomScroll(
                                inputText: endMonthList,
                                callBack: (index) {},
                              ))
                          : SizedBox(),
                    ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: isVisibleEndHourList
                          ? Container(
                              //color: Colors.white,
                              height: 50,
                              child: CustomScroll(
                                  inputText: endHourList,
                                  callBack: (index) {
                                    print(index);
                                  }))
                          : SizedBox(),
                    ),
                  ]),
                  // Positioned(
                  //   right: 0,
                  //   left: 0,
                  //   bottom: 0,
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height * .15,
                  //     decoration: BoxDecoration(
                  //         color: Colors.transparent,
                  //         gradient: LinearGradient(
                  //             begin: Alignment.topCenter,
                  //             end: Alignment.bottomCenter,
                  //             colors: [
                  //               Colors.transparent,
                  //               Colors.white,
                  //             ])),
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .2,
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
        )
      ],
    );
  }
}
