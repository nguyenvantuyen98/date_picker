import 'package:date_picker/custom_scroll.dart';
import 'package:date_picker/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'components/go_arrow_button.dart';

class PickDate extends StatefulWidget {
  final String title;

  const PickDate({Key key, this.title}) : super(key: key);
  @override
  _PickDateState createState() => _PickDateState();
}

class _PickDateState extends State<PickDate> {
  Time time = Time();

  List<String> startDayList;
  List<int> linkToStartMonthList;
  List<String> startMonthList;
  List<String> startHourList;
  List<String> endDayList;
  List<int> linkToEndMonthList;
  List<String> endMonthList;
  List<String> endHourList;

  int currentMonthInStartMonthList;
  int currentMonthInStartDayList;
  int currentMonthInEndMonthList;
  int currentMonthInEndDayList;

  _PickDateState() {
    Map dayList = time.getDayList();
    startDayList = dayList['dayStringList'];
    linkToStartMonthList = dayList['linkToMonthList'];
    startMonthList = time.getMonthList();
    startHourList = time.getHourList();
    currentMonthInStartMonthList = 13 - startMonthList.length;
    currentMonthInStartDayList = linkToStartMonthList[0];
  }

  bool isVibileNowFor = false;

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

  int _focusEndHourIndex = 0;
  int _focusEndDayIndex = 0;
  int _focusEndMonthIndex = 0;

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

  _handleVisibleMonthList() {
    setState(() {
      if (endDayList[_focusEndDayIndex] == "Today" && _focusEndDayIndex == 0 ||
          endDayList[_focusEndDayIndex] == "Tomorrow" &&
              _focusEndDayIndex == 1) {
        isVisibleEndMonthList = false;
      } else {
        isVisibleEndMonthList = true;
      }
    });
  }

