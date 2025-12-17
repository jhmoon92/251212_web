import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moni_pod_web/features/manage_building/domain/unit_model.dart';

import '../../../common_widgets/select_status_chip.dart';
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
  String _selectedFilter = 'All';
  @override
  void initState() {
    criticalUnits = allUnits.where((unit) => unit.status == 'critical').toList();
    warningUnits = allUnits.where((unit) => unit.status == 'warning').toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topTitle('DashBoard', 'Real-time system overview', DateTime.now(), () {
            setState(() {
              _lastUpdatedTime = DateTime.now();
            });
          }),
          Text('Status', style: titleMedium(commonBlack)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    showCriticalUnitsDialog(context, true);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: commonWhite,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: commonGrey2, width: 1),
                      boxShadow: [
                        BoxShadow(color: commonBlack.withOpacity(0.25), offset: const Offset(0, 4), blurRadius: 4, spreadRadius: 0),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StatusChip(status: 'critical'),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(criticalUnits.length.toString(), style: headLineLarge(commonBlack)),
                              const SizedBox(width: 8),
                              Padding(padding: const EdgeInsets.only(top: 12), child: Text('Units', style: bodyTitle(commonGrey5))),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text('Require immediate attention', style: bodyCommon(commonGrey7)),
                          const SizedBox(height: 16),
                          Text('Critical Alert: No movement for over 24 hours.', style: bodyTitle(Colors.red)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showCriticalUnitsDialog(context, false);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: commonWhite,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: commonGrey2, width: 1),
                      boxShadow: [
                        BoxShadow(color: commonBlack.withOpacity(0.25), offset: const Offset(0, 4), blurRadius: 4, spreadRadius: 0),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StatusChip(status: 'warning'),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(warningUnits.length.toString(), style: headLineLarge(commonBlack)),
                              const SizedBox(width: 8),
                              Padding(padding: const EdgeInsets.only(top: 12), child: Text('Units', style: bodyTitle(commonGrey5))),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text('Monitor for potential issues', style: bodyCommon(commonGrey7)),
                          const SizedBox(height: 16),
                          Text('Warning Alert: No movement between 8 and 24 hours.', style: bodyTitle(themeYellow)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Global Activity Map', style: titleMedium(commonBlack)),
                    Expanded(child: SizedBox()),
                    Row(
                      children: [
                        SelectStatusChip(
                          status: 'all',
                          isSelect: _selectedFilter == 'All',
                          onTap: () {
                            setState(() {
                              _selectedFilter = 'All';

                            });
                          },
                        ),
                        const SizedBox(width: 12),
                        SelectStatusChip(
                          status: 'critical',
                          isSelect: _selectedFilter == 'Critical',
                          onTap: () {
                            setState(() {
                              _selectedFilter = 'Critical';
                            });
                          },
                        ),
                        const SizedBox(width: 12),
                        SelectStatusChip(
                          status: 'warning',
                          isSelect: _selectedFilter == 'Warning',
                          onTap: () {
                            setState(() {
                              _selectedFilter = 'Warning';
                            });
                          },
                        ),
                        const SizedBox(width: 12),
                        SelectStatusChip(
                          status: 'normal',
                          isSelect: _selectedFilter == 'Normal',
                          onTap: () {
                            setState(() {
                              _selectedFilter = 'Normal';
                            });
                          },
                        ),
                        const SizedBox(width: 12),
                        SelectStatusChip(
                          status: 'offline',
                          isSelect: _selectedFilter == 'Offline',
                          onTap: () {
                            setState(() {
                              _selectedFilter = 'Offline';
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: commonGrey2, width: 1)),
                    child: ClipRRect(borderRadius: BorderRadius.circular(8), child: GoogleMapSearchScreen()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
