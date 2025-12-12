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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: themeYellow,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    widget.titleWidget == null ? Text(widget.title, style: titleLarge(commonWhite)) : widget.titleWidget!,
                    Expanded(child: Container()),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Exit',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              widget.contentWidget,
            ],
          ),
        ),
      ),
    );
  }
}
