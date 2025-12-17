import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moni_pod_web/config/style.dart';

void showCustomDialog({required BuildContext context, required String title, Widget? titleWidget, required Widget content}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomDialog(title: title, titleWidget: titleWidget, contentWidget: content);
    },
  );
}

class CustomDialog extends ConsumerStatefulWidget {
  const CustomDialog({required this.title, required this.titleWidget, required this.contentWidget, super.key});

  final String title;
  final Widget? titleWidget;
  final Widget contentWidget;

  @override
  ConsumerState<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends ConsumerState<CustomDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: SizedBox(
        width: 680,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                decoration: BoxDecoration(
                  color: commonWhite,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    widget.titleWidget == null ? Text(widget.title, style: titleLarge(commonBlack)) : widget.titleWidget!,
                    Expanded(child: Container()),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: SvgPicture.asset(
                        "assets/images/ic_24_cancel.svg",
                        colorFilter: const ColorFilter.mode(commonBlack, BlendMode.srcIn),
                      ),
                    )
                  ],
                ),
              ),
              widget.contentWidget,
            ],
          ),
        ),
      ),
    );
  }
}
