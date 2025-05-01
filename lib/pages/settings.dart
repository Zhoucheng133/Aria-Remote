import 'package:aria_remote/pages/about.dart';
import 'package:aria_remote/utils/get_dialogs.dart';
import 'package:aria_remote/utils/get_functions.dart';
import 'package:aria_remote/utils/get_settings.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final GetSettings settings=Get.find();
  final GetFunctions functions=Get.find();
  final GetDialogs dialogs=Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20, top: 0, left: 0, right: 0),
          children: [
            FTileGroup(
              label: Text('Aria 配置', style: GoogleFonts.notoSansSc(),),
              children: [
                FTile(
                  title: Text('RPC 配置', style: GoogleFonts.notoSansSc(),),
                  subtitle: Text(
                    settings.rpc.value.isEmpty?'没有设置':settings.rpc.value,
                    style: GoogleFonts.notoSansSc(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPress: ()=>functions.rpcDialog(context)
                ),
              ]
            ),
            FTileGroup(
              label: Text('应用设置', style: GoogleFonts.notoSansSc(),),
              children: [
                FTile(
                  title: Text('暗色模式', style: GoogleFonts.notoSansSc(),),
                  subtitle: Text(settings.autoDark.value ? '自动' : settings.darkMode.value ? '开启' : '关闭'),
                  onPress: (){
                    dialogs.showOkDialogRaw(
                      context: context, 
                      title: '深色模式', 
                      child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Obx(()=>
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Text('跟随系统', style: GoogleFonts.notoSansSc(
                                      fontSize: 15
                                    ),)),
                                    Transform.scale(
                                      scale: 0.8,
                                      child: FSwitch(
                                        value: settings.autoDark.value,
                                        onChange: (val){
                                          settings.autoDark.value=val;
                                          final Brightness brightness = MediaQuery.of(context).platformBrightness;
                                          settings.autoDarkController(brightness == Brightness.dark);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Text('启用深色模式', style: GoogleFonts.notoSansSc(
                                      fontSize: 15
                                    ),)),
                                    Transform.scale(
                                      scale: 0.8,
                                      child: FSwitch(
                                        value: settings.darkMode.value,
                                        onChange: settings.autoDark.value ? null : (val){
                                          settings.darkMode.value=val;
                                        },
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                      ),
                      okText: '完成'
                    );
                  },
                ),
                FTile(
                  title: Text('关于Aria Remote', style: GoogleFonts.notoSansSc(),),
                  subtitle: Text(settings.version.value, style: GoogleFonts.notoSansSc(),),
                  onPress: ()=>Get.to(()=>const About()),
                )
              ]
            )
          ],
        ),
      ),
    );
  }
}