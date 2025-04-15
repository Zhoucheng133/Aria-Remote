import 'package:aria_remote/home.dart';
import 'package:aria_remote/utils/get_functions.dart';
import 'package:aria_remote/utils/get_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  Get.put(GetSettings());
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

    return Obx(()=>
      GetMaterialApp(
        theme: settings.darkMode.value ? ThemeData.dark().copyWith(
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
        home: const Home(),
      )
    );
  }
}
