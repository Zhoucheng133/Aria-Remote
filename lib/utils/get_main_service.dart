import 'dart:async';

// import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:aria_remote/utils/get_pages.dart';
import 'package:aria_remote/utils/get_settings.dart';
import 'package:aria_remote/utils/get_tasks.dart';
import 'package:aria_remote/utils/request.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as path;

class GetMainService extends GetxController{

  final GetPages pages=Get.find();
  final GetSettings settings=Get.find();
  final Requests requests=Requests();
  final GetTasks tasks=Get.find();

  late Timer interval;

  // 清空所有已完成的任务
  Future<void> clearFinished() async {
    await Requests().clearFinished();
    serviceMain();
  }

  // 移除任务
  Future<void> remove(String gid) async {
    await Requests().removeTask(gid);
    serviceMain();
  }

  // 移除已完成的任务
  Future<void> removeFinishedTask(String gid) async {
    await Requests().removeFinishedTask(gid);
    serviceMain();
  }

  // 暂停任务
  Future<void> pauseTask(String gid) async {
    await requests.pauseTask(gid);
    serviceMain();
  }

  // 继续任务
  Future<void> continueTask(String gid) async {
    await requests.continueTask(gid);
    serviceMain();
  }
  
  // 请求活跃的任务
  Future<void> tellActive() async {
    List? alists=await requests.tellActive();
    List? wlists=await requests.tellWaiting();
    if(alists!=null && wlists!=null){
      switch (pages.activeOrder.value) {
        case Order.newTime:
          tasks.active.value=(alists..addAll(wlists)).reversed.toList();
          break;
        case Order.oldTime:
          tasks.active.value=alists..addAll(wlists);
          break;
        case Order.titleA:
          List tempList=alists..addAll(wlists);
          tempList.sort((a, b){
            String nameA="";
            String nameB="";
            try {
              nameA=a['bittorrent']['info']['name'];
            } catch (_) {
              nameA=path.basename(a['files'][0]['path']);
            }
            try {
              nameB=b['bittorrent']['info']['name'];
            } catch (_) {
              nameB=path.basename(b['files'][0]['path']);
            }
            return nameA.compareTo(nameB);
          });
          tasks.active.value=tempList;
        case Order.titleZ:
          List tempList=alists..addAll(wlists);
          tempList.sort((a, b){
            String nameA="";
            String nameB="";
            try {
              nameA=a['bittorrent']['info']['name'];
            } catch (_) {
              nameA=path.basename(a['files'][0]['path']);
            }
            try {
              nameB=b['bittorrent']['info']['name'];
            } catch (_) {
              nameB=path.basename(b['files'][0]['path']);
            }
            return nameB.compareTo(nameA);
          });
          tasks.active.value=tempList;
      }
    } 
  }

  // 请求停止的任务
  Future<void> tellStopped() async {
    List? lists=await Requests().tellStopped();
    if(lists!=null){
      switch (pages.finishedOrder.value){
        case Order.newTime:
          tasks.stopped.value=lists.reversed.toList();
          break;
        case Order.oldTime:
          tasks.stopped.value=lists;
          break;
        case Order.titleA:
          lists.sort((a, b){
            String nameA="";
            String nameB="";
            try {
              nameA=a['bittorrent']['info']['name'];
            } catch (_) {
              nameA=path.basename(a['files'][0]['path']);
            }
            try {
              nameB=b['bittorrent']['info']['name'];
            } catch (_) {
              nameB=path.basename(b['files'][0]['path']);
            }
            return nameA.compareTo(nameB);
          });
          tasks.stopped.value=lists;
        case Order.titleZ:
          lists.sort((a, b){
            String nameA="";
            String nameB="";
            try {
              nameA=a['bittorrent']['info']['name'];
            } catch (_) {
              nameA=path.basename(a['files'][0]['path']);
            }
            try {
              nameB=b['bittorrent']['info']['name'];
            } catch (_) {
              nameB=path.basename(b['files'][0]['path']);
            }
            return nameB.compareTo(nameA);
          });
          tasks.stopped.value=lists;
      }
    }
  }

  // 主线程
  void serviceMain(){
    if(pages.page.value==Pages.active){
      tellActive();
    }else if(pages.page.value==Pages.finished){
      tellStopped();
    }
  }

  // 销毁主线程
  void destoryServive(){
    try {
      interval.cancel();
    } catch (_) {}
  }

  // 开始服务
  Future<void> startServive(BuildContext context) async {
    destoryServive();
    if(await requests.getVersion()!=null){
      interval= Timer.periodic(const Duration(seconds: 1), (Timer time){
        serviceMain();
      });
    }else{
      tasks.active.value=[];
      tasks.stopped.value=[];
      if(context.mounted){
        showAdaptiveDialog(
          context: context,
          builder: (context)=>FDialog(
            direction: Axis.horizontal,
            title: Text('运行服务失败', style: GoogleFonts.notoSansSc(),),
            body: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Text('网络请求有误，请检查RPC配置和网络链接', style: GoogleFonts.notoSansSc()),
            ),
            actions: [
              FButton(
                label: Text('好的', style: GoogleFonts.notoSansSc()), 
                onPress: () => Navigator.of(context).pop()
              ),
            ],
          )
        );
      }
    }
  }

}