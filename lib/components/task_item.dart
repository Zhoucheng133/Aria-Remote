import 'dart:math';
import 'package:aria_remote/utils/get_main_service.dart';
import 'package:aria_remote/utils/get_tasks.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';

class TaskItem extends StatefulWidget {
  final String name;
  final int totalLength;
  final int completedLength; 
  final String dir;
  final int downloadSpeed;
  final dynamic uploadSpeed;
  final String gid;
  final String status;
  final bool selectMode;
  final VoidCallback changeSelectStatus;
  final bool checked;
  final bool active;
  final int index;

  const TaskItem({super.key, required this.name, required this.totalLength, required this.completedLength, required this.dir, required this.downloadSpeed, this.uploadSpeed, required this.gid, required this.status, required this.selectMode, required this.changeSelectStatus, required this.checked, required this.active, required this.index});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> with SingleTickerProviderStateMixin{

  String convertSize(int bytes) {
    try {
      if (bytes < 0) return 'Invalid value';
      const List<String> units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
      int unitIndex = max(0, min(units.length - 1, (log(bytes) / log(1024)).floor()));
      double value = bytes / pow(1024, unitIndex);
      String formattedValue = value % 1 == 0 ? '$value' : value.toStringAsFixed(2);
      return '$formattedValue ${units[unitIndex]}';
    } catch (_) {
      return '0 B';
    }
  }

  String formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    if (hours > 0) {
      String formattedHours = hours.toString();
      return '$formattedHours:$formattedMinutes:$formattedSeconds';
    } else {
      return '$formattedMinutes:$formattedSeconds';
    }
  }

  final GetMainService mainService=Get.find();
  final GetTasks tasks=Get.find();

  void copyLink(){
    final item=widget.active ? tasks.active[widget.index] : tasks.stopped[widget.index];
    final uris=item['files'][0]['uris'];
    final infoHash=item['infoHash'];
    if(uris.length==0){
      FlutterClipboard.copy('magnet:?xt=urn:btih:$infoHash');
    }else{
      FlutterClipboard.copy(uris[0]['uri']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5,),
                      Text(
                        convertSize(widget.totalLength),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12
                        ),
                      )
                    ],
                  ),
                ),
                widget.active ? widget.status=='active' ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        widget.uploadSpeed!=null ? Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            widget.uploadSpeed!=0 ? const Icon(
                              Icons.arrow_upward_rounded,
                              size: 14,
                            ) : Container(),
                            const SizedBox(width: 3,),
                            Text(
                              widget.uploadSpeed==0 ? '' : '${convertSize(widget.uploadSpeed!)}/s',
                              style: const TextStyle(
                                fontSize: 12
                              ),
                            ),
                          ],
                        ) : Container(),
                        const SizedBox(width: 10,),
                        const Icon(
                          Icons.arrow_downward_rounded,
                          size: 14,
                        ),
                        const SizedBox(width: 3,),
                        Text(
                          widget.downloadSpeed==0 ? '0 B/s' : '${convertSize(widget.downloadSpeed)}/s',
                          style: const TextStyle(
                            fontSize: 12
                          ),
                        ),
                      ],
                    ),
                    (widget.completedLength/widget.totalLength)!=1.0 ? Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        widget.downloadSpeed==0 ? '--:--' : formatDuration(((widget.totalLength - widget.completedLength) > 0 ? widget.totalLength - widget.completedLength : 0)~/widget.downloadSpeed),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600]
                        ),
                      ),
                    ):Container()
                  ],
                ) : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FIcon(
                      widget.status=='paused' ? FAssets.icons.circlePause : FAssets.icons.loader,
                      size: 15,
                      color: Colors.grey,
                    )
                  ],
                ) : Container(),
                FButton.icon(
                  style: FButtonStyle.ghost,
                  onPress: ()=>showFSheet(
                    context: context,
                    side: FLayout.btt,
                    builder: (context)=>Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FTileGroup(
                          children: [
                            if(widget.active && (widget.status=='active' || widget.status=='paused')) FTile(
                              prefixIcon: FIcon(widget.status=='active' ? FAssets.icons.pause : FAssets.icons.play),
                              title: Text(widget.status=='active' ? '暂停' : '继续'),
                              onPress: (){
                                if(widget.status=='active'){
                                  mainService.pauseTask(widget.gid);
                                }else{
                                  mainService.continueTask(widget.gid);
                                }
                                Navigator.pop(context);
                              },
                            ) else if(!widget.active) FTile(
                              prefixIcon: FIcon(FAssets.icons.rotateCw),
                              title: const Text('重新下载'),
                              onPress: (){},
                            ),
                            FTile(
                              prefixIcon: FIcon(FAssets.icons.info),
                              title: const Text('任务信息'),
                              onPress: () {},
                            ),
                            FTile(
                              prefixIcon: FIcon(FAssets.icons.list),
                              title: const Text('文件列表'),
                              onPress: () {},
                            ),
                            FTile(
                              prefixIcon: FIcon(FAssets.icons.copy),
                              title: const Text('复制链接'),
                              onPress: () {
                                copyLink();
                                Navigator.pop(context);
                              },
                            ),
                            FTile(
                              prefixIcon: FIcon(FAssets.icons.trash),
                              title: const Text('移除'),
                              onPress: () {
                                if(widget.active){
                                  mainService.remove(widget.gid);
                                }else{
                                  mainService.removeFinishedTask(widget.gid);
                                }
                                
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        Container(
                          height: MediaQuery.of(context).padding.bottom,
                          color: Colors.white,
                        )
                      ],
                    )
                  ), 
                  child: const Icon(Icons.more_vert)
                )
              ],
            )
          ),
        ],
      ),
    );
  }
}