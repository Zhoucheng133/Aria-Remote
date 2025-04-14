import 'package:aria_remote/variables/get_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  final GetSettings settings=Get.put(GetSettings());

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    settings.autoDarkController(brightness == Brightness.dark);

    return Obx(()=>
      GetMaterialApp(
        theme: settings.darkMode.value ? ThemeData.dark().copyWith(
          // 设置暗色模式的字体默认颜色
          textTheme: GoogleFonts.notoSansScTextTheme().apply(
              bodyColor: Colors.white,
              displayColor: Colors.white, 
          ),
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.dark,
          )
        ) : ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            textTheme: GoogleFonts.notoSansScTextTheme(),
        ),
      )
    );
  }
}
