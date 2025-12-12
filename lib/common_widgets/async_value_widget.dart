import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../common/util/common_screen_error.dart';
import '../config/style.dart';
import 'button.dart';

/// this is for async value read from server , but this is showed in simple widget
class EmptyAsyncValueWidget<T> extends ConsumerWidget {
  final dynamic provider;
  final Widget Function(T)? data;

  const EmptyAsyncValueWidget({super.key, required this.provider, this.data});

  Widget emptyWidget(data) => Container();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<T> version = ref.watch(provider);
    return version.when(
        data: data ?? emptyWidget, error: (err, state) => Text("common_error".tr()), loading: () => Text("common_loading".tr()));
  }
}

/// common error full popup 시나리오 추가
class AsyncProviderWidget<T> extends ConsumerWidget {
  const AsyncProviderWidget(
      {super.key, required this.provider, required this.data, this.loading, this.error, this.onTry, this.skipError = false, this
          .loadingFull = true, this.height=0});

  final dynamic provider;
  final Widget Function(T) data;
  final Widget Function()? loading;
  final Widget Function(Object, StackTrace)? error;
  final Function? onTry;
  final bool skipError;
  final bool loadingFull;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(provider, (previous, next) async {
      if (next is AsyncError) {
        //if (!isDialogShowing(context)) {
        //   await GlobalErrorHandler.showCommonErrorFullPopup(
        //     ref: ref,
        //     context: context,
        //     error: next.error,
        //     btnFunction: () async {
        //       if (  onTry != null) await onTry!();
        //       else {
        //         ref.invalidate(provider);
        //        // await ref.read(provider.future);
        //       }
        //     });
        //}
      }
    });
    final AsyncValue<T> value = ref.watch(provider);
    return value.when(
      skipError: skipError,
      data: (value) {
        if (value == null) {
          throw Exception("No Data");
        } else {
          return data(value);
        }
      },
      error: error ?? (e, st) => processError(e,st, context),//const SizedBox.shrink(), // for test
      loading: loading ?? () => loadingWidget(onTry, loadingFull, height), //IndicatorDialog(title: "common_please_wait".tr(), message: ""),
    );
  }
}

class AsyncValueBottomSheetWidget<T> extends ConsumerWidget {
  const AsyncValueBottomSheetWidget(
      {super.key, required this.provider, required this.data, this.loading, this.error, this.onTry, this.skipError = false});

  //final AsyncValue<T> value;
  final dynamic provider;
  final Widget Function(T) data;
  final Widget Function()? loading;
  final Widget Function(Object, StackTrace)? error;
  final Function? onTry;
  final bool skipError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<T> value = ref.watch(provider);
    return value.when(
      skipError: skipError,
      data: data,
      error: error ?? (e, st) => processErrorBottom(e, st, context, onTry ?? ()async {
        ref.invalidate(provider);
        await ref.read(provider.future);
      }), // for test
      loading: loading ?? () => loadingWidget(onTry), //IndicatorDialog(title: "common_please_wait".tr(), message: ""),
    );
  }
}

Widget processErrorBottom(Object error, StackTrace stackTrace, BuildContext context, [Function? onTry]) {
  String errMsg = getCommonErrorTitleMsg(error);
  String subMsg = getCommonErrorSubMsg(error);
  return SizedBox(
         // height: MediaQuery.of(context).size.height / 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Expanded(child: Container()),
            const SizedBox(height: 36),
            Image.asset("assets/images/img_delay_white.png", width: 120,height: 120,),
            const SizedBox(height: 11),
            Container(margin: const EdgeInsets.symmetric(horizontal: 46), child: Text(subMsg, textAlign: TextAlign.center, style: bodyCommon
              (commonBlack))),
            const SizedBox(height: 20),
            //Expanded(child: Container()),
            onTry != null
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Button(
                label: "common_try_again".tr(),
                backgroundColor: Theme.of(context).primaryColor,
                style: titlePoint(commonWhite),
                borderColor: Theme
                    .of(context)
                    .primaryColor,
                onClick: () async {
                  await onTry();
                },
              ),
              //);
              //}
            )
                : Container(),
            const SizedBox(height: 20),
          ],
        ),
      );
}

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget(
      {super.key, required this.value, required this.data, this.loading, this.error, this.onTry, this.skipError = false});

  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget Function()? loading;
  final Widget Function(Object, StackTrace)? error;
  final Function? onTry;
  final bool skipError;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipError: skipError,
      data: data,
      error: error ?? (e, st) => processError(e, st, context, onTry), // for test
      loading: loading ?? () => loadingWidget(onTry), //IndicatorDialog(title: "common_please_wait".tr(), message: ""),
    );
  }
}

