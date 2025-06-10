import 'package:aria_remote/components/header.dart';
import 'package:aria_remote/pages/active.dart';
import 'package:aria_remote/pages/finished.dart';
import 'package:aria_remote/pages/settings.dart';
import 'package:aria_remote/utils/get_dialogs.dart';
import 'package:aria_remote/utils/get_functions.dart';
import 'package:aria_remote/utils/get_main_service.dart';
import 'package:aria_remote/utils/get_pages.dart';
import 'package:aria_remote/utils/get_settings.dart';
import 'package:aria_remote/utils/get_tasks.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  final GetFunctions functions=Get.find();
  final GetPages pages=Get.find();
  final GetMainService mainService=Get.find();
  final GetDialogs d=Get.find();
  final GetTasks tasks=Get.find();
  final GetSettings settings=Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      functions.initPrefs(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      FScaffold(
        childPad: false,
        header: const AppHeader(),
        footer: FBottomNavigationBar(
          index: pages.page.value.index,
          children: [
            FBottomNavigationBarItem(
              icon: const Icon(FIcons.download),
              label: Text('活跃中', style: GoogleFonts.notoSansSc(),),
            ),
            FBottomNavigationBarItem(
              icon: const Icon(FIcons.listCheck),
              label: Text('已完成', style: GoogleFonts.notoSansSc(),),
            ),
            FBottomNavigationBarItem(
              icon: const Icon(FIcons.settings),
              label: Text('设置', style: GoogleFonts.notoSansSc(),),
            ),
          ],
          onChange: (index){
            pages.page.value=Pages.values[index];
            if(settings.isLogin()){
              tasks.selectMode.value=false;
              tasks.selected.value=[];
              if(index==0){
                tasks.activeInit.value=true;
              }else if(index==1){
                tasks.stoppedInit.value=true;
              }
            }
          },
        ),
        child: IndexedStack(
          index: pages.page.value.index,
          children: const [
            Active(),
            Finished(),
            Settings(),
          ],
        ),
      )
    );
 
  }
}