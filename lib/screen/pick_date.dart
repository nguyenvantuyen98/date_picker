import 'package:flutter/material.dart';

import 'components/go_arrow_button.dart';
class PickDate extends StatefulWidget {
  final String title;

  const PickDate({Key key, this.title}) : super(key: key);
  @override
  _PickDateState createState() => _PickDateState();
}

class _PickDateState extends State<PickDate> {
  List<String> list=["Today","Tomorrow","Thus1","Fri2","Sat3","Sun4"];
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30
                  ),),
                  // AnimatedList(
                  //   itemBuilder: (context,item,animation){
                  //
                  //   },
                  // ),
                  Container(
                    height: 50,
                    child: NotificationListener(
                      onNotification: (value){
                        //print(value);
                      },
                      child: ListView.builder(
                          itemCount: list.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,index)=>TextItem(text:list[index])
                      ),
                    ),
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
