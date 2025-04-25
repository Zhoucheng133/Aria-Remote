import 'package:get/get.dart';

class GetTasks extends GetxController{
  RxBool activeInit=true.obs;
  RxBool stoppedInit=true.obs;

  RxList active=[].obs;
  RxList stopped=[].obs;
}