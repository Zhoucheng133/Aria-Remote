import 'package:get/get.dart';

enum Pages{
  active,
  finished,
  settings,
}

enum Order{
  newTime,
  oldTime,
  titleA,
  titleZ,
}

class GetPages extends GetxController{
  Rx<Pages> page=Rx(Pages.active);
  var activeOrder=Order.oldTime.obs;
  var finishedOrder=Order.oldTime.obs;

  String nameController(){
    if(page.value==Pages.active){
      return "活跃中";
    }else if(page.value==Pages.finished){
      return '已完成';
    }
    return '设置';
  }
}