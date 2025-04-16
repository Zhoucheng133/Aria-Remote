import 'dart:math';

import 'package:flutter/material.dart';

class ActiveItem extends StatefulWidget {
  final String name;
  final int totalLength;
  final int completedLength; 
  final String dir;
  final int downloadSpeed;
  final int? uploadSpeed;
  final String gid;
  final String status;
  final bool selectMode;
  final VoidCallback changeSelectStatus;
  final bool checked;
  final bool active;
  final int index;

  const ActiveItem({super.key, required this.name, required this.totalLength, required this.completedLength, required this.dir, required this.downloadSpeed, this.uploadSpeed, required this.gid, required this.status, required this.selectMode, required this.changeSelectStatus, required this.checked, required this.active, required this.index});

  @override
  State<ActiveItem> createState() => _ActiveItemState();
}

class _ActiveItemState extends State<ActiveItem> {

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

    // 如果有小时数，则显示小时部分
    if (hours > 0) {
      String formattedHours = hours.toString();
      return '$formattedHours:$formattedMinutes:$formattedSeconds';
    } else {
      return '$formattedMinutes:$formattedSeconds';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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
          ),
          IconButton(
            onPressed: (){

            }, 
            icon: const Icon(
              Icons.more_vert_rounded
            )
          )
        ],
      )
    );
  }
}