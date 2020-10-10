import 'package:date_picker/custom_scroll.dart';
import 'package:date_picker/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'components/flush_bar.dart';
import 'components/go_arrow_button.dart';

class PickDate extends StatefulWidget {
  final String title;

  const PickDate({Key key, this.title = "Everything"}) : super(key: key);
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

  bool isNewStartDay = false;
  bool isNewEndDay = false;

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

  int _focusHourListIndex = 0;

  _handleVisibleStartTimeList() {
    setState(() {
      if (_focusStartDayIndex != null && _focusStartDayIndex != 0) {
        isVisibleStartHourList = true;
      } else {
        isVisibleStartHourList = false;
        isPlusOrCloseButton = true;
        isVisibleEndDayList = false;
        isVisibleEndHourList = false;
        isVisibleEndMonthList = false;
      }
      if (_focusStartDayIndex > 1) {
        isNewStartDay = true;
      } else {
        isNewStartDay = false;
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
    // If choose the last day, last hour, endList start in the same
    if (_focusStartHourIndex ==
            (isNewStartDay
                ? (newDayHourList.length - 1)
                : (startHourList.length - 1)) &&
        _focusStartDayIndex == startDayList.length - 1 &&
        _focusStartMonthIndex == startMonthList.length - 1) {
      endHourList = isNewStartDay
          ? newDayHourList.sublist(_focusStartHourIndex)
          : startHourList.sublist(_focusStartHourIndex);
      endDayList = startDayList.sublist(_focusStartDayIndex);
      endMonthList = startMonthList.sublist(_focusStartMonthIndex);
    }
    // if choose 11h45 of a day, endList start in the nextDay
    else if (_focusStartHourIndex ==
        (isNewStartDay
            ? (newDayHourList.length - 1)
            : (startHourList.length - 1))) {
      endHourList = newDayHourList;
      endDayList = startDayList.sublist(_focusStartDayIndex + 1);
      if (linkToStartMonthList[_focusStartDayIndex] !=
          linkToStartMonthList[_focusStartDayIndex + 1]) {
        endMonthList = startMonthList.sublist(_focusStartMonthIndex + 1);
      } else {
        endMonthList = startMonthList.sublist(_focusStartMonthIndex);
      }
    }
    // else
    else {
      endDayList = startDayList.sublist(_focusStartDayIndex);
      endMonthList = startMonthList.sublist(_focusStartMonthIndex);
      endHourList = isNewStartDay
          ? newDayHourList.sublist(_focusStartHourIndex)
          : startHourList.sublist(_focusStartHourIndex);
      // delete the wrong time, example: if choosing Afternoon, delete Anytime, Morning, 0am,0:15am,...13pm.
      endHourList = filter(endHourList);
    }

    linkToEndMonthList = linkToStartMonthList.sublist(_focusStartDayIndex);
    linkToEndDayList = linkToStartDayList.sublist(_focusStartMonthIndex);
    currentMonthInEndMonthList = linkToEndDayList[0];
    currentMonthInEndDayList = linkToEndMonthList[0];
  }

  List<String> filter(List<String> endHourList) {
    if (endHourList[0] == 'Anytime') return endHourList;
    List<int> endTime = time.decodeHour(endHourList[0]);
    int endHour = endTime[0];
    int endMinute = endTime[1];
    List<String> newEndHourList = [];
    for (int i = 0; i < endHourList.length; i++) {
      List<int> timeDecode = time.decodeHour(endHourList[i]);
      int hourDecode = timeDecode[0];
      int minuteDecode = timeDecode[1];
      if (hourDecode > endHour ||
          hourDecode == endHour && endMinute < minuteDecode) {
        newEndHourList.add(endHourList[i]);
      }
    }
    //Handle night range time
    // if (endHourList[0] == 'Night') {
    //     print("index can tim ${endHourList.indexOf("0am")}");
    //     print("index can tim ${endHourList.indexOf("5am")}");
    //     for (int i = endHourList.indexOf("0am");
    //         i <= endHourList.indexOf("5am");
    //         i++) {
    //       newEndHourList.add(endHourList[i]);
    //     }
    //   }
    if (endHourList[0].contains('n') || endHourList[0].contains('N'))
      newEndHourList.insert(0, endHourList[0]);
    return newEndHourList;
  }

  // List<String> filter(List<String> endHourList) {
  //   if (endHourList[0] == 'Anytime') return endHourList;
  //   List<int> endTime = time.decodeHour(endHourList[0]);
  //   int endHour = endTime[0];
  //   int endMinute = endTime[1];
  //   List<String> newEndHourList = [];
  //   for (int i = 0; i < endHourList.length; i++) {
  //     List<int> timeDecode = time.decodeHour(endHourList[i]);
  //     int hourDecode = timeDecode[0];
  //     int minuteDecode = timeDecode[1];
  //     if (hourDecode > endHour ||
  //         hourDecode == endHour && endMinute != minuteDecode) {
  //       newEndHourList.add(endHourList[i]);
  //     }
  //   }
  //   if (endHourList[0].contains('n') || endHourList[0].contains('N'))
  //     newEndHourList.insert(0, endHourList[0]);
  //   return newEndHourList;
  // }
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
          _focusEndHourIndex = 0;
          _focusEndDayIndex = 0;
          _focusEndMonthIndex = 0;
          isNewEndDay = false;

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
    isPlusOrCloseButton
        ? scrollController.animateTo(0,
            duration: Duration(seconds: 1), curve: Curves.ease)
        : isVisibleStartMonthList
            ? scrollController.animateTo(ScreenUtil().screenHeight * .3,
                duration: Duration(seconds: 1), curve: Curves.ease)
            : scrollController.animateTo(ScreenUtil().screenHeight * .14,
                duration: Duration(seconds: 1), curve: Curves.ease);
  }

  List<String> _getPickedDate() {
    String startDay;
    String startMonth;
    String startHour;
    String endDay;
    String endMonth;
    String endHour;
    if (isVisibleNowFor) {
      startDay = 'Today';
      startMonth = startMonthList[_focusStartMonthIndex];
      startHour = 'Now';
      DateTime nextTime =
          DateTime.now().add(Duration(hours: _focusHourListIndex + 1));
      endDay = time.formatDay(nextTime);
      endMonth = time.getMonth(nextTime.month);
      endHour = time.formatTime(nextTime);
    } else {
      startDay = startDayList[_focusStartDayIndex];
      startMonth = startMonthList[_focusStartMonthIndex];
      startHour = isNewStartDay
          ? newDayHourList[_focusStartHourIndex]
          : startHourList[_focusStartHourIndex];
      if (endDayList != null) {
        endDay = endDayList[_focusEndDayIndex];
        endMonth = endMonthList[_focusEndMonthIndex];
        endHour = isNewEndDay
            ? newDayHourList[_focusEndHourIndex]
            : endHourList[_focusEndHourIndex];
      } else {
        endDay = '';
        endMonth = '';
        endHour = '';
      }
    }
    print([startMonth, startDay, startHour, endMonth, endDay, endHour]);
    return [startMonth, startDay, startHour, endMonth, endDay, endHour];
  }

  _handleGoArrowButton() {
    if ((_focusStartDayIndex == 0) && !isVisibleNowFor) {
      _handleUntilButton();
    } else {
      List<String> timePicked = _getPickedDate();

      if (time.checkDate(timePicked)) {
        if (timePicked[2] == 'Now' ||
            timePicked[1] == timePicked[4] && timePicked[0] == timePicked[3]) {
          timePicked[4] = '';
          timePicked[3] = '';
        }

        String pickedDate =
            '${timePicked[1]} ${timePicked[0]} ${timePicked[2]} ${timePicked[5] == '' ? '' : '-'} ${timePicked[4]} ${timePicked[3]} ${timePicked[5]}';
        Navigator.pushNamed(
            context, "/placescreen/${widget.title}/$pickedDate");
      } else {
        flushbar.show(context);
      }
    }
  }

  GlobalKey<CustomScrollState> startDayKey = GlobalKey();
  GlobalKey<CustomScrollState> startMonthKey = GlobalKey();
  GlobalKey<CustomScrollState> endDayKey = GlobalKey();
  GlobalKey<CustomScrollState> endMonthKey = GlobalKey();
  GlobalKey<CustomScrollState> startHourKey = GlobalKey();
  GlobalKey<CustomScrollState> startNewHourKey = GlobalKey();
  GlobalKey<CustomScrollState> endHourKey = GlobalKey();
  GlobalKey<CustomScrollState> endNewHourKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(1242, 2688));
    print(
        "screenWidth ${ScreenUtil().screenWidth}, screenheight ${ScreenUtil().screenHeight}");
    print(
        "screenWidthPx ${ScreenUtil().screenWidthPx}, screenheightPX ${ScreenUtil().screenHeightPx}");
    print(
        "scaleWidth ${ScreenUtil().scaleWidth}, scaleHeight ${ScreenUtil().scaleHeight}");
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: ScreenUtil().screenWidth * .121),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ListView(controller: scrollController, children: [
                      Container(
                        height: ScreenUtil().screenHeight * .14,
                      ),
                      Text(
                        widget.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: ScreenUtil().screenHeight * .056),
                      ),
                      isVisibleStartDayList
                          ? Container(
                              height: ScreenUtil().screenHeight * .065,
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().screenHeight * .038),
                              child: CustomScroll(
                                  inputText: startDayList,
                                  haveLinkingList: true,
                                  linkingList: linkToStartMonthList,
                                  key: startDayKey,
                                  linkCallBack: (index, link) {
                                    _focusStartDayIndex = index;
                                    if (index >= 1) {
                                      if (isNewStartDay != true) {
                                        setState(() {
                                          isNewStartDay = true;
                                        });
                                      }
                                    } else if (isNewStartDay == true) {
                                      setState(() {
                                        isNewStartDay = false;
                                      });
                                    }
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
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().screenHeight * .029),
                                height: ScreenUtil().screenHeight * .065,
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
                                        print("start ${start}");
                                      }
                                      int newIndex =
                                          linkToStartMonthList.indexOf(
                                              currentMonthInStartMonthList,
                                              start);
                                      newIndex = newIndex == 0 ? 3 : newIndex;
                                      print("New index ${newIndex}");
                                      startDayKey.currentState
                                          .quickFocusOn(newIndex);
                                    }
                                  },
                                ),
                              )
                            : SizedBox(),
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: isVisibleStartHourList
                            ? AnimatedSwitcher(
                                duration: Duration(milliseconds: 300),
                                child: isNewStartDay
                                    ? Container(
                                        margin: EdgeInsets.only(
                                          top: ScreenUtil().screenHeight * .029,
                                        ),
                                        height:
                                            ScreenUtil().screenHeight * .065,
                                        child: CustomScroll(
                                          inputText: newDayHourList,
                                          haveLinkingList: false,
                                          key: startNewHourKey,
                                          callBack: (index) =>
                                              (_focusStartHourIndex = index),
                                        ))
                                    : Container(
                                        margin: EdgeInsets.only(
                                          top: ScreenUtil().screenHeight * .029,
                                        ),
                                        height:
                                            ScreenUtil().screenHeight * .065,
                                        child: CustomScroll(
                                          inputText: startHourList,
                                          haveLinkingList: false,
                                          key: startHourKey,
                                          callBack: (index) =>
                                              (_focusStartHourIndex = index),
                                        )))
                            : SizedBox(),
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: isVisibleNowFor
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: ScreenUtil().screenHeight * .022),
                                  child: SizedBox(
                                    height: ScreenUtil().screenHeight * .071,
                                    child: Text("Now for",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize:
                                                ScreenUtil().screenHeight *
                                                    .056)),
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: isVisibleNowFor
                            ? Container(
                                height: ScreenUtil().screenHeight * .056,
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().screenHeight * .03),
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
                          ? Padding(
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().screenHeight * .036),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: isPlusOrCloseButton
                                        ? SvgPicture.asset(
                                            "assets/icons/btn_plus.svg",
                                          )
                                        : SvgPicture.asset(
                                            "assets/icons/btn_close.svg",
                                          ),
                                    onPressed: () {
                                      _handleUntilButton();
                                    },
                                  ),
                                  Text(
                                    "UNTIL",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            ScreenUtil().screenWidth * .0289),
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),

                      // End date picker

                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        child: isVisibleEndDayList
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().screenHeight * .073),
                                height: ScreenUtil().screenHeight * .065,
                                child: CustomScroll(
                                    inputText: endDayList,
                                    haveLinkingList: true,
                                    linkingList: linkToEndMonthList,
                                    key: endDayKey,
                                    linkCallBack: (index, link) {
                                      if (index != 0) {
                                        if (isNewEndDay != true) {
                                          setState(() {
                                            isNewEndDay = true;
                                          });
                                        }
                                      } else if (isNewEndDay == true) {
                                        setState(() {
                                          isNewEndDay = false;
                                        });
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
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().screenHeight * .029),
                                height: ScreenUtil().screenHeight * .065,
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
                            ? AnimatedSwitcher(
                                duration: Duration(milliseconds: 300),
                                child: isNewEndDay
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            top: ScreenUtil().screenHeight *
                                                .029),
                                        height:
                                            ScreenUtil().screenHeight * .065,
                                        child: CustomScroll(
                                            inputText: newDayHourList,
                                            key: endNewHourKey,
                                            haveLinkingList: false,
                                            callBack: (index) {
                                              _focusEndHourIndex = index;
                                            }))
                                    : Container(
                                        margin: EdgeInsets.only(
                                            top: ScreenUtil().screenHeight *
                                                .029),
                                        height:
                                            ScreenUtil().screenHeight * .065,
                                        child: CustomScroll(
                                            inputText: endHourList,
                                            key: endHourKey,
                                            haveLinkingList: false,
                                            callBack: (index) {
                                              _focusEndHourIndex = index;
                                            })))
                            : SizedBox(),
                      ),
                      Container(
                        height: ScreenUtil().screenHeight * .152,
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
                                Color(0xFF000000),
                                Color.fromRGBO(0, 0, 0, 0.95),
                                Color.fromRGBO(0, 0, 0, 0.85),
                                Color.fromRGBO(0, 0, 0, 0.5),
                                Color.fromRGBO(0, 0, 0, 0),
                              ],
                            ).createShader(bounds);
                          },
                          child: Container(
                            height: ScreenUtil().screenHeight * .18,
                            color: Colors.transparent,
                          ),
                          blendMode: BlendMode.dstATop,
                        )),
                    isPlusOrCloseButton
                        ? SizedBox()
                        : Positioned(
                            right: 0,
                            left: 0,
                            bottom: 0,
                            child: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    Color.fromRGBO(0, 0, 0, 0),
                                    Color.fromRGBO(0, 0, 0, 0.55),
                                    Color.fromRGBO(0, 0, 0, 0.85),
                                    Color(0xFF000000)
                                  ],
                                ).createShader(bounds);
                              },
                              child: Container(
                                height: ScreenUtil().screenHeight * .153,
                                color: Colors.transparent,
                              ),
                              blendMode: BlendMode.dstATop,
                            )),
                  ],
                ),
              ),
              Container(
                height: ScreenUtil().screenHeight * 0.193,
                child: Align(
                  alignment: Alignment.topCenter,
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
            color: Color(0xFF5e5e5e),
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
            color: Color(0xFF5e5e5e),
          ),
          onPressed: () {},
        )
      ],
    );
  }
}
