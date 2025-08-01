import 'package:aria_remote/utils/get_dialogs.dart';
import 'package:aria_remote/utils/get_main_service.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {

  final inputUrl=TextEditingController();
  final GetMainService mainService=Get.find();
  final GetDialogs d=Get.find();
  final FocusNode focus=FocusNode();

  Future<void> init() async {
    final copyText=await FlutterClipboard.paste();
    if(validLink(copyText)){
      setState(() {
        inputUrl.text=copyText;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          FocusScope.of(context).requestFocus(focus);
        }
      });
    });
  }

  bool validLink(String input){
    List urls=input.split("\n");
    for (var url in urls) {
      if(url.startsWith("http://") || url.startsWith("https://") || url.startsWith("magnet:?xt=urn:btih:")){
        return true;
      }
    }
    return false;
  }


  Future<void> addTaskHandler() async {
    if(!validLink(inputUrl.text)){
      await d.showOkDialog(
        context: context, 
        title: '添加任务失败', 
        content: '任务链接不合法'
      );
      return;
    }
    mainService.addTask(inputUrl.text);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      childPad: false,
      header: FHeader.nested(
        title: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '添加任务',
            style: GoogleFonts.notoSansSc(),
          )
        ),
        prefixes: [
          FHeaderAction.back(onPress: ()=>Get.back()),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            FTextField.multiline(
              label: Text('在这里输入新任务的链接', style: GoogleFonts.notoSansSc(),),
              controller: inputUrl,
              maxLines: 5,
              hint: 'http(s)://\nmagnet:?xt=urn:btih:',
              focusNode: focus,
            ),
            const SizedBox(height: 15,),
            FButton(
              onPress: ()=>addTaskHandler(), 
              child: Text('添加', style: GoogleFonts.notoSansSc(),)
            )
          ],
        ),
      )
    );
  }
}