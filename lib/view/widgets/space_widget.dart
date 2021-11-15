import 'package:flutter/material.dart';

class HorizontalSpace extends StatelessWidget{
  final double width;
  HorizontalSpace({this.width=15});

  Widget build(BuildContext context){
    return SizedBox(
      width: width,
    );
  }
}

class VerticalSpace extends StatelessWidget{
  final double height;
  VerticalSpace({this.height=15});

  Widget build(BuildContext context){
    return SizedBox(
      height: height,
    );
  }
}