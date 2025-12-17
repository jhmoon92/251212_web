import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

import '../common/util/util.dart';
import '../common/util/validators.dart';
import '../config/style.dart';

class InputBox extends StatefulWidget {
  final String textType;
  final FormFieldSetter onSaved;
  final FormFieldValidator validator;
  final TextEditingController? controller;
  final Function? onEditingComplete;
  final Function? onFieldSubmitted;
  final FocusNode? focus;
  final String? placeHolder;
  final String? value;
  final String? label;
  final GlobalKey<FormState>? formKey;
  final bool showVerify;
  final bool autofocus;
  final int minTextValidation;
  final String initialText;
  final String tooltipText;
  final Function? onChanged;
  final Function? hasFocusOneTime;
  final int? maxLength;
  final TextStyle textStyle;
  final bool? checkValidator;
  final bool? isErrorText;
  final bool? emailCheck;
  final bool? alreadyRegister;
  final String validText;
  final bool validLength;
  final bool validMax;
  final bool denySpecialText;
  final bool validCheckCharacter;
  final bool validCheckNumber;
  final bool validCheckSpecial;
  final bool readOnly;
  final bool isTight;
  final Widget? icon;

  InputBox({
    required this.textType, // normal, password, number, email
    required this.onSaved,
    required this.validator,
    required this.textStyle,
    this.focus,
    this.controller,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.placeHolder,
    this.value,
    this.formKey,
    this.label,
    this.showVerify = false,
    this.autofocus = false,
    this.minTextValidation = -1,
    this.initialText = "",
    this.tooltipText = "",
    this.onChanged,
    this.hasFocusOneTime,
    this.maxLength,
    this.checkValidator,
    this.validLength = false,
    this.validMax = false,
    this.isErrorText = false,
    this.emailCheck = false,
    this.alreadyRegister = false,
    this.validText = "",
    this.denySpecialText = false,
    this.validCheckCharacter = false,
    this.validCheckNumber = false,
    this.validCheckSpecial = false,
    this.readOnly = false,
    this.isTight = false,
    this.icon,
  });

  InputBoxState createState() => InputBoxState();
}

class InputBoxState extends State<InputBox> with EmailAndPasswordValidators {
  bool _isError = false;
  bool _showVerify = false;
  bool _focusOnetime = false;
  bool _passwordVisible = false;
  bool _emailConfirm = false;

  final _focus = FocusScopeNode();
  late FocusNode _focusNode;

  _focusListener() {
    setState(() {});
  }

