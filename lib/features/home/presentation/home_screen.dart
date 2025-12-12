import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moni_pod_web/features/manage_building/domain/unit_model.dart';

import '../../../common_widgets/status_chip.dart';
import '../../../config/style.dart';
import 'base_screen.dart';
import 'home_detail_dialog.dart' hide StatusChip;
import 'map_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<Unit> criticalUnits = [];
  List<Unit> warningUnits = [];
  DateTime _lastUpdatedTime = DateTime.now();
  @override
  void initState() {
    criticalUnits = allUnits.where((unit) => unit.status == 'critical').toList();
    warningUnits = allUnits.where((unit) => unit.status == 'warning').toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topTitle('DashBoard', 'Real-time system overview', DateTime.now(), () {
            setState(() {
              _lastUpdatedTime = DateTime.now();
            });
          }),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    showCriticalUnitsDialog(context, true);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: commonWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border(left: BorderSide(color: Colors.red, width: 12.0, style: BorderStyle.solid)),
                      boxShadow: [
                        BoxShadow(color: commonBlack.withOpacity(0.25), offset: const Offset(0, 2), blurRadius: 4, spreadRadius: 0),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 32),
                              StatusChip(status: 'critical'),
                              Expanded(child: Container()),
                              SvgPicture.asset("assets/images/ic_32_critical.svg", width: 64, fit: BoxFit.fitWidth),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 32),
                              Text(criticalUnits.length.toString(), style: headLineLarge(commonBlack)),
                              Padding(padding: EdgeInsets.only(top: 12), child: Text('  Units', style: bodyTitle(commonGrey5))),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: EdgeInsets.only(left: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Require immediate attention', style: bodyCommon(commonGrey7)),
                                const SizedBox(height: 4),
                                Text('Critical Alert: No movement for over 24 hours.', style: bodyTitle(Colors.red)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showCriticalUnitsDialog(context, false);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: commonWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border(left: BorderSide(color: themeYellow, width: 12.0, style: BorderStyle.solid)),
                      boxShadow: [
                        BoxShadow(color: commonBlack.withOpacity(0.25), offset: const Offset(0, 2), blurRadius: 4, spreadRadius: 0),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 32),
                              StatusChip(status: 'warning'),
                              Expanded(child: Container()),
                              SvgPicture.asset("assets/images/ic_32_warning.svg", width: 64, fit: BoxFit.fitWidth),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 32),
                              Text(warningUnits.length.toString(), style: headLineLarge(commonBlack)),
                              Padding(padding: EdgeInsets.only(top: 12), child: Text('  Units', style: bodyTitle(commonGrey5))),
                            ],
                          ),
                          const SizedBox(height: 16),

                          Padding(
                            padding: EdgeInsets.only(left: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Monitor for potential issues', style: bodyCommon(commonGrey7)),
                                const SizedBox(height: 4),
                                Text('Warning Alert: No movement between 8 and 24 hours.', style: bodyTitle(themeYellow)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: commonGrey2, width: 2)),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: commonGrey1,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/images/ic_24_location.svg", width: 24, fit: BoxFit.fitWidth),
                        const SizedBox(width: 8),
                        Text('Global Activity Map', style: titleMedium(commonBlack)),
                      ],
                    ),
                  ),
                  Expanded(child: Container(alignment: Alignment.center, child: MapSample())),
                  // Expanded(child: Container(alignment: Alignment.center, child: Text('Google Map', style: bodyCommon(commonBlack)))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
