import 'package:get/get.dart';

class GetTasks extends GetxController{
  RxBool activeInit=true.obs;
  RxBool stoppedInit=true.obs;

  RxList active=[].obs;
  RxList stopped=[].obs;

  // 是否在选择模式
  RxBool selectMode=false.obs;

  // 选择的任务
  RxList selected=[].obs;

  bool isSelected(String gid){
    if(selected.contains(gid)){
      return true;
    }else{
      return false;
    }
  }

  void toggleSelected(String gid){
    if(!selectMode.value) return;
    if(selected.contains(gid)){
      selected.remove(gid);
    }else{
      selected.add(gid);
    }
    selected.refresh();
  }

  void toggleSelectMode(){
    selectMode.value=!selectMode.value;
    selected.value=[];
  }
}