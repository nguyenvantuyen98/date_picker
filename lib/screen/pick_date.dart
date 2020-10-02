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
  Time time=Time();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  bool isVisibleHourList=false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey.withOpacity(.6),),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey.withOpacity(.6),),
            onPressed: (){},
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left:40),
        child: Column(
          children: [
            Expanded(
              child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 40
                  ),),
                  // AnimatedList(
                  //   itemBuilder: (context,item,animation){
                  //
                  //   },
                  // ),
                  Container(
                    //color: Colors.white,
                    height: 50,
                    child: CustomScroll(inputText: time.getDayList(), callBack: (index) {
                      print(index);
                      if(index!=null && index!=0){
                        setState(() {
                          isVisibleHourList=true;
                        });
                      }else{
                        setState(() {
                          isVisibleHourList=false;
                        });
                      }
                    })
                  ),
                  // Container(
                  //   //color: Colors.white,
                  //     height: 50,
                  //     child: CustomScroll(inputText: time.getMonthList(), callBack: (index) => (print(index)),)
                  // ),
                  isVisibleHourList ? Container(
                    //color: Colors.white,
                      height: 50,
                      child: CustomScroll(inputText: time.getHourList(), callBack: (index) => (print(index)),)
                  ):SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset("assets/icons/btn_plus.svg"),
                        onPressed: (){

                        },
                      ),
                      Text("UNTIL", style: TextStyle(color: Colors.white),)
                    ],
                  )
                ]
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*.2,
              child: Center(
                child: GoArrowButton(press: (){
                },),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TextItem extends StatelessWidget {
  const TextItem({
    Key key, this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: Text(text, style:
      TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold
      ),),
    );
  }
}
