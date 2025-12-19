import 'package:flutter/material.dart';
import 'package:moni_pod_web/config/style.dart';

class SelectStatusChip extends StatefulWidget {
  const SelectStatusChip({super.key, required this.status, required this.isSelect, required this.onTap});

  final String status;
  final bool isSelect;
  final VoidCallback onTap;

  @override
  State<SelectStatusChip> createState() => _SelectStatusChipState();
}

class _SelectStatusChipState extends State<SelectStatusChip> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: commonGrey2, width: 1),
          color:
              widget.isSelect
                  ? widget.status == "all"
                      ? commonBlack
                      : widget.status == "critical"
                      ? warningRed
                      : widget.status == "warning"
                      ? themeYellow
                      : widget.status == "offline"
                      ? commonGrey5
                      : successGreen
                  : commonWhite,
        ),
        child: Row(
          children: [
            widget.status == "all"
                ? Container()
                : Container(
                  height: 6,
                  width: 6,
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        widget.isSelect
                            ? commonWhite
                            : widget.status == "offline"
                            ? commonGrey5
                            : widget.status == "critical"
                            ? warningRed
                            : widget.status == "warning"
                            ? themeYellow
                            : successGreen,
                  ),
                ),
            Text(
              widget.status.toUpperCase(),
              style: bodyTitle(
                widget.isSelect
                    ? commonWhite
                    : widget.status == "all"
                    ? commonBlack
                    : widget.status == "offline"
                    ? commonGrey5
                    : widget.status == "critical"
                    ? warningRed
                    : widget.status == "warning"
                    ? themeYellow
                    : successGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
