import 'dart:async';
import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:aria_remote/utils/get_pages.dart';
import 'package:aria_remote/utils/get_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MainService extends GetxController{

  final GetPages pages=Get.find();
  final GetSettings settings=Get.find();

  late Timer interval;

  // 网络请求
  Future<Map> httpRequest(Map data) async {
    if(settings.rpc.value.isEmpty || settings.secret.value.isEmpty){
      return {};
    }
    final url = Uri.parse(settings.rpc.value);
    final body = json.encode(data);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      return {};
    }
  }

  // 请求版本
  Future<String?> getVersion() async {
    try {
      return (await httpRequest({
        "jsonrpc":"2.0",
        "method":"aria2.getVersion",
        "id":"ariaui",
        "params":["token:${settings.secret.value}"]
      }))['result']['version'];
    } catch (_) {
      return null;
    }
  }
  
  // TODO 请求活跃的任务
  void tellActive(){
    
  }

  // TODO 请求停止的任务
  void tellStopped(){

  }

  void serviceMain(){
    if(pages.page.value==Pages.active){
      tellActive();
    }else if(pages.page.value==Pages.finished){
      tellStopped();
    }
  }

  void destoryServive(){
    try {
      interval.cancel();
    } catch (_) {}
  }

  Future<void> startServive(BuildContext context) async {
    destoryServive();
    if(await getVersion()!=null){
      interval= Timer.periodic(const Duration(seconds: 1), (Timer time){
        serviceMain();
      });
    }else{
      if(context.mounted){
        showOkAlertDialog(
          context: context,
          title: '运行服务失败',
          message: '网络请求有误，请检查RPC配置和网络链接',
          okLabel: '好的'
        );
      }
    }
  }

}