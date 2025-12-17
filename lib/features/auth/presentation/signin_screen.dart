import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:moni_pod_web/common_widgets/button.dart';
import 'package:moni_pod_web/config/style.dart';
import 'package:moni_pod_web/features/account/presentation/account_list_screen.dart';
import 'package:moni_pod_web/features/home/presentation/base_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../common/util/validators.dart';
import '../../../common_widgets/input_box.dart';
import '../../../router.dart';
import '../auth_provider.dart';

class SignInScreen extends ConsumerStatefulWidget {
  final String apiBaseUrl;

  const SignInScreen({super.key, required this.apiBaseUrl});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> with EmailAndPasswordValidators {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _focusNode = FocusScopeNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    // _emailController.text = "jhmoon@humax-networks.com";
    // _passwordController.text = "\$8289501";
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _focusNode.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<bool> onSignInPressed() async {
    setState(() {
      _emailError = _emailController.text.isEmpty ? 'Enter your ID, Please.' : null;
      _passwordError = _passwordController.text.isEmpty ? 'Please enter your password correctly.' : null;
    });
    return true;

    // if (_emailError == null && _passwordError == null) {
    //   bool isSuccess = await ref.read(authRepositoryProvider).signIn(_emailController.text, _passwordController.text);
    //
    //   //TODO: 로그인 API 요청 처리
    //   debugPrint('로그인 요청: ${_emailController.text}');
    //   return isSuccess;
    // }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset("assets/images/Moni_top_logo_signiture.svg"),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text("Moni Residence Management System", style: captionCommon(commonGrey3)),
            ),
          ],
        ),
        backgroundColor: commonGrey7,
        // actions: [Padding(padding: const EdgeInsets.only(right: 16), child: Icon(Icons.notifications_none, color: Colors.white))],
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return GestureDetector(
            onTap: () {
              _focusNode.unfocus();
            },
            child: FocusScope(
              node: _focusNode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/images/Moni_logo_signiture.svg"),
                  const SizedBox(height: 48),
                  Center(
                    child: SizedBox(
                      width: 384,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("E-mail ", style: titleCommon(commonBlack)),
                          const SizedBox(height: 8),
                          InputBox(
                            controller: _emailController,
                            focus: _emailFocus,
                            textType: "email",
                            label: "Enter your email",
                            // initialText: "hjkang1@humax-networks.com",
                            // initialText: "jylee7@humax-networks.com",
                            // initialText: "mon5315@hanmail.net",
                            // initialText: "sense.demo2@gmail.com",
                            // initialText: "sp.jylee7@gmail.com",
                            isErrorText: true,
                            onSaved: (val) {},
                            validator: (email) {
                              return emailErrorText(email ?? '');
                            },
                            onChanged: (email) {
                              if (mounted)
                                setState(() {
                                  // if (emailErrorText(email ?? '') == null) {
                                  //   _emailSubmit = true;
                                  // } else {
                                  //   _emailSubmit = false;
                                  // }
                                });
                            },
                            onEditingComplete: () {
                              _focusNode.requestFocus(_passwordFocus);
                            },
                            textStyle: bodyCommon(commonBlack),
                          ),
                          // TextField(
                          //   controller: _emailController,
                          //   style: const TextStyle(color: Colors.black), // 입력될 글씨 색상
                          //   decoration: InputDecoration(
                          //     hintText: 'ID (Email)',
                          //     hintStyle: const TextStyle(color: Colors.black54), // 힌트 텍스트 색상
                          //     errorText: _emailError,
                          //     border: const OutlineInputBorder(
                          //       borderSide: BorderSide(color: commonGrey2), // 기본 테두리 색상
                          //     ),
                          //     enabledBorder: const OutlineInputBorder(
                          //       // 활성화(입력 가능) 상태의 테두리 색상
                          //       borderSide: BorderSide(color: commonGrey2),
                          //     ),
                          //     focusedBorder: const OutlineInputBorder(
                          //       // 포커스(선택) 상태의 테두리 색상
                          //       borderSide: BorderSide(color: commonGrey2),
                          //     ),
                          //     errorBorder: OutlineInputBorder(
                          //       // 에러 상태의 테두리 색상
                          //       borderSide: BorderSide(color: _emailError != null ? Colors.red : commonGrey2), // 에러가 없으면 회색, 있으면 빨간색
                          //     ),
                          //     focusedErrorBorder: OutlineInputBorder(
                          //       // 에러이면서 포커스 상태의 테두리 색상
                          //       borderSide: BorderSide(color: _emailError != null ? Colors.red : commonGrey2), // 에러가 없으면 회색, 있으면 빨간색
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 24),
                          Text("Password", style: titleCommon(commonBlack)),
                          const SizedBox(height: 8),

                          InputBox(
                            controller: _passwordController,
                            focus: _passwordFocus,
                            textType: "password",
                            label: "Enter your password",
                            // initialText: "a359738359738!",
                            // initialText: "#52471292",
                            // initialText: "!27106915",
                            // initialText: "@test12345",
                            // initialText: "*51518981",
                            onSaved: (val) {},
                            validator: (val) {
                              return null;
                            },
                            onChanged: (pwd) {
                              if (mounted) setState(() {});
                            },
                            onEditingComplete: () {
                              // _focusNode.unfocus();
                            },
                            textStyle: bodyCommon(commonBlack),
                          ),
                          //
                          //
                          // TextField(
                          //   controller: _passwordController,
                          //   obscureText: true,
                          //   style: const TextStyle(color: Colors.black), // 입력될 글씨 색상
                          //   decoration: InputDecoration(
                          //     hintText: 'Password',
                          //     hintStyle: const TextStyle(color: Colors.black54), // 힌트 텍스트 색상 (회색보다 조금 진한 검은색 계열)
                          //     errorText: _passwordError,
                          //     border: const OutlineInputBorder(
                          //       borderSide: BorderSide(color: commonGrey2), // 기본 테두리 색상
                          //     ),
                          //     enabledBorder: const OutlineInputBorder(
                          //       // 활성화(입력 가능) 상태의 테두리 색상
                          //       borderSide: BorderSide(color: commonGrey2),
                          //     ),
                          //     focusedBorder: const OutlineInputBorder(
                          //       // 포커스(선택) 상태의 테두리 색상
                          //       borderSide: BorderSide(color: commonGrey2),
                          //     ),
                          //     errorBorder: OutlineInputBorder(
                          //       // 에러 상태의 테두리 색상
                          //       borderSide: BorderSide(color: _passwordError != null ? Colors.red : commonGrey2), // 에러가 없으면 회색, 있으면 빨간색
                          //     ),
                          //     focusedErrorBorder: OutlineInputBorder(
                          //       // 에러이면서 포커스 상태의 테두리 색상
                          //       borderSide: BorderSide(color: _passwordError != null ? Colors.red : commonGrey2), // 에러가 없으면 회색, 있으면 빨간색
                          //     ),
                          //     suffixIcon: const Icon(Icons.visibility_off, color: Colors.black54), // 아이콘 색상도 조절 (선택 사항)
                          //   ),
                          // ),
                          const SizedBox(height: 48),
                          // CheckboxListTile(
                          //   value: _termsAccepted,
                          //   contentPadding: EdgeInsets.zero,
                          //   controlAffinity: ListTileControlAffinity.leading,
                          //   title: const Text.rich(
                          //     TextSpan(
                          //       text: 'I accept the ',
                          //       children: [
                          //         TextSpan(
                          //           text: 'Terms and Conditions',
                          //           style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _termsAccepted = value ?? false;
                          //     });
                          //   },
                          // ),
                          Button(
                            label: 'Sign in',
                            onClick: () {
                              context.go(AppRoute.home.path);
                            },
                            backgroundColor: themeYellow,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
