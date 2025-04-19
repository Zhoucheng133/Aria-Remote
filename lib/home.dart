import 'package:aria_remote/pages/active.dart';
import 'package:aria_remote/pages/finished.dart';
import 'package:aria_remote/pages/settings.dart';
import 'package:aria_remote/utils/get_functions.dart';
import 'package:aria_remote/utils/get_main_service.dart';
import 'package:aria_remote/utils/get_pages.dart';
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
        contentPad: false,
        header: FHeader(
          title: Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Text(
              pages.nameController(),
              style: GoogleFonts.notoSansSc(),
            )
          ),
          actions: [
            pages.page.value==Pages.settings ? Container() : FHeaderAction(
              icon: FIcon(
                FAssets.icons.arrowDownUp,
                size: 20,
              ),
              onPress: (){
                if(pages.page.value==Pages.active){
                  if(pages.activeOrder.value==Order.oldTime){
                    pages.activeOrder.value=Order.newTime;
                  }else{
                    pages.activeOrder.value=Order.oldTime;
                  }
                  mainService.tellActive();
                }else{
                  if(pages.finishedOrder.value==Order.oldTime){
                    pages.finishedOrder.value=Order.newTime;
                  }else{
                    pages.finishedOrder.value=Order.oldTime;
                  }
                  mainService.tellStopped();
                }
              }
            ),
            pages.page.value==Pages.finished ? const SizedBox(width: 10,) : Container(),
            pages.page.value==Pages.finished ? FHeaderAction(
              icon: FIcon(
                FAssets.icons.trash,
                size: 20,
              ),
              onPress: (){
                showAdaptiveDialog(
                  context: context, 
                  builder: (context)=>FDialog(
                    direction: Axis.horizontal,
                    title: const Text('清空所有已完成的任务'),
                    body: const Text('这个操作无法撤销，确定要继续吗?'),
                    actions: [
                      FButton(
                        style: FButtonStyle.outline,
                        onPress: ()=>Navigator.pop(context), 
                        label: const Text('取消')
                      ),
                      FButton(
                        onPress: (){
                          mainService.clearFinished();
                          Navigator.pop(context);
                        }, 
                        label: const Text('删除')
                      )
                    ]
                  )
                );
              }
            ) : Container()
          ],
        ),
        footer: FBottomNavigationBar(
          index: pages.page.value.index,
          children: [
            FBottomNavigationBarItem(
              icon: FIcon(FAssets.icons.download),
              label: Text('活跃中', style: GoogleFonts.notoSansSc(),),
            ),
            FBottomNavigationBarItem(
              icon: FIcon(FAssets.icons.listCheck),
              label: Text('已完成', style: GoogleFonts.notoSansSc(),),
            ),
            FBottomNavigationBarItem(
              icon: FIcon(FAssets.icons.settings),
              label: Text('设置', style: GoogleFonts.notoSansSc(),),
            ),
          ],
          onChange: (index){
            pages.page.value=Pages.values[index];
          },
        ),
        content: IndexedStack(
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