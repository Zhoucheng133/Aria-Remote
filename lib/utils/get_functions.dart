import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetFunctions extends GetxController{
  late SharedPreferences prefs;

  void initPrefs(BuildContext context) async {
    prefs=await SharedPreferences.getInstance();
    String? rpc=prefs.getString('rpc');
    String? secret=prefs.getString('secret');
    if(rpc==null || secret==null){
      
      return;
    }
  }
}