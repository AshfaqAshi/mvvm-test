
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Helper{

  static void navigate(BuildContext context,String routeName,{bool pushReplace=false}){
    if(pushReplace){
      Navigator.pushReplacementNamed(context, routeName);
    }else{
      Navigator.of(context).pushNamed(routeName);
    }
  }

  static void showSnackBar(BuildContext context, String text,{String? actionText, VoidCallback? onAction,
    bool error=false}){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: error?Color(0xff9E1515):null,
      content: Text(text,style: error?Theme.of(context).textTheme.bodyText2
      !.copyWith(color: Colors.white):null,),
      action: actionText!=null?SnackBarAction(label: actionText, onPressed: onAction! ):null,
    ));
  }

  static String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }
}