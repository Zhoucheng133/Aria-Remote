import 'package:get/get.dart';

enum Pages{
  active,
  finished,
  settings,
}

class GetPages extends GetxController{
  Rx<Pages> page=Rx(Pages.active);
}