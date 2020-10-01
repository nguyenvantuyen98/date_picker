import 'package:date_picker/text_item.dart';
import 'package:flutter/material.dart';

typedef void IndexCallBack(int index);

class CustomScroll extends StatefulWidget {
  final IndexCallBack callBack;
  final List<String> inputText;
  final List<TextItem> textItemList = [];
  CustomScroll({this.inputText, this.callBack}) {
    for (String text in inputText) {
      textItemList.add(TextItem(text: text));
    }
  }

  @override
  _CustomScrollState createState() => _CustomScrollState();
}

class _CustomScrollState extends State<CustomScroll> {
  ScrollController scrollController = ScrollController();
  int focus = 0;

  _scrollListener() {
    double position = scrollController.position.pixels;
    double currentPosition = 0.0;
    double nextPosition = 0.0;
    for (int i = 0; i < widget.textItemList.length; i++) {
      currentPosition = nextPosition;
      nextPosition =
          currentPosition + widget.textItemList[i].getSize(context).width + 20;
      if (position > currentPosition && position < nextPosition) {
        if (i != focus) {
          setState(
            () {
              widget.textItemList[focus].isFocus = false;
              widget.textItemList[i].isFocus = true;
              focus = i;
              widget.callBack(focus);
            },
          );
        }
      }
    }
  }

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    widget.textItemList[0].isFocus = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.textItemList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: widget.textItemList[index].buildItem,
            onTap: () => focusOn(index),
          );
        },
      ),
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          double stopPosition = notification.metrics.pixels;
          double currentPosition = 0.0;
          double nextPosition = 0.0;
          for (int i = 0; i < widget.textItemList.length; i++) {
            currentPosition = nextPosition;
            nextPosition = currentPosition +
                widget.textItemList[i].getSize(context).width +
                20;
            if (stopPosition >= currentPosition &&
                stopPosition < nextPosition) {
              double range = (nextPosition - currentPosition);
              double center = range / 2 + currentPosition - 10;
              double downLine = center - range * 0.6;
              double upLine = center + range * 0.6;
              if (stopPosition < downLine) {
                _animateScroll(currentPosition -
                    widget.textItemList[i].getSize(context).width +
                    20);
              } else if (stopPosition > upLine) {
                _animateScroll(nextPosition);
              } else {
                _animateScroll(currentPosition);
              }
              break;
            }
          }
        }
        return true;
      },
    );
  }

  void focusOn(int index) {
    double location = 0.0;
    for (int i = 0; i < index; i++) {
      location += widget.textItemList[i].getSize(context).width + 20;
    }
    _animateScroll(location);
  }

  void _animateScroll(double location) {
    Future.delayed(Duration.zero, () {
      scrollController.animateTo(
        location,
        duration: new Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }
}
