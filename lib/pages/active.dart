import 'package:aria_remote/components/active_item.dart';
import 'package:aria_remote/utils/get_settings.dart';
import 'package:aria_remote/utils/get_tasks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

class Active extends StatefulWidget {
  const Active({super.key});

  @override
  State<Active> createState() => _ActiveState();
}

class _ActiveState extends State<Active> {

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
    return Stack(
      children: [
        Positioned(
          right: 20,
          bottom: 20,
          child: Obx(()=>
            FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: Colors.teal,
              onPressed: settings.isLogin() ? (){
            
              } : null,
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
              ),
            ),
          )
        ),
        Obx(()=>
          ListView.builder(
            itemCount: tasks.active.length,
            itemBuilder: (BuildContext context, int index){
              String name='';
              String dir='';
              int completedLength=0;
              int totalLength=0;
              int downloadSpeed=0;
              String gid='';
              String status='';
              int uploadSpeed=0;
              dir=tasks.active[index]['dir'];
              completedLength=int.parse(tasks.active[index]['completedLength']);
              totalLength=int.parse(tasks.active[index]['totalLength']);
              downloadSpeed=int.parse(tasks.active[index]['downloadSpeed']);
              gid=tasks.active[index]['gid'];
              status=tasks.active[index]['status'];
              uploadSpeed=int.parse(tasks.active[index]['uploadSpeed']);
              try {
                name=tasks.active[index]['bittorrent']['info']['name'];
              } catch (_) {
                name=p.basename(tasks.active[index]['files'][0]['path']);
              }
              return ActiveItem(
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
                active: true, 
                index: index,
                uploadSpeed: uploadSpeed,
              );
            }
          )
        )
      ],
    );
  }
}