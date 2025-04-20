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

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          padding: const EdgeInsets.all(0),
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
                  title: Text('关于Aria Remote', style: GoogleFonts.notoSansSc(),),
                  subtitle: Text(settings.version.value, style: GoogleFonts.notoSansSc(),),
                  onPress: (){
                    // TODO 关于页面
                  },
                )
              ]
            )
          ],
        ),
      ),
    );
  }
}