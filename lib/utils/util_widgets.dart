import 'package:flutter/material.dart';
class UtilWidgets{
  static void showSnackBar(BuildContext context,String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}