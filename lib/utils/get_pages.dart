import 'package:get/get.dart';

enum Pages{
  active,
  finished,
  settings,
}

class GetPages extends GetxController{
  Rx<Pages> page=Rx(Pages.active);

  String nameController(){
    if(page.value==Pages.active){
      return "活跃中";
    }else if(page.value==Pages.finished){
      return '已完成';
    }
    return '设置';
  }
}