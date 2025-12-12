import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../common/util/util.dart';
import '../config/style.dart';
import './button.dart';

const double hPadding = 16.0;
const double vPadding = 120.0;
const double radiaus = 8.0;
// const double hPadding = 16.0;
// const double vPadding = 16.0;
// const double radiaus = 8.0;

class CustomDialogBox extends StatefulWidget {
  final String? title, okText, cancelText, icon;
  final String descriptions;
  final Widget? descriptionWidget;

  final Function onOkClicked, onCancelClicked;

  CustomDialogBox({
    this.icon = "default", // default, caution, warning
    required this.title,
    required this.descriptions,
    required this.okText,
    required this.cancelText,
    required this.onOkClicked,
    required this.onCancelClicked,
    this.descriptionWidget,
  });

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        // insetPadding: EdgeInsets.fromLTRB(sizingInformation.isTablet ? 120 : 120, 0, sizingInformation.isTablet ? 120 : 120, 0),
        child: contentBox(context),
      );
    });
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          // width: double.infinity,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: commonWhite,
            borderRadius: BorderRadius.circular(radiaus),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: hPadding, top: vPadding, right: hPadding, bottom: vPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.icon == "warning"
                          ? SvgPicture.asset("assets/images/ic_32_circle_cancel.svg",
                              colorFilter: const ColorFilter.mode(pointRed, BlendMode.srcIn))
                          : widget.icon == "caution"
                              ? SvgPicture.asset("assets/images/ic_32_warning.svg")
                              : widget.icon == "success"
                                  ? SvgPicture.asset("assets/images/ic_32_success.svg")
                                  : widget.icon == "empty"
                                      ? Container()
                                      : SvgPicture.asset("assets/images/ic_32_info.svg"),
                      widget.icon == "empty"
                          ? Container()
                          : Column(
                              children: [
                                Text(
                                  widget.title ?? "",
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: titleMedium(widget.icon == "warning"
                                      ? pointRed
                                      : widget.icon == "caution"
                                          ? themeYellow
                                          : widget.icon == "success"
                                              ? pointGreen
                                              : commonBlack),
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                              ],
                            ),
                      widget.descriptions == ""
                          ? widget.descriptionWidget!
                          : Text(
                              widget.descriptions,
                              style: bodyCommon(commonBlack),
                              textAlign: TextAlign.center,
                            ),
                    ],
                  )),
              Container(height: 0.5, color: commonGrey2),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: (widget.cancelText == null || widget.cancelText!.isEmpty)
                      ? <Widget>[
                          Container(),
                          Flexible(
                            child: Button(
                              label: widget.okText,
                              style: titleSmall(commonBlack),
                              height: 56,
                              backgroundColor: commonWhite,
                              onClick: () {
                                widget.onOkClicked();
                              },
                            ),
                          ),
                          Container()
                        ]
                      : <Widget>[
                          Flexible(
                              child: Button(
                            label: widget.cancelText,
                            height: 56,
                            style: titleSmall(commonGrey5),
                            backgroundColor: commonWhite,
                            borderColor: commonWhite,
                            onClick: () {
                              widget.onCancelClicked();
                            },
                          )),
                          // SizedBox(
                          //   width: 16,
                          // ),
                          Container(width: 0.5, height: 56, color: commonGrey2),
                          Flexible(
                            child: Button(
                              label: widget.okText,
                              style: titleSmall(commonBlack),
                              height: 56,
                              backgroundColor: commonWhite,
                              onClick: () {
                                widget.onOkClicked();
                              },
                            ),
                          ),
                        ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<void> showDefaultDialog(
    {required BuildContext context,
    required String? message,
    String message2 = "",
    Widget? descriptionWidget,
    required String? ok,
    required String? cancel,
    required Function action,
    bool barrierDismissible = true,
    bool stayDialog = false}) async {
  if (!isDialogShowing(context)) {
    showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            icon: "default",
            title: message,
            descriptions: message2,
            descriptionWidget: descriptionWidget,
            okText: ok,
            onOkClicked: () async {
              await action(true);
              if (!stayDialog) {
                if (context.mounted) Navigator.pop(context);
              }
            },
            cancelText: cancel,
            onCancelClicked: () async {
              if (context.mounted) Navigator.pop(context);
              await action(false);
            },
          );
        });
  }
}

