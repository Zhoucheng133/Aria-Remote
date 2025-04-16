import 'package:aria_remote/utils/get_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Active extends StatefulWidget {
  const Active({super.key});

  @override
  State<Active> createState() => _ActiveState();
}

class _ActiveState extends State<Active> {

  final GetSettings settings=Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 20,
          bottom: 20,
          child: Obx(()=>
            FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: Colors.teal,
              onPressed: settings.isLogin() ? (){
            
              } : null,
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
              ),
            ),
          )
        ),
        const Center(
          child: Text('Active'),
        )
      ],
    );
  }
}