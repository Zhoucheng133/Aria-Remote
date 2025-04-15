import 'package:get/get.dart';

class GetSettings extends GetxController{
  RxBool darkMode=false.obs;
  RxBool autoDark=true.obs;
  void autoDarkController(bool dark){
    if(autoDark.value){
      darkMode.value=dark;
    }
  }

  Rx<String?> rpc=null.obs;
  Rx<String?> secret=null.obs;

  bool isLogin(){
    return rpc.value!=null && secret.value!=null;
  }
  
}