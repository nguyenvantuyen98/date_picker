import 'package:date_picker/text_item.dart';
import 'package:flutter/material.dart';

typedef void IndexCallBack(int index);
typedef void LinkCallBack(int index, int link);

class CustomScroll extends StatefulWidget {
  final int focusOn;
  final List<String> inputText;
  final IndexCallBack callBack;
  final LinkCallBack linkCallBack;
  final List<int> linkingList;
  final List<TextItem> textItemList = [];
  final bool haveLinkingList;
  CustomScroll(
      {this.focusOn,
      this.inputText,
      this.callBack,
      this.linkCallBack,
      Key key,
      this.linkingList,
      this.haveLinkingList})
      : super(key: key) {
    for (String text in inputText) {
      textItemList.add(TextItem(text: text));
    }
  }

  @override
  CustomScrollState createState() => CustomScrollState();
}

class CustomScrollState extends State<CustomScroll> {
  ScrollController scrollController = ScrollController();
  int focus = 0;
  double maxPosition = 0.0;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.focusOn != null && widget.focusOn < widget.inputText.length) {
        focus = widget.focusOn;
        focusOn(focus);
      }
      for (TextItem textItem in widget.textItemList) {
        maxPosition += textItem.getSize(context).width + 20;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.textItemList.length + 1,
        itemBuilder: (context, index) {
          return index < widget.textItemList.length
              ? GestureDetector(
                  child: index == focus
                      ? widget.textItemList[index].buildItem(true)
                      : widget.textItemList[index].buildItem(false),
                  onTap: () => focusOn(index),
                  onDoubleTap: () => focusOn(index),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width -
                      widget.textItemList[widget.textItemList.length - 1]
                          .getSize(context)
                          .width);
        },
      ),
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          double stopPosition = notification.metrics.pixels;
          int index = getIndex(stopPosition);
          focusOn(index);
        }
        return true;
      },
    );
  }

  _scrollListener() {
    int index = getIndex(scrollController.position.pixels <= maxPosition
        ? scrollController.position.pixels
        : maxPosition);
    if (focus != index) {
      lightUp(index);
    }
  }

  int getIndex(double position) {
    double currentPosition = 0.0;
    int index = 0;
    while (position > currentPosition) {
      currentPosition += widget.textItemList[index].getSize(context).width + 20;
      if (position < currentPosition) {
        break;
      }
      index += 1;
    }
    return index;
  }

  void lightUp(int index) {
    setState(() {
      focus = index;
    });
    if (!widget.haveLinkingList) {
      if (index >= 0 && index < widget.textItemList.length) {
        widget.callBack(index);
      }
    } else {
      if (index >= 0 && index < widget.textItemList.length) {
        widget.linkCallBack(index, widget.linkingList[index]);
      }
    }
  }

  void focusOn(int index) {
    double location = 0.0;
    for (int i = 0; i < index; i++) {
      location += widget.textItemList[i].getSize(context).width + 20;
    }
    _animateScroll(location);
  }

  void quickFocusOn(int index) {
    double location = 0.0;
    for (int i = 0; i < index; i++) {
      location += widget.textItemList[i].getSize(context).width + 20;
    }
    scrollController.jumpTo(location);
  }

  void _animateScroll(double location) {
    Future.delayed(Duration.zero, () {
      scrollController.animateTo(
        location,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }
}
