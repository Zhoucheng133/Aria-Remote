import 'package:aria_remote/components/task_item.dart';
import 'package:aria_remote/utils/get_settings.dart';
import 'package:aria_remote/utils/get_tasks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path/path.dart' as p;

class Finished extends StatefulWidget {
  const Finished({super.key});

  @override
  State<Finished> createState() => _FinishedState();
}

class _FinishedState extends State<Finished> {

  final GetSettings settings=Get.find();
  final GetTasks tasks=Get.find();

  List selectList=[];
  bool select=false;

  void changeSelectStatus(String gid){
    if(selectList.contains(gid)){
      setState(() {
        selectList.remove(gid);
      });
    }else{
      setState(() {
        selectList.add(gid);
      });
    }
  }

  void selectMode(){
    setState(() {
      selectList=[];
      select=!select;
    });
  }

  bool checked(String gid){
    return selectList.contains(gid);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      tasks.stoppedInit.value ? Center(
        child: LoadingAnimationWidget.waveDots(
          color: Colors.black, 
          size: 30
        )
      ) : ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: tasks.stopped.length,
        itemBuilder: (BuildContext context, int index){
          String name='';
          String dir='';
          int completedLength=0;
          int totalLength=0;
          int downloadSpeed=0;
          String gid='';
          String status='';
          int uploadSpeed=0;
          dir=tasks.stopped[index]['dir'];
          completedLength=int.parse(tasks.stopped[index]['completedLength']);
          totalLength=int.parse(tasks.stopped[index]['totalLength']);
          downloadSpeed=int.parse(tasks.stopped[index]['downloadSpeed']);
          gid=tasks.stopped[index]['gid'];
          status=tasks.stopped[index]['status'];
          uploadSpeed=int.parse(tasks.stopped[index]['uploadSpeed']);
          try {
            name=tasks.stopped[index]['bittorrent']['info']['name'];
          } catch (_) {
            name=p.basename(tasks.stopped[index]['files'][0]['path']);
          }
          return TaskItem(
            name: name, 
            totalLength: totalLength, 
            completedLength: completedLength, 
            dir: dir, 
            downloadSpeed: downloadSpeed, 
            gid: gid, 
            status: status, 
            selectMode: select, 
            changeSelectStatus: ()=>changeSelectStatus(gid), 
            checked: checked(gid), 
            active: false, 
            index: index,
            uploadSpeed: uploadSpeed,
          );
        }
      )
    );
  }
}