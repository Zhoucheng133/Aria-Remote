import 'package:get/get.dart';

class GetSettings extends GetxController{
  RxBool darkMode=false.obs;
  RxBool autoDark=true.obs;
  void autoDarkController(bool dark){
    if(autoDark.value){
      darkMode.value=dark;
    }
  }

  RxString rpc="".obs;
  RxString secret="".obs;

  bool isLogin(){
    return rpc.value.isNotEmpty && secret.value.isNotEmpty;
  }
  
}