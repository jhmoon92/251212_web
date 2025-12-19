import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moni_pod_web/config/style.dart';

import 'input_box.dart';

void showSuccessDialog(BuildContext context) {
  showDialog(context: context, builder: (context) => CommonSuccessDialog());
}

class CommonSuccessDialog extends StatefulWidget {
  const CommonSuccessDialog({super.key});

  @override
  State<CommonSuccessDialog> createState() => _CommonSuccessDialogState();
}

class _CommonSuccessDialogState extends State<CommonSuccessDialog> {
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
                SvgPicture.asset("assets/images/ic_24_success_circle.svg"),
                const SizedBox(width: 8),
                Text('Success', style: titleLarge(commonBlack)),
              ],
            ),
            const SizedBox(height: 24),
            Text('The {this name} is deleted.', style: deleteCommon(commonBlack)),
            const Spacer(),
            Row(
              children: [
                Expanded(child: SizedBox()),
                InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: Container(
                    height: 40,
                    width: 186,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: themeYellow, borderRadius: BorderRadius.circular(4)),
                    child: Text('Done', style: bodyTitle(commonWhite)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
