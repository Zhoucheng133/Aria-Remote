import 'package:aria_remote/utils/get_dialogs.dart';
import 'package:aria_remote/utils/get_pages.dart';
import 'package:aria_remote/utils/get_settings.dart';
import 'package:aria_remote/utils/get_main_service.dart';
import 'package:aria_remote/utils/get_tasks.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetFunctions extends GetxController{
  late SharedPreferences prefs;

  final GetPages pages=Get.find();
  final GetSettings settings=Get.find();
  final GetDialogs d=Get.find();
  final GetTasks t=Get.find();

  final GetMainService mainService=Get.find();

  Future<void> rpcOkHandler(BuildContext context, String rpc, String secret) async {
    if((rpc.isEmpty || !rpc.startsWith('http'))&& context.mounted){
      await d.showOkDialog(
        context: context, 
        title: '无法完成RPC配置', 
        content: 'RPC地址为空或不合法',
        okText: '好的'
      );
      return;
    }else if(secret.isEmpty && context.mounted){
      await d.showOkDialog(
        context: context, 
        title: '无法完成RPC配置', 
        content: '密钥不能为空',
        okText: '好的'
      );
      return;
    }

    settings.rpc.value=rpc;
    settings.secret.value=secret;
    if(context.mounted){
      mainService.startServive(context);
    }
    prefs.setString('rpc', settings.rpc.value);
    prefs.setString('secret', settings.secret.value);
  }

  // PRC对话框
  Future<void> rpcDialog(BuildContext context) async {

    final rpcController=TextEditingController();
    final secretController=TextEditingController();

    d.showOkCancelDialogRaw(
      context: context, 
      title: "配置Aria RPC", 
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState)=>Column(
          children: [
            const SizedBox(height: 5,),
            FTextField(
              autocorrect: false,
              enableSuggestions: false,
              controller: rpcController,
              maxLines: 1,
              hint: 'RPC地址',
            ),
            const SizedBox(height: 10,),
            FTextField.password(
              label: null,
              autocorrect: false,
              enableSuggestions: false,
              controller: secretController,
              hint: 'RPC密钥',
            ),
          ],
        ),
      ), 
      okText: '完成',
      okHandler: ()=>rpcOkHandler(context, rpcController.text, secretController.text),
    );
  }

  // 初始化
  void initPrefs(BuildContext context) async {
    prefs=await SharedPreferences.getInstance();
    String? rpc=prefs.getString('rpc');
    String? secret=prefs.getString('secret');
    if(rpc==null || secret==null){
      t.activeInit.value=false;
      t.stoppedInit.value=false;
      if(context.mounted){
        final set=await d.showOkCancelDialog(
          context: context, 
          title: '没有配置RPC', 
          content: '是否前往设置进行配置',
          okText: '好的'
        );
        if(set){
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