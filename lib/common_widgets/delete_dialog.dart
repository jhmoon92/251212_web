import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moni_pod_web/config/style.dart';

import 'input_box.dart';

void showDeleteDialog(
  BuildContext context, {
  required TextEditingController controller,
  required String name,
  required VoidCallback onDelete,
}) {
  showDialog(context: context, builder: (context) => CommonDeleteDialog(onDelete: onDelete, controller: controller, name: name)).then((_) {
    controller.clear();
  });
}

class CommonDeleteDialog extends StatefulWidget {
  final TextEditingController controller;
  final String name;
  final VoidCallback onDelete;

  const CommonDeleteDialog({super.key, required this.name, required this.controller, required this.onDelete});

  @override
  State<CommonDeleteDialog> createState() => _CommonDeleteDialogState();
}

class _CommonDeleteDialogState extends State<CommonDeleteDialog> {
  int _currentIndex = 0;
  String temString = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: commonWhite,
      child: Container(
        width: 432,
        height: 288,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset("assets/images/ic_24_important.svg"),
                const SizedBox(width: 8),
                Text('Delete', style: titleLarge(commonBlack)),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(child: IndexedStack(index: _currentIndex, children: [step1Screen(), step2Screen()])),
          ],
        ),
      ),
    );
  }

  Widget step1Screen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Are you sure to delete This?', style: titleSmall(commonBlack)),
        const SizedBox(height: 12),
        Text('If you delete this, all associated data will be permanently removed.', style: deleteCommon(commonBlack)),
        const Spacer(),
        Row(
          children: [
            Expanded(child: SizedBox()),
            InkWell(
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
              child: Container(
                height: 40,
                width: 186,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: themeYellow, borderRadius: BorderRadius.circular(4)),
                child: Text('Delete', style: bodyTitle(commonWhite)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget step2Screen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Check Deleting', style: titleSmall(commonBlack)),
        const SizedBox(height: 12),
        Text('Enter ${widget.name} you set before', style: deleteCommon(commonBlack)),
        const SizedBox(height: 12),
        InputBox(
          controller: widget.controller,
          label: 'Enter the name',
          maxLength: 32,
          isErrorText: true,
          onSaved: (val) {},
          textStyle: bodyCommon(commonBlack),
          textType: 'normal',
          validator: (value) {
            return null;
          },
          onChanged: (value){
            setState(() {
              temString = value;
            });
          },
        ),
        const Spacer(),
        Row(
          children: [
            Expanded(child: SizedBox()),
            InkWell(
              onTap: () {
                widget.onDelete();
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                width: 186,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: temString == '' ? commonGrey5 : themeYellow, borderRadius: BorderRadius
                    .circular(4)),
                child: Text('OK', style: bodyTitle(temString == '' ? commonGrey6 :commonWhite)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