  @override
  void initState() {
    if (widget.initialText.isNotEmpty) widget.controller!.text = widget.initialText;
    _focusNode = ((widget.focus != null) ? widget.focus : FocusNode())!;
    _focusNode.addListener(_focusListener);
    if (widget.controller != null) {
      widget.controller!.addListener(() {
        if (widget.controller!.text.isEmpty) {
          if (widget.onChanged != null) {
            widget.onChanged!("");
          }
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _focus.dispose();
    _focusNode.removeListener(_focusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
        } else {
          setState(() {
            _focusOnetime = true;
            if (widget.hasFocusOneTime != null) widget.hasFocusOneTime!();
          });
        }
      },
      child: Column(
        children: [
          TextFormField(
            readOnly: widget.readOnly,
            magnifierConfiguration: const TextMagnifierConfiguration(shouldDisplayHandlesInMagnifier: false),
            contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
              return AdaptiveTextSelectionToolbar(
                anchors: editableTextState.contextMenuAnchors,
                children:
                    editableTextState.contextMenuButtonItems.map((ContextMenuButtonItem buttonItem) {
                      return CupertinoButton(
                        borderRadius: BorderRadius.circular(4),
                        disabledColor: commonGrey3,
                        onPressed: buttonItem.onPressed,
                        padding: const EdgeInsets.all(8),
                        pressedOpacity: 0.7,
                        child: Text(
                          CupertinoTextSelectionToolbarButton.getButtonLabel(context, buttonItem),
                          style: bodyCommon(commonBlack),
                        ),
                      );
                    }).toList(),
              );
            },
            inputFormatters: <TextInputFormatter>[
              widget.denySpecialText
                  ? FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))
                  : FilteringTextInputFormatter.allow(RegExp(r'.')),
              FilteringTextInputFormatter.deny(RegExp(r'\s')),
              FilteringTextInputFormatter.deny(RegExp(r'[\u0E30-\u0E3A\u0E40-\u0E5B]{2,}')),
              (widget.textType == "email")
                  ? ValidatorInputFormatter(editingValidator: EmailEditingRegexValidator())
                  : (widget.textType == "password")
                  ? ValidatorInputFormatter(editingValidator: PasswordSubmitRegexValidator())
                  : (widget.textType == "number")
                  ? FilteringTextInputFormatter.digitsOnly
                  : FilteringTextInputFormatter.deny(""),
            ],
            maxLength: widget.maxLength ?? TextField.noMaxLength,
            keyboardType:
                (widget.textType == "number")
                    ? TextInputType.number
                    : (widget.textType == "email")
                    ? TextInputType.emailAddress
                    : TextInputType.text,
            controller: (widget.controller != null) ? widget.controller : null,
            focusNode: _focusNode,
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: (widget.textType == "password" && !_passwordVisible),
            style: widget.textStyle,
            enableSuggestions: false,
            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(value);
                setState(() {
                  if (widget.textType == "email" && emailErrorText(value) == null && widget.emailCheck!) {
                    _emailConfirm = true;
                  } else {
                    _emailConfirm = false;
                  }
                });
              }
            },
            onEditingComplete: () {
              if (widget.onEditingComplete != null) {
                if (mounted) widget.onEditingComplete!();
              }
            },
            onFieldSubmitted:
                (String v) => {
                  if (widget.onFieldSubmitted != null) {if (mounted) widget.onFieldSubmitted!(v)},
                },
            decoration: InputDecoration(
              hintText: _focusOnetime ? "" : widget.placeHolder,
              hintStyle: bodyCommon(commonGrey5),
              labelStyle: bodyCommon(commonGrey5),
              labelText: widget.label,
              errorStyle: widget.isErrorText! ? captionCommon(pointRed) : const TextStyle(height: 0.01, color: pointRed),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: commonWhite,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: widget.isTight ? 14 : 16),
              // suffix: SizedBox(
              //   child: FittedBox(
              //     child: Row(
              //       children: [
              //         Text(text),
              //         const SizedBox(width: 4),
              //       ],
              //     ),
              //   ),3384830
              // ),
              prefixIcon: widget.icon,
              prefixIconConstraints: BoxConstraints(minWidth: 32, minHeight: 32, maxWidth: 32, maxHeight: 32),
              suffixIcon:
                  _focusNode.hasFocus
                      ? _isError
                          ? SvgPicture.asset("assets/images/ic_fall.svg")
                          : (widget.textType == "password" && !_passwordVisible)
                          ? GestureDetector(
                            onTap: () {
                              setState(() {
                                _passwordVisible = true;
                              });
                            },
                            child: SvgPicture.asset("assets/images/ic_32_eye_off.svg", height: 32, width: 32, fit: BoxFit.none),
                          )
                          : (widget.textType == "password" && _passwordVisible)
                          ? GestureDetector(
                            onTap: () {
                              setState(() {
                                _passwordVisible = false;
                              });
                            },
                            child: SvgPicture.asset("assets/images/ic_32_eye.svg", height: 32, width: 32, fit: BoxFit.none),
                          )
                          : _emailConfirm
                          ? widget.alreadyRegister!
                              ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.controller!.clear();
                                  });
                                },
                                child: SvgPicture.asset("assets/images/ic_32_circle_cancel.svg", height: 32, width: 32, fit: BoxFit.none),
                              )
                              : SvgPicture.asset("assets/images/ic_32_circle_check_checked.svg", height: 32, width: 32, fit: BoxFit.none)
                          : widget.readOnly
                          ? Container()
                          : GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.controller!.clear();
                              });
                            },
                            child: SvgPicture.asset("assets/images/ic_32_circle_cancel.svg", height: 32, width: 32, fit: BoxFit.none),
                          )
                      : _emailConfirm
                      ? SvgPicture.asset("assets/images/ic_32_circle_check_checked.svg", height: 32, width: 32, fit: BoxFit.none)
                      : null,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: commonGrey2, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    _showVerify
                        ? const BorderSide(color: pointRed, width: 1.0)
                        : BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: pointRed, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: pointRed, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              counterText: "",
            ),
          ),
          (_focusNode.hasFocus || _focusOnetime) && widget.minTextValidation != -1 && widget.validLength
              ? Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.controller!.text.length >= widget.minTextValidation
                          ? SvgPicture.asset("assets/images/ic_16_check_checked.svg")
                          : SvgPicture.asset(
                            "assets/images/ic_16_check.svg",
                            colorFilter: const ColorFilter.mode(pointRed, BlendMode.srcIn),
                          ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        child: Text(
                          widget.validText == ""
                              ? fstr("error_char_limit_n_30".tr(), [widget.minTextValidation.toString()])
                              : widget.validText,
                          style: captionCommon(commonGrey5),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : Container(),
          (_focusNode.hasFocus || _focusOnetime) && widget.validMax
              ? Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.controller!.text.isNotEmpty
                          ? SvgPicture.asset("assets/images/ic_16_check_checked.svg")
                          : SvgPicture.asset(
                            "assets/images/ic_16_check.svg",
                            colorFilter: const ColorFilter.mode(pointRed, BlendMode.srcIn),
                          ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        child: Text(
                          widget.validText == "" ? "error_char_limit_upto_30".tr() : widget.validText,
                          style: captionCommon(commonGrey5),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : Container(),
          (_focusNode.hasFocus || _focusOnetime) && widget.validCheckCharacter
              ? Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 6),
                  child: Row(
                    children: [
                      widget.controller!.text.contains(RegExp(r'[A-Z]')) || widget.controller!.text.contains(RegExp(r'[a-z]'))
                          ? SvgPicture.asset("assets/images/ic_16_check_checked.svg")
                          : SvgPicture.asset(
                            "assets/images/ic_16_check.svg",
                            colorFilter: const ColorFilter.mode(pointRed, BlendMode.srcIn),
                          ),
                      const SizedBox(width: 8),
                      Text("error_no_letter".tr(), style: captionCommon(commonGrey5)),
                    ],
                  ),
                ),
              )
              : Container(),
          (_focusNode.hasFocus || _focusOnetime) && widget.validCheckNumber
              ? Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 6),
                  child: Row(
                    children: [
                      widget.controller!.text.contains(RegExp(r'[0-9]'))
                          ? SvgPicture.asset("assets/images/ic_16_check_checked.svg")
                          : SvgPicture.asset(
                            "assets/images/ic_16_check.svg",
                            colorFilter: const ColorFilter.mode(pointRed, BlendMode.srcIn),
                          ),
                      const SizedBox(width: 8),
                      Text("error_no_digit".tr(), style: captionCommon(commonGrey5)),
                    ],
                  ),
                ),
              )
              : Container(),
          (_focusNode.hasFocus || _focusOnetime) && widget.validCheckSpecial
              ? Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 6),
                  child: Row(
                    children: [
                      widget.controller!.text.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))
                          ? SvgPicture.asset("assets/images/ic_16_check_checked.svg")
                          : SvgPicture.asset(
                            "assets/images/ic_16_check.svg",
                            colorFilter: const ColorFilter.mode(pointRed, BlendMode.srcIn),
                          ),
                      const SizedBox(width: 8),
                      Text("error_no_special_char".tr(), style: captionCommon(commonGrey5)),
                    ],
                  ),
                ),
              )
              : Container(),
        ],
      ),
    );
  }

  void focusChange({required BuildContext context, required FocusNode currentFocus, required FocusNode nextFocus}) {
    Future.microtask(() => currentFocus.unfocus()).then((_) => FocusScope.of(context).requestFocus(nextFocus));
  }

  String? checkError(String? v) {
    var error = widget.validator(v);
    final RegExp thaiVowelsAndIntonationMarksRegex = RegExp(r'^[\u0E30-\u0E3A\u0E40-\u0E5B]+$');
    if (v != null && v.isNotEmpty && !thaiVowelsAndIntonationMarksRegex.hasMatch(v)) {
      return 'Please enter valid Thai text'; // not translated, dead code
    }

    if (error == null) {
      setState(() {
        _isError = false;
        if (widget.showVerify) {
          _showVerify = true;
        } else {
          _showVerify = false;
        }
      });
    } else {
      setState(() {
        _isError = true;
        _showVerify = false;
      });
    }
    return error;
  }
}
