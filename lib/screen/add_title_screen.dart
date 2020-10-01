import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'components/alert_dialog.dart';
import 'components/go_arrow_button.dart';
class AddTitle extends StatefulWidget {
  @override
  _AddTitleState createState() => _AddTitleState();
}

class _AddTitleState extends State<AddTitle> {
  var now=DateTime.now();
  bool isVisibleGoButton=false;
  double _currentGreetingOpacity=1;
  TextEditingController textEditingController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.close, color: Colors.grey.withOpacity(.6),),
              onPressed: (){
                showAlert(context:context);
              },
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 40, bottom: 40),
          child: Stack(
            //fit: StackFit.expand,
            children: [
              Center(
                child: Container(
                  //color: Colors.red,
                  width: double.infinity,
                  //height: 200,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.decelerate,
                          opacity: _currentGreetingOpacity,
                          child: Text("Hey,\nCuong", style: TextStyle(
                              color: Colors.white,
                              fontSize: 30, fontWeight: FontWeight.bold
                          ),),
                        ),
                        TextField(
                          onTap: (){
                            setState(() {
                              _currentGreetingOpacity = 0;
                            });
                          },
                          onChanged: (value){
                            setState(() {
                              if(value.length>0){
                                isVisibleGoButton=true;
                              }else{
                                isVisibleGoButton=false;
                              }
                            });
                          },
                          controller: textEditingController,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30
                          ),
                          decoration: InputDecoration(
                            hintText: "Input here",
                            hintStyle: TextStyle(color: Color(0xFF232323),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              isVisibleGoButton ? Align(
                alignment: Alignment.bottomCenter,
                child: GoArrowButton(press: (){
                  if(textEditingController.text!="") {
                    Navigator.pushNamed(
                        context, "/pickdate/${textEditingController.text}");
                  }
                },),
              ): SizedBox()
            ],
          ),
        )
    );
  }
}


