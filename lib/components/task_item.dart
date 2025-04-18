import 'dart:math';
import 'package:aria_remote/utils/get_main_service.dart';
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

  late FPopoverController controller;
  final GetMainService mainService=Get.find();

  @override
  void initState() {
    super.initState();
    controller = FPopoverController(vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Stack(
        children: [
          widget.active ? FractionallySizedBox(
            widthFactor: widget.totalLength==0 ? 0 : (widget.completedLength/widget.totalLength),
            heightFactor: 1.0,
            child: Container(color: Colors.teal[50]),
          ) : Container(),
          !widget.active && widget.completedLength/widget.totalLength!=1 ? FractionallySizedBox(
            widthFactor: widget.totalLength==0 ? 0 : (widget.completedLength/widget.totalLength),
            heightFactor: 1.0,
            child: Container(color: Colors.orange[50]),
          ) : Container(),
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
                widget.active ? Column(
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
                ) : Container(),
                FPopoverMenu(
                  popoverController: controller,
                  shift: FPortalShift.flip,
                  childAnchor: Alignment.bottomRight,
                  menu: [
                    widget.active ? FTileGroup(
                      children: [
                        FTile(
                          prefixIcon: FIcon(widget.status=='active' ? FAssets.icons.pause : FAssets.icons.play),
                          title: Text(widget.status=='active' ? '暂停' : '继续'),
                          onPress: (){
                            if(widget.status=='active'){
                              mainService.pauseTask(widget.gid);
                            }else{
                              mainService.continueTask(widget.gid);
                            }
                            controller.hide();
                          },
                        )
                      ]
                    ) : FTileGroup(
                      children: [
                        FTile(
                          prefixIcon: FIcon(FAssets.icons.rotateCw),
                          title: const Text('重新下载'),
                          onPress: (){},
                        )
                      ]
                    ),
                    FTileGroup(
                      children: [
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
                          onPress: () {},
                        ),
                      ],
                    ),
                    FTileGroup(
                      children: [
                        FTile(
                          prefixIcon: FIcon(FAssets.icons.trash),
                          title: const Text('删除'),
                          onPress: () {},
                        ),
                      ],
                    ),
                  ],
                  child: FButton.icon(
                    style: FButtonStyle.ghost,
                    onPress: () {
                      controller.toggle();
                    },
                    child: const Icon(
                      Icons.more_vert_rounded
                    ),
                  )
                )
              ],
            )
          ),
        ],
      ),
    );
  }
}