import 'package:aria_remote/utils/get_settings.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {

  final GetSettings settings=Get.find();

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      childPad: false,
      header: FHeader.nested(
        title: Text('关于', style: GoogleFonts.notoSansSc(),),
        prefixes: [
          FHeaderAction.back(onPress: ()=>Get.back()),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: Image.asset("assets/icon.png")
              ),
              const SizedBox(height: 15,),
              Text(
                'Aria Remote',
                style: GoogleFonts.notoSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              const SizedBox(height: 5,),
              Text(
                settings.version.value,
                style: GoogleFonts.notoSans(
                  fontSize: 15,
                  color: Colors.grey
                ),
              ),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse('https://github.com/Zhoucheng133/Aria-Remote');
                  await launchUrl(url);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      FIcons.github,
                      size: 15,
                    ),
                    const SizedBox(width: 5,),
                    Text(
                      '本项目地址',
                      style: GoogleFonts.notoSansSc(
                        fontSize: 15
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5,),
              GestureDetector(
                onTap: (){
                  showLicensePage(
                    applicationName: 'Aria Remote',
                    applicationVersion: settings.version.value,
                    context: context
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // FIcon(
                    //   FIcons.scale,
                    //   size: 15,
                    // ),
                    const Icon(
                      FIcons.scale,
                      size: 15,
                    ),
                    const SizedBox(width: 5,),
                    Text(
                      '许可证',
                      style: GoogleFonts.notoSansSc(
                        fontSize: 15
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50,),
            ],
          ),
        ),
      )
    );
  }
}