bool isWarningDialogOpen = false;
Future<bool> showWarningDialog(
    {required BuildContext context,
    required String? message,
    String message2 = "",
    Widget? descriptionWidget,
    Function? dismissFunction,
    required String? ok,
    required String? cancel,
    required Function action,
    bool barrierDismissible = true}) async {
  //if (!isDialogShowing(context)) {//// NOT WORKING
  if (isWarningDialogOpen) return false;
  isWarningDialogOpen = true;
  return await showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) {
        return CustomDialogBox(
          icon: "warning",
          title: message,
          descriptions: message2,
          descriptionWidget: descriptionWidget,
          okText: ok,
          onOkClicked: () {
            Navigator.pop(context, true);
            action(true);
          },
          cancelText: cancel,
          onCancelClicked: () {
            Navigator.pop(context, false);
            action(false);
          },
        );
      }).then((value) {
    if (dismissFunction != null) {
      dismissFunction();
    }
    isWarningDialogOpen = false;
    return value;
  });
  isWarningDialogOpen = false;
  // }
}

Future<bool> showCautionDialog(
    {required BuildContext context,
    required String? message,
    String message2 = "",
    Widget? descriptionWidget,
    required String? ok,
    required String? cancel,
    required Function action,
    bool barrierDismissible = true}) async {
  if (!isDialogShowing(context)) {
    return await showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            icon: "caution",
            title: message,
            descriptions: message2,
            descriptionWidget: descriptionWidget,
            okText: ok,
            onOkClicked: () {
              action(true);
              Navigator.pop(context, true);
            },
            cancelText: cancel,
            onCancelClicked: () {
              action(false);
              Navigator.pop(context, false);
            },
          );
        });
  }
  return false;
}

Future<void> showSuccessDialog(
    {required BuildContext context,
    required String? message,
    String message2 = "",
    Widget? descriptionWidget,
    required String? ok,
    required String? cancel,
    required Function action,
    bool barrierDismissible = true}) async {
  if (!isDialogShowing(context)) {
    await showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            icon: "success",
            title: message,
            descriptions: message2,
            descriptionWidget: descriptionWidget,
            okText: ok,
            onOkClicked: () {
              Navigator.pop(context, true);
              action(true);
            },
            cancelText: cancel,
            onCancelClicked: () {
              Navigator.pop(context);
              action(false, false);
            },
          );
        });
  }
}

Future<bool> showEmptyDialog(
    {required BuildContext context,
    required String? message,
    String message2 = "",
    Widget? descriptionWidget,
    required String? ok,
    required String? cancel,
    required Function action,
    bool barrierDismissible = true}) async {
  if (!isDialogShowing(context)) {
    return await showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            icon: "empty",
            title: message,
            descriptions: message2,
            descriptionWidget: descriptionWidget,
            okText: ok,
            onOkClicked: () {
              Navigator.pop(context, true);
              action(true);
            },
            cancelText: cancel,
            onCancelClicked: () {
              Navigator.pop(context, false);
              action(false);
            },
          );
        });
  }
  return false;
}

// for not supported menu, button
void showNotServiceYet(BuildContext context) {
  if (!isDialogShowing(context)) {
    showWarningDialog(
        context: context,
        message: "error_not_support".tr(),
        message2: "error_not_support_detail".tr(),
        ok: "common_ok".tr(),
        cancel: "",
        action: (bool action) {});
  }
}

Future<bool?> showCommonExitPopup(context, {String? message, String? message2, String? cancel}) async {
  bool nextAction = false;
  return await showCautionDialog(
      context: context,
      message: message ?? "Exit this page?".tr(),
      message2: message2 ?? "Are you sure you want to exit this page without confirming new changes?".tr(),
      ok: "Ok".tr(),
      cancel: cancel ?? "Cancel".tr(),
      action: (bool action) async {
        nextAction = action;
      }).then((value) {
    if (nextAction == true) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  });
}

Future<void> showLoadingPopup(context, Widget descriptionWidget, {String? message, String? message2}) async {
  if (!isDialogShowing(context)) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: commonWhite,
                    borderRadius: BorderRadius.circular(radiaus),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(left: hPadding, top: vPadding + 12, right: hPadding, bottom: vPadding + 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              message != null
                                  ? Text(
                                      message,
                                      style: titleMedium(commonBlack),
                                    )
                                  : Container(),
                              descriptionWidget,
                              message2 != null
                                  ? Text(
                                      message2,
                                      style: titleMedium(commonBlack),
                                    )
                                  : Container(),
                            ],
                          )),
                      Container(height: 0.5, color: commonGrey2),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
