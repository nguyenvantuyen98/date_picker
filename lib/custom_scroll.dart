import 'package:date_picker/text_item.dart';
import 'package:flutter/material.dart';

typedef void IndexCallBack(int index);

class CustomScroll extends StatefulWidget {
  final IndexCallBack callBack;
  final List<String> inputText;
  final List<TextItem> textItemList = [];
  CustomScroll({this.inputText, this.callBack}) {
    print('restart');
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
    int index = getIndex(scrollController.position.pixels);
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
        itemCount: widget.textItemList.length + 1,
        itemBuilder: (context, index) {
          return index < widget.textItemList.length
              ? GestureDetector(
                  child: widget.textItemList[index].buildItem,
                  onTap: () => focusOn(index),
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

  void lightUp(int index) {
    setState(() {
      widget.textItemList[index].isFocus = true;
      widget.textItemList[focus].isFocus = false;
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
