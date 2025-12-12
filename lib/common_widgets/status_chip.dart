import 'package:flutter/material.dart';
import 'package:moni_pod_web/config/style.dart';

class StatusChip extends StatefulWidget {
  const StatusChip({super.key, required this.status});

  final String status;

  @override
  State<StatusChip> createState() => _StatusChipState();
}

class _StatusChipState extends State<StatusChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),

        color:
            widget.status == "offline"
                ? commonGrey6
                : widget.status == "critical"
                ? Colors.red
                : widget.status == "warning"
                ? themeYellow
                : themeGreen,
      ),
      child: Text(widget.status.toUpperCase(), style: captionTitle(commonWhite)),
    );
  }
}
