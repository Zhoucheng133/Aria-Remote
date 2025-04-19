import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class GetSettings extends GetxController{

  initVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value="v${packageInfo.version}";
  }

  GetSettings(){
    initVersion();
  }

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

  RxString version="".obs;
  
}