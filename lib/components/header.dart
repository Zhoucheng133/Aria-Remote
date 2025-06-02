import 'package:aria_remote/utils/get_dialogs.dart';
import 'package:aria_remote/utils/get_main_service.dart';
import 'package:aria_remote/utils/get_pages.dart';
import 'package:aria_remote/utils/get_settings.dart';
import 'package:aria_remote/utils/get_tasks.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppHeader extends StatefulWidget {
  const AppHeader({super.key});

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  @override
  Widget build(BuildContext context) {

    final GetPages pages=Get.find();
    final GetMainService mainService=Get.find();
    final GetTasks tasks=Get.find();
    final GetDialogs d=Get.find();
    final GetSettings s=Get.find();

    Future<void> reDownloadTask() async {
      for (var item in tasks.selected) {
        try {
          final el=tasks.stopped.firstWhere((element){
            return element['gid'] == item;
          });
          final uris=el['files'][0]['uris'];
          final infoHash=el['infoHash'];
          await mainService.addTask(uris.length==0 ? 'magnet:?xt=urn:btih:$infoHash' : uris[0]['uri']);
        } catch (_) {}
      }
      await mainService.removeSelectedFinishedTasks();
    }

    return Obx(()=>
      FHeader(
        title: Padding(
          padding: const EdgeInsets.only(left: 5, top: 5),
          child: Text(
            pages.nameController(),
            style: GoogleFonts.notoSansSc(),
          )
        ),
        actions: [
          if(pages.page.value==Pages.active && tasks.selectMode.value) Padding(
            padding: const EdgeInsets.only(right: 15),
            child: FHeaderAction(
              icon: FIcon(
                FAssets.icons.play,
                size: 20,
              ), 
              onPress: () async {
                await mainService.continueSelected();
                tasks.toggleSelectMode();
              }
            ),
          ),
          if(pages.page.value==Pages.active && tasks.selectMode.value) Padding(
            padding: const EdgeInsets.only(right: 15),
            child: FHeaderAction(
              icon: FIcon(
                FAssets.icons.pause,
                size: 20,
              ), 
              onPress: () async {
                await mainService.pauseSelected();
                tasks.toggleSelectMode();
              }
            ),
          ),
          if(pages.page.value==Pages.finished && tasks.selectMode.value) Padding(
            padding: const EdgeInsets.only(right: 15),
            child: FHeaderAction(
              icon: FIcon(
                FAssets.icons.rotateCw,
                size: 20,
              ), 
              onPress: () async {
                await reDownloadTask();
                tasks.toggleSelectMode();
              }
            ),
          ),
          if(pages.page.value!=Pages.settings && !tasks.selectMode.value) Padding(
            padding: const EdgeInsets.only(right: 15),
            child: FHeaderAction(
              icon: FIcon(
                FAssets.icons.arrowDownUp,
                size: 20,
              ),
              onPress: (){
                if(pages.page.value==Pages.active){
                  if(pages.activeOrder.value==Order.oldTime){
                    pages.activeOrder.value=Order.newTime;
                  }else{
                    pages.activeOrder.value=Order.oldTime;
                  }
                  mainService.tellActive();
                }else{
                  if(pages.finishedOrder.value==Order.oldTime){
                    pages.finishedOrder.value=Order.newTime;
                  }else{
                    pages.finishedOrder.value=Order.oldTime;
                  }
                  mainService.tellStopped();
                }
              }
            ),
          ),
          if(pages.page.value==Pages.finished || tasks.selectMode.value) Padding(
            padding: const EdgeInsets.only(right: 15),
            child: FHeaderAction(
              icon: FIcon(
                tasks.selectMode.value ? FAssets.icons.trash : FAssets.icons.trash2,
                size: 20,
              ),
              onPress: () async {
                if(tasks.selectMode.value){
                  final data=await d.showOkCancelDialog(
                    context: context, 
                    title: '清空选中的任务', 
                    content: '这个操作无法撤销，确定要继续吗?',
                    okText: '删除'
                  );
                  if(data){
                    if(pages.page.value==Pages.finished){
                      await mainService.removeSelectedFinishedTasks();
                    }else{
                      await mainService.removeSelectedActiveTasks();
                    }
                    tasks.toggleSelectMode();
                  }
                }else{
                  final data=await d.showOkCancelDialog(
                    context: context, 
                    title: '清空所有已完成的任务', 
                    content: '这个操作无法撤销，确定要继续吗?',
                    okText: '删除'
                  );
                  if(data){
                    mainService.clearFinished();
                  }
                }
              }
            ),
          ),
          if(pages.page.value!=Pages.settings) Padding(
            padding: const EdgeInsets.only(right: 15),
            child: FHeaderAction(
              icon: Obx(()=>
                FIcon(
                  FAssets.icons.squareCheckBig,
                  size: 20,
                  color: tasks.selectMode.value ? Colors.grey[400] : s.darkMode.value ? Colors.white : Colors.black,
                ),
              ),
              onPress: ()=>tasks.toggleSelectMode(),
            ),
          )
        ],
      ),
    );
  }
}