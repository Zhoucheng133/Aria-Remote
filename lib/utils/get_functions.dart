import 'package:aria_remote/utils/get_pages.dart';
import 'package:aria_remote/utils/get_settings.dart';
import 'package:aria_remote/utils/get_main_service.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetFunctions extends GetxController{
  late SharedPreferences prefs;

  final GetPages pages=Get.find();
  final GetSettings settings=Get.find();

  final GetMainService mainService=Get.find();

  Future<void> rpcOkHandler(BuildContext context, String rpc, String secret) async {
    if((rpc.isEmpty || !rpc.startsWith('http'))&& context.mounted){
      await showAdaptiveDialog(
        context: context, 
        builder: (context)=>FDialog(
          direction: Axis.horizontal,
          title: const Text('无法完成RPC配置'),
          body: const Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Text('RPC地址为空或不合法'),
          ),
          actions: [
            FButton(
              onPress: ()=>Navigator.pop(context), 
              label: const Text('好的')
            )
          ]
        )
      );
      return;
    }else if(secret.isEmpty && context.mounted){
      await showAdaptiveDialog(
        context: context, 
        builder: (context)=>FDialog(
          direction: Axis.horizontal,
          title: const Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Text('无法完成RPC配置'),
          ),
          body: const Text('密钥不能为空'),
          actions: [
            FButton(
              onPress: ()=>Navigator.pop(context), 
              label: const Text('好的')
            )
          ]
        )
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

    await showAdaptiveDialog(
      context: context, 
      builder: (context)=>FDialog(
        direction: Axis.horizontal,
        title: const Text('配置Aria RPC'),
        body: StatefulBuilder(
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
        actions: [
          FButton(
            onPress: ()=>Navigator.pop(context), 
            style: FButtonStyle.outline,
            label: const Text('取消')
          ),
          FButton(
            onPress: (){
              Navigator.pop(context);
              rpcOkHandler(context, rpcController.text, secretController.text);
            }, 
            label: const Text('完成')
          )
        ]
      )
    );
  }

  // 初始化
  void initPrefs(BuildContext context) async {
    prefs=await SharedPreferences.getInstance();
    String? rpc=prefs.getString('rpc');
    String? secret=prefs.getString('secret');
    if(rpc==null || secret==null){
      if(context.mounted){
        showAdaptiveDialog(
          context: context,
          builder: (context)=>FDialog(
            direction: Axis.horizontal,
            title: const Text('没有配置RPC'),
            body: const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Text('是否前往设置进行配置'),
            ),
            actions: [
              FButton(
                style: FButtonStyle.outline,
                label: const Text('取消'), 
                onPress: () => Navigator.of(context).pop()
              ),
              FButton(
                label: const Text('好的'), 
                onPress: (){
                  pages.page.value=Pages.settings;
                  Navigator.of(context).pop();
                }
              ),
            ],
          )
        );
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