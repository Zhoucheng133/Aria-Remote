import 'package:aria_remote/pages/about.dart';
import 'package:aria_remote/utils/get_dialogs.dart';
import 'package:aria_remote/utils/get_functions.dart';
import 'package:aria_remote/utils/get_main_service.dart';
import 'package:aria_remote/utils/get_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final GetMainService mainService=Get.find();

  final ScrollController controller=ScrollController();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      CupertinoScrollbar(
        controller: controller,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            controller: controller,
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
                label: Text('Aria 设置', style: GoogleFonts.notoSansSc(),),
                children: [
                  FTile(
                    title: Text('允许覆盖', style: GoogleFonts.notoSansSc(),),
                    details: FSwitch(
                      value: settings.overWrite.value,
                      onChange: (val){
                        settings.overWrite.value=val;
                        mainService.saveSettings();
                      },
                    ),
                  ),
                  FTile(
                    title: Text('下载位置', style: GoogleFonts.notoSansSc(),),
                    subtitle: Text(settings.downloadPath.value, style: GoogleFonts.notoSansSc(),),
                    onPress: () async {
                      final input=TextEditingController(text: settings.downloadPath.value);
                      final FocusNode focus=FocusNode();
                      Future.delayed(const Duration(milliseconds: 300), (){
                        focus.requestFocus();
                      });
                      await dialogs.showOkCancelDialogRaw(
                        context: context, 
                        title: '下载地址', 
                        child: FTextField(
                          controller: input,
                          focusNode: focus,
                        ),
                        okText: '完成',
                        okHandler: (){
                          settings.downloadPath.value=input.text;
                          mainService.saveSettings();
                        }
                      );
                    },
                  ),
                  FTile(
                    title: Text('最大同时下载个数', style: GoogleFonts.notoSansSc(),),
                    subtitle: Text(settings.downloadCount.value.toString(), style: GoogleFonts.notoSansSc(),),
                    onPress: () async {
                      final input=TextEditingController(text: settings.downloadCount.value.toString());
                      final FocusNode focus=FocusNode();
                      Future.delayed(const Duration(milliseconds: 300), (){
                        focus.requestFocus();
                      });
                      await dialogs.showOkCancelDialogRaw(
                        context: context, 
                        title: '最大同时下载个数', 
                        child: FTextField(
                          keyboardType: TextInputType.number,
                          controller: input,
                          focusNode: focus,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                        okText: '完成',
                        okHandler: (){
                          settings.downloadCount.value=int.parse(input.text);
                          mainService.saveSettings();
                        }
                      );
                    },
                  ),
                  FTile(
                    title: Text('做种时间', style: GoogleFonts.notoSansSc(),),
                    subtitle: Text(settings.seedTime.value.toString(), style: GoogleFonts.notoSansSc(),),
                    onPress: () async {
                      final input=TextEditingController(text: settings.seedTime.value.toString());
                      final FocusNode focus=FocusNode();
                      Future.delayed(const Duration(milliseconds: 300), (){
                        focus.requestFocus();
                      });
                      await dialogs.showOkCancelDialogRaw(
                        context: context, 
                        title: '做种时间', 
                        child: FTextField(
                          keyboardType: TextInputType.number,
                          controller: input,
                          focusNode: focus,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          suffixBuilder: (context, value, child) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('秒', style: GoogleFonts.notoSansSc(),),
                          ),
                        ),
                        okText: '完成',
                        okHandler: (){
                          try {
                            settings.seedTime.value=int.parse(input.text);
                            mainService.saveSettings();
                          } catch (_) {
                            dialogs.showOkDialog(
                              context: context, 
                              title: '修改错误', 
                              content: '输入内容不合法'
                            );
                          }
                        }
                      );
                    },
                  ),
                  FTile(
                    title: Text('做种比例', style: GoogleFonts.notoSansSc(),),
                    subtitle: Text(settings.seedRatio.value.toString(), style: GoogleFonts.notoSansSc(),),
                    onPress: () async {
                      final input=TextEditingController(text: settings.seedRatio.value.toString());
                      final FocusNode focus=FocusNode();
                      Future.delayed(const Duration(milliseconds: 300), (){
                        focus.requestFocus();
                      });
                      await dialogs.showOkCancelDialogRaw(
                        context: context, 
                        title: '做种比例', 
                        child: FTextField(
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          controller: input,
                          focusNode: focus,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                          ],
                        ),
                        okText: '完成',
                        okHandler: (){
                          try {
                            settings.seedRatio.value=double.parse(input.text);
                            mainService.saveSettings();
                          } catch (_) {
                            dialogs.showOkDialog(
                              context: context, 
                              title: '修改错误', 
                              content: '输入内容不合法'
                            );
                          }
                        }
                      );
                    },
                  ),
                  FTile(
                    title: Text('下载速度限制', style: GoogleFonts.notoSansSc(),),
                    subtitle: Text(settings.downloadLimit.value.toString(), style: GoogleFonts.notoSansSc(),),
                    onPress: () async {
                      final input=TextEditingController(text: settings.downloadLimit.value.toString());
                      final FocusNode focus=FocusNode();
                      Future.delayed(const Duration(milliseconds: 300), (){
                        focus.requestFocus();
                      });
                      await dialogs.showOkCancelDialogRaw(
                        context: context, 
                        title: '下载速度限制', 
                        child: FTextField(
                          keyboardType: TextInputType.number,
                          controller: input,
                          focusNode: focus,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          suffixBuilder: (context, value, child) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('字节/秒', style: GoogleFonts.notoSansSc(),),
                          ),
                        ),
                        okText: '完成',
                        okHandler: (){
                          try {
                            settings.downloadLimit.value=int.parse(input.text);
                            mainService.saveSettings();
                          } catch (_) {
                            dialogs.showOkDialog(
                              context: context, 
                              title: '修改错误', 
                              content: '输入内容不合法'
                            );
                          }
                        }
                      );
                    },
                  ),
                  FTile(
                    title: Text('上传速度限制', style: GoogleFonts.notoSansSc(),),
                    subtitle: Text(settings.uploadLimit.value.toString(), style: GoogleFonts.notoSansSc(),),
                    onPress: () async {
                      final input=TextEditingController(text: settings.uploadLimit.value.toString());
                      final FocusNode focus=FocusNode();
                      Future.delayed(const Duration(milliseconds: 300), (){
                        focus.requestFocus();
                      });
                      await dialogs.showOkCancelDialogRaw(
                        context: context, 
                        title: '上传速度限制', 
                        child: FTextField(
                          keyboardType: TextInputType.number,
                          controller: input,
                          focusNode: focus,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          suffixBuilder: (context, value, child) => Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('字节/秒', style: GoogleFonts.notoSansSc(),),
                          ),
                        ),
                        okText: '完成',
                        okHandler: (){
                          try {
                            settings.uploadLimit.value=int.parse(input.text);
                            mainService.saveSettings();
                          } catch (_) {
                            dialogs.showOkDialog(
                              context: context, 
                              title: '修改错误', 
                              content: '输入内容不合法'
                            );
                          }
                        }
                      );
                    },
                  ),
                  FTile(
                    title: Text('用户代理', style: GoogleFonts.notoSansSc(),),
                    subtitle: Text(
                      settings.userAgent.value, 
                      style: GoogleFonts.notoSansSc(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPress: () async {
                      final input=TextEditingController(text: settings.userAgent.value.toString());
                      final FocusNode focus=FocusNode();
                      Future.delayed(const Duration(milliseconds: 300), (){
                        focus.requestFocus();
                      });
                      await dialogs.showOkCancelDialogRaw(
                        context: context, 
                        title: '用户代理', 
                        child: FTextField.multiline(
                          focusNode: focus,
                          controller: input,
                        ),
                        okText: '完成',
                        okHandler: (){
                          settings.userAgent.value=input.text;
                          mainService.saveSettings();
                        }
                      );
                    },
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}