import 'package:adaptive_dialog/adaptive_dialog.dart';
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
      if(context.mounted){
        final rlt=await showOkCancelAlertDialog(
          context: context,
          title: '没有配置RPC',
          message: '是否前往设置进行配置?',
          okLabel: '好的',
          cancelLabel: '取消'
        );
        if(rlt==OkCancelResult.ok){
          print("!");
        }
      }
      return;
    }
  }
}