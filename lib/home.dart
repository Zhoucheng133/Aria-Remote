import 'package:aria_remote/utils/get_functions.dart';
import 'package:aria_remote/utils/get_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  final GetFunctions functions=Get.find();
  final GetPages pages=Get.find();

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
      Scaffold(
        appBar: AppBar(
          title: Text(pages.nameController()),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: pages.page.value.index,
          onTap: (index){
            pages.page.value=Pages.values[index];
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.download_rounded),
              label: '活跃中',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.download_done_rounded),
              label: '已完成',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: '设置',
            )
          ]
        ),
        body: const Center(
          child: Text('hello world'),
        ),
      )
    );
 
  }
}