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

class _PickDateState extends State<PickDate>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  Time time = Time();

  List<String> startDayList;
  List<int> linkToStartMonthList;
  List<String> startMonthList;
  List<int> linkToStartDayList;
  List<String> startHourList;
  List<String> endDayList;
  List<int> linkToEndMonthList;
  List<String> endMonthList;
  List<int> linkToEndDayList;
  List<String> endHourList;

  List<String> newDayHourList;

  String startDay;
  String startMonth;
  String startHour;
  String endDay;
  String endMonth;
  String endHour;

  int currentMonthInStartMonthList;
  int currentMonthInStartDayList;
  int currentMonthInEndMonthList;
  int currentMonthInEndDayList;

  _PickDateState() {
    Map dayList = time.getDayList();
    startDayList = dayList['dayStringList'];
    linkToStartMonthList = dayList['linkToMonthList'];
    startMonthList = dayList['monthStringList'];
    linkToStartDayList = dayList['linkToDayList'];
    startHourList = time.getHourList();
    currentMonthInStartMonthList = linkToStartDayList[0];
    currentMonthInStartDayList = linkToStartMonthList[0];
    newDayHourList = time.getHourList(true);
  }

  bool isVisibleNowFor = false;

  bool isVisibleStartDayList = true;
  bool isVisibleUntilButton = true;
  bool isVisibleStartHourList = false;
  bool isVisibleStartMonthList = false;
  bool isPlusOrCloseButton = true;

  bool isVisibleEndDayList = false;
  bool isVisibleEndHourList = false;
  bool isVisibleEndMonthList = false;

  bool isNewDay = false;

  int _focusStartHourIndex = 0;
  int _focusStartDayIndex = 0;
  int _focusStartMonthIndex = 0;

  int _focusEndHourIndex = 0;
  int _focusEndDayIndex = 0;
  int _focusEndMonthIndex = 0;

  int _focusHourListIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    endHourList = startHourList.sublist(_focusStartHourIndex + 1);
    linkToEndMonthList = linkToStartMonthList.sublist(_focusStartDayIndex);
    linkToEndDayList = linkToStartDayList.sublist(_focusStartMonthIndex);
    currentMonthInEndMonthList = linkToEndDayList[0];
    currentMonthInEndDayList = linkToEndMonthList[0];
  }

  _handleUntilButton() {
    setState(() {
      if (_focusStartDayIndex == 0) {
        isVisibleStartDayList = false;
        isVisibleUntilButton = false;
        isVisibleEndDayList = false;
        isVisibleEndHourList = false;
        isVisibleEndMonthList = false;
        isVisibleNowFor = true;
      } else {
        _getEndListTime();
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
    scrollController.animateTo(MediaQuery.of(context).size.height * .13 + 60,
        duration: Duration(seconds: 1), curve: Curves.ease);
  }

  void _getPickedDate() {
    if (isVisibleNowFor) {
      startDay = 'Today';
      startMonth = startMonthList[_focusStartMonthIndex];
      startHour = 'Now';
      endDay = '';
      endMonth = '';
      endHour = time
          .formatTime(DateTime.now().add(Duration(hours: _focusHourListIndex)));
    } else {
      startDay = startDayList[_focusStartDayIndex];
      startMonth = startMonthList[_focusStartMonthIndex];
      startHour = startHourList[_focusStartHourIndex];
      if (endDayList != null) {
        endDay = endDayList[_focusEndDayIndex];
        endMonth = endMonthList[_focusEndMonthIndex];
        endHour = endHourList[_focusEndHourIndex];
      } else {
        endDay = '';
        endMonth = '';
        endHour = '';
      }
    }
    if (startDay == endDay && startMonth == endMonth) {
      endDay = '';
      endMonth = '';
    }
  }

  _handleGoArrowButton() {
    if ((_focusStartDayIndex == 0) && !isVisibleNowFor) {
      _handleUntilButton();
      //flushbar.show(context);
    } else {
      _getPickedDate();
      String pickedDate =
          '$startDay $startMonth $startHour ${endHour == '' ? '' : '-'} $endDay $endMonth $endHour';
      Navigator.pushNamed(context, "/placescreen/${widget.title}/$pickedDate");
    }
  }

  GlobalKey<CustomScrollState> startDayKey = GlobalKey();
  GlobalKey<CustomScrollState> startMonthKey = GlobalKey();
  GlobalKey<CustomScrollState> endDayKey = GlobalKey();
  GlobalKey<CustomScrollState> endMonthKey = GlobalKey();
  GlobalKey<CustomScrollState> endHourKey = GlobalKey();

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
                    ListView(controller: scrollController, children: [
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
                                  haveLinkingList: true,
                                  linkingList: linkToStartMonthList,
                                  key: startDayKey,
                                  linkCallBack: (index, link) {
                                    _focusStartDayIndex = index;
                                    currentMonthInStartDayList = link;
                                    if (currentMonthInStartDayList !=
                                        currentMonthInStartMonthList) {
                                      int start = 0;
                                      if (currentMonthInStartDayList ==
                                          linkToStartDayList[0]) {
                                        start = index > startDayList.length ~/ 2
                                            ? linkToStartDayList.length ~/ 2
                                            : 0;
                                      }
                                      startMonthKey.currentState.quickFocusOn(
                                          linkToStartDayList.indexOf(
                                              currentMonthInStartDayList,
                                              start));
                                    }

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
                                  haveLinkingList: true,
                                  linkingList: linkToStartDayList,
                                  key: startMonthKey,
                                  linkCallBack: (index, link) {
                                    _focusStartMonthIndex = index;
                                    currentMonthInStartMonthList = link;
                                    if (currentMonthInStartMonthList !=
                                        currentMonthInStartDayList) {
                                      int start = 0;
                                      if (index ==
                                          linkToStartDayList.length - 1) {
                                        start =
                                            linkToStartMonthList.length ~/ 2;
                                      }
                                      int newIndex =
                                          linkToStartMonthList.indexOf(
                                              currentMonthInStartMonthList,
                                              start);
                                      newIndex = newIndex == 0 ? 3 : newIndex;
                                      startDayKey.currentState
                                          .quickFocusOn(newIndex);
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
                                  haveLinkingList: false,
                                  callBack: (index) =>
                                      (_focusStartHourIndex = index),
                                ))
                            : SizedBox(),
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: isVisibleNowFor
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
                        child: isVisibleNowFor
                            ? Container(
                                height: 50,
                                child: CustomScroll(
                                  inputText: Time.hoursList,
                                  haveLinkingList: false,
                                  callBack: (index) {
                                    _focusHourListIndex = index;
                                  },
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
                                    haveLinkingList: true,
                                    linkingList: linkToEndMonthList,
                                    key: endDayKey,
                                    linkCallBack: (index, link) {
                                      if (index == 0) {
                                        setState(() {
                                          isNewDay = false;
                                          endHourKey.currentState.focusOn(0);
                                        });
                                      } else {
                                        if (isNewDay == false) {
                                          setState(() {
                                            isNewDay = true;
                                            endHourKey.currentState.focusOn(0);
                                          });
                                        }
                                      }
                                      _focusEndDayIndex = index;
                                      _handleVisibleMonthList();
                                      currentMonthInEndDayList = link;
                                      if (currentMonthInEndDayList !=
                                          currentMonthInEndMonthList) {
                                        int start = 0;
                                        if (currentMonthInEndDayList ==
                                            linkToEndDayList[0]) {
                                          start = index > endDayList.length ~/ 2
                                              ? linkToEndDayList.length ~/ 2
                                              : 0;
                                        }
                                        endMonthKey.currentState.quickFocusOn(
                                            linkToEndDayList.indexOf(
                                                currentMonthInEndDayList,
                                                start));
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
                                  haveLinkingList: true,
                                  linkingList: linkToEndDayList,
                                  key: endMonthKey,
                                  linkCallBack: (index, link) {
                                    _focusEndMonthIndex = index;
                                    currentMonthInEndMonthList = link;
                                    if (currentMonthInEndMonthList !=
                                        currentMonthInEndDayList) {
                                      int start = 0;
                                      if (index ==
                                          linkToEndDayList.length - 1) {
                                        start = linkToEndMonthList.length ~/ 2;
                                      }
                                      int newIndex = linkToEndMonthList.indexOf(
                                          currentMonthInEndMonthList, start);
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
                                    inputText:
                                        isNewDay ? newDayHourList : endHourList,
                                    key: endHourKey,
                                    haveLinkingList: false,
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
                                Colors.transparent,
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
                                Colors.transparent,
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
                    press: () {
                      _handleGoArrowButton();
                    },
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
              isPlusOrCloseButton = true;
            } else {
              setState(() {
                if (isVisibleNowFor == true) {
                  isVisibleNowFor = false;
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