  _getEndListTime() {
    endDayList = startDayList.sublist(_focusStartDayIndex);
    endMonthList = startMonthList.sublist(_focusStartMonthIndex);
    endHourList = startHourList.sublist(_focusStartHourIndex);
    linkToEndMonthList = linkToStartMonthList.sublist(_focusStartDayIndex);
    currentMonthInEndMonthList = 13 - endMonthList.length;
    currentMonthInEndDayList = linkToEndMonthList[0];
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
        isVibileNowFor = true;
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

  GlobalKey<CustomScrollState> startDayKey = GlobalKey();
  GlobalKey<CustomScrollState> startMonthKey = GlobalKey();
  GlobalKey<CustomScrollState> endDayKey = GlobalKey();
  GlobalKey<CustomScrollState> endMonthKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ListView(children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .13,
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
                              height: 60,
                              margin: EdgeInsets.only(top: 20),
                              child: CustomScroll(
                                  inputText: startDayList,
                                  key: startDayKey,
                                  callBack: (index) {
                                    _focusStartDayIndex = index;
                                    currentMonthInStartDayList =
                                        linkToStartMonthList[index];
                                    if (currentMonthInStartDayList !=
                                        currentMonthInStartMonthList) {
                                      startMonthKey.currentState.focusOn(
                                          currentMonthInStartDayList +
                                              startMonthList.length -
                                              13);
                                    }
                                    //print(_focusStartDayIndex);
                                    _handleVisibleStartTimeList();
                                  }))
                          : SizedBox(),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: isVisibleStartMonthList
                            ? Container(
                                //color: Colors.white,
                                height: 60,
                                child: CustomScroll(
                                  inputText: startMonthList,
                                  key: startMonthKey,
                                  callBack: (index) {
                                    _focusStartMonthIndex = index;
                                    currentMonthInStartMonthList =
                                        13 - startMonthList.length + index;
                                    if (currentMonthInStartMonthList !=
                                        currentMonthInStartDayList) {
                                      int newIndex =
                                          linkToStartMonthList.indexOf(
                                              currentMonthInStartMonthList);

                                      startDayKey.currentState.quickFocusOn(
                                          newIndex == 0
                                              ? newIndex + 3
                                              : newIndex);
                                    }
                                  },
                                ))
                            : SizedBox(),
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: isVisibleStartHourList
                            ? Container(
                                //color: Colors.white,
                                height: 60,
                                child: CustomScroll(
                                  inputText: startHourList,
                                  callBack: (index) =>
                                      (_focusStartHourIndex = index),
                                ))
                            : SizedBox(),
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: isVibileNowFor
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  height: 60,
                                  child: Text("Now for",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 40)),
                                ),
                              )
                            : SizedBox(),
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: isVibileNowFor
                            ? Container(
                                height: 50,
                                child: CustomScroll(
                                  inputText: Time.hoursList,
                                  callBack: (index) {},
                                ),
                              )
                            : SizedBox(),
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
                                margin: EdgeInsets.only(top: 40),
                                height: 60,
                                child: CustomScroll(
                                    inputText: endDayList,
                                    key: endDayKey,
                                    callBack: (index) {
                                      _focusEndDayIndex = index;
                                      _handleVisibleMonthList();
                                      currentMonthInEndDayList =
                                          linkToEndMonthList[index];
                                      if (currentMonthInEndDayList !=
                                          currentMonthInEndMonthList) {
                                        endMonthKey.currentState.focusOn(
                                            currentMonthInEndDayList +
                                                endMonthList.length -
                                                13);
                                      }
                                    }))
                            : SizedBox(),
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: isVisibleEndMonthList
                            ? Container(
                                //color: Colors.white,
                                height: 60,
                                child: CustomScroll(
                                  inputText: endMonthList,
                                  key: endMonthKey,
                                  callBack: (index) {
                                    _focusEndMonthIndex = index;
                                    currentMonthInEndMonthList =
                                        13 - endMonthList.length + index;

                                    if (currentMonthInEndMonthList !=
                                        currentMonthInEndDayList) {
                                      int newIndex = linkToEndMonthList
                                          .indexOf(currentMonthInEndMonthList);
                                      if (newIndex == 0) {
                                        if (endDayList[0] == "Today")
                                          newIndex += 2;
                                        else if (endDayList[0] == "Tomorrow")
                                          newIndex += 1;
                                      }
                                      endDayKey.currentState
                                          .quickFocusOn(newIndex);
                                    }
                                  },
                                ))
                            : SizedBox(),
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: isVisibleEndHourList
                            ? Container(
                                //color: Colors.white,
                                height: 60,
                                child: CustomScroll(
                                    inputText: endHourList,
                                    callBack: (index) {
                                      _focusEndHourIndex = index;
                                    }))
                            : SizedBox(),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * .15,
                      ),
                    ]),
                    Positioned(
                        right: 0,
                        left: 0,
                        top: 0,
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Colors.black,
                                Colors.black.withOpacity(.8),
                                Colors.black.withOpacity(.4),
                                Colors.black.withOpacity(.1),
                              ],
                            ).createShader(bounds);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * .13,
                            color: Colors.black,
                          ),
                          blendMode: BlendMode.dstATop,
                        )),
                    Positioned(
                        right: 0,
                        left: 0,
                        bottom: 0,
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Colors.black.withOpacity(.1),
                                Colors.black.withOpacity(.4),
                                Colors.black.withOpacity(.8),
                                Colors.black
                              ],
                            ).createShader(bounds);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * .15,
                            color: Colors.black,
                          ),
                          blendMode: BlendMode.dstATop,
                        )),
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
            if (isVisibleEndDayList) {
              _handleUntilButton();
            } else {
              setState(() {
                if (isVibileNowFor == true) {
                  isVibileNowFor = false;
                  isVisibleStartDayList = true;
                  isVisibleUntilButton = true;
                } else {
                  Navigator.pop(context);
                }
              });
            }
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