class AsyncValueSmallWidget<T> extends StatelessWidget {
  const AsyncValueSmallWidget(
      {super.key, required this.value, required this.data, this.loading, this.error, this.skipError = false, this.onTry});

  final AsyncValue<T> value;
  final Widget Function(T) data;
  final Widget Function()? loading;
  final Widget Function(Object, StackTrace)? error;
  final bool skipError;
  final Function? onTry;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipError: skipError,
      data: data,
      error: (e, st) => processError(e, st, context, onTry), //)Text("Error", style: bodyCommon(commonBlack)), // for test
      loading: () => Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Lottie.asset('assets/lotti/loading_dots.json', width: 50, height: 50, frameRate: FrameRate.composition),
      ), //IndicatorDialog(title: "common_please_wait".tr(), message: ""),
    );
  }
}

Widget loadingWidget(Function? onTry, [bool loadingFull=true, double height=0.0]) {
  if(!loadingFull && (height > 0)) {
    return SizedBox(
      height:height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Expanded(child: Container()),
            //Image.asset("assets/images/img_delay.png"),
            Center(child: Lottie.asset('assets/lotti/graphical_loading.json', width: 110, height: 110, frameRate: FrameRate
                .composition)),
            const SizedBox(height: 12),
            // Text("Service connection is delayed.", style: titleMedium(commonBlack)),
            //Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

return Scaffold(
    backgroundColor: commonWhite,
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(child: Container()),
          //Image.asset("assets/images/img_delay.png"),
          Center(child: Lottie.asset('assets/lotti/graphical_loading.json', width: 110, height: 110, frameRate: FrameRate.composition)),
          const SizedBox(height: 12),
          // Text("Service connection is delayed.", style: titleMedium(commonBlack)),
          Expanded(child: Container()),
        ],
      ),
    ));
}

Widget processError(Object error, StackTrace stackTrace, BuildContext context, [Function? onTry]) {
  String errMsg = getCommonErrorTitleMsg(error);
  String subMsg = getCommonErrorSubMsg(error);
  return Scaffold(
      backgroundColor: commonWhite,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          Lottie.asset('assets/lotti/graphical_loading.json', width: 110, height: 110, frameRate: FrameRate.composition),
          const SizedBox(height: 11),
          Container(margin: const EdgeInsets.symmetric(horizontal: 46), child: Text(subMsg, style: bodyCommon(commonWhite))),
          Expanded(child: Container()),
          //Consumer(builder: (context, ref, child) {
          //          return
          onTry != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Button(
                    label: "common_try_again".tr(),
                    backgroundColor: Theme.of(context).primaryColor,
                    style: titlePoint(commonWhite),
                    borderColor: Theme
                        .of(context)
                        .primaryColor,
                    onClick: () async {
                      await onTry();
                    },
                  ),
                  //);
                  //}
                )
              : Container(),
          const SizedBox(height: 16),
        ],
      ));
}

class ScaffoldAsyncValueWidget<T> extends StatelessWidget {
  const ScaffoldAsyncValueWidget({required this.value, required this.data, this.appBar, this.error});

  final AsyncValue<T> value;
  final Widget Function(T) data;
  final AppBar? appBar;
  final Widget Function(Object, StackTrace)? error;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: error ??
          (e, st) => Scaffold(
              appBar: appBar ??
                  AppBar(
                    scrolledUnderElevation: 0,
                    backgroundColor: Colors.transparent,
                  ),
              //body: Center(child: GlobalDialogX(e.toString())),
              body: Container(
                color: Colors.transparent,
              )),
      loading: () => Scaffold(
        appBar: appBar ?? AppBar(),
        body: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)),
      ),
    );
  }
}

bool errorPopup = false;


