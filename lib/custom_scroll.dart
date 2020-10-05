import 'package:date_picker/text_item.dart';
import 'package:flutter/material.dart';

typedef void IndexCallBack(int index);

class CustomScroll extends StatefulWidget {
  final int focusOn;
  final List<String> inputText;
  final IndexCallBack callBack;
  final List<TextItem> textItemList = [];
  CustomScroll({this.focusOn, this.inputText, this.callBack, Key key})
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
    double position = scrollController.position.pixels >= 0
        ? scrollController.position.pixels
        : 0;
    position = scrollController.position.pixels <= maxPosition
        ? scrollController.position.pixels
        : maxPosition;
    int index = getIndex(position);
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
    widget.callBack(index);
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
    _animateScroll(location, true);
  }

  void _animateScroll(double location, [bool quickScroll = false]) {
    Future.delayed(Duration.zero, () {
      scrollController.animateTo(
        location,
        duration: quickScroll
            ? Duration(microseconds: 10)
            : Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }
}
