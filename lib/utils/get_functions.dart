import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:aria_remote/utils/get_pages.dart';
import 'package:aria_remote/utils/get_settings.dart';
import 'package:aria_remote/utils/main_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetFunctions extends GetxController{
  late SharedPreferences prefs;
  final GetPages pages=Get.find();
  final GetSettings settings=Get.find();
  final MainService mainService=Get.find();

  // PRC对话框
  Future<void> rpcDialog(BuildContext context) async {
    final rlt=await showTextInputDialog(
      title: '配置Aria RPC',
      context: context, 
      textFields: [
        const DialogTextField(
          hintText: 'RPC地址'
        ),
        const DialogTextField(
          hintText: 'RPC密钥'
        ),
      ],
      okLabel: '完成',
      cancelLabel: '取消',
    );
    if(rlt!=null && (rlt[0].isEmpty || !rlt[0].startsWith('http'))){
      if(context.mounted){
        showOkAlertDialog(
          context: context,
          title: '无法完成RPC配置',
          message: 'RPC地址为空或不合法',
          okLabel: '好的',
        );
      }
      return;
    }else if(rlt!=null && rlt[1].isEmpty){
      if(context.mounted){
        showOkAlertDialog(
          context: context,
          title: '无法完成RPC配置',
          message: '密钥不能为空',
          okLabel: '好的',
        );
      }
      return;
    }
    if(rlt!=null){
      settings.rpc.value=rlt[0];
      settings.secret.value=rlt[1];
      if(context.mounted){
        mainService.startServive(context);
      }
      prefs.setString('rpc', settings.rpc.value);
      prefs.setString('secret', settings.secret.value);
    }
  }

  // 初始化
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
          pages.page.value=Pages.settings;
        }
      }
      return;
    }else{
      settings.rpc.value=rpc;
      settings.secret.value=secret;
      if(context.mounted){
        mainService.startServive(context);
      }
    }
  }
}