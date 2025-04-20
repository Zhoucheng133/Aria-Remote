import 'package:aria_remote/home.dart';
import 'package:aria_remote/utils/get_dialogs.dart';
import 'package:aria_remote/utils/get_functions.dart';
import 'package:aria_remote/utils/get_pages.dart';
import 'package:aria_remote/utils/get_settings.dart';
import 'package:aria_remote/utils/get_main_service.dart';
import 'package:aria_remote/utils/get_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';

void main() {
  Get.put(GetTasks());
  Get.put(GetPages());
  Get.put(GetSettings());
  Get.put(GetDialogs());
  Get.put(GetMainService());
  Get.put(GetFunctions());
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  final GetSettings settings=Get.find();


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    settings.autoDarkController(brightness == Brightness.dark);

    return 
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) => Obx(()=>
          FTheme(
            data: settings.darkMode.value ? FThemes.zinc.dark : FThemes.zinc.light,
            child: child!,
          )
        ),
        home: const Home(),
      // )
    );
  }
}
