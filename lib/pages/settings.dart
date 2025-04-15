import 'package:aria_remote/utils/get_functions.dart';
import 'package:aria_remote/utils/get_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      ListView(
        children: [
          ListTile(
            title: const Text('RPC 配置'),
            subtitle: Text(
              settings.rpc.value.isEmpty?'没有设置':settings.rpc.value,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            onTap: ()=>functions.rpcDialog(context)
          ),
        ],
      ),
    );
  }
}