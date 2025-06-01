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
  
  // 允许覆盖
  RxBool overWrite=false.obs;
  // 下载位置
  RxString downloadPath=''.obs;
  // 最大同时下载数量
  RxInt downloadCount=10.obs;
  // 做种时间
  RxInt seedTime=0.obs;
  // 做种比例
  RxDouble seedRatio=0.0.obs;
  // 下载速度限制
  RxInt downloadLimit=0.obs;
  // 上传速度限制
  RxInt uploadLimit=0.obs;
  // 用户代理
  RxString userAgent=''.obs;
}