import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../config/style.dart';

class Button extends StatefulWidget {
  final String? label;
  final Function onClick;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final bool isGreyButton;
  final FontWeight? fontWeight;
  final FocusNode? focus;
  final TextStyle? style;
  final double? height;

  Button({
    required this.label,
    required this.onClick,
    required this.backgroundColor,
    this.borderColor = commonWhite,
    this.textColor = commonWhite,
    this.isGreyButton = false,
    this.fontWeight,
    this.focus,
    this.style,
    this.height,
  });

  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  TextStyle btnTextStyle = const TextStyle(fontWeight: FontWeight.w500, fontSize: 16);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.height ?? 48,
      child: OutlinedButton(
        focusNode: widget.focus,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
          foregroundColor: MaterialStateProperty.all<Color>(widget.textColor),
          side: MaterialStateProperty.all<BorderSide>(BorderSide(color: widget.borderColor)),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed) && widget.isGreyButton) {
              return commonGrey5.withOpacity(0.1);
            }
            return widget.backgroundColor;
          }),
          overlayColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed) && widget.isGreyButton) {
              return commonGrey5.withOpacity(0.1);
            }
            return commonWhite.withOpacity(0.2);
          }),
        ),
        onPressed: () {
          widget.onClick();
        },
        child: Text(
          widget.label ?? "",
          style:
              widget.style ??
              btnTextStyle.copyWith(
                color: widget.textColor,
                //                  fontWeight: (widget.fontWeight != null) ? widget.fontWeight : FontWeight.bold
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

Widget addButton(String text, VoidCallback onTap, {Widget? imageWidget}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: 256,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: themeYellow, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageWidget ?? SvgPicture.asset('assets/images/ic_24_add.svg'),
          const SizedBox(width: 4),
          Text(text, style: bodyTitle(commonWhite)),
        ],
      ),
    ),
  );
}
