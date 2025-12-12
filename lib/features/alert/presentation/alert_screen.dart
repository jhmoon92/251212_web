import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moni_pod_web/common_widgets/status_chip.dart';
import 'package:moni_pod_web/features/home/presentation/base_screen.dart';

import '../../../common_widgets/custom_drop_down.dart';
import '../../../config/style.dart';
import '../../manage_building/domain/unit_model.dart';

class AlertData {
  final AlertLevel level;
  final String title;
  final String time;
  final String message;
  final String location;
  final String unit;
  final bool isNew;

  const AlertData({
    required this.level,
    required this.title,
    required this.time,
    required this.message,
    required this.location,
    required this.unit,
    this.isNew = false,
  });
}

class AlertScreen extends ConsumerStatefulWidget {
  const AlertScreen({super.key});

  @override
  ConsumerState<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends ConsumerState<AlertScreen> {
  String _selectedFilter = 'All';
  List<AlertData> _filteredAlerts = [];
  AlertLevel? _currentFilter;
  DateTime _lastUpdatedTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _filteredAlerts = alertList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              topTitle('System Alerts', 'Real-time notifications and events', _lastUpdatedTime, () {
                setState(() {
                  _lastUpdatedTime = DateTime.now();
                });
              }),
              const SizedBox(height: 24),
              _buildFiltersAndCategories(),
              const SizedBox(height: 16),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(top: 8),
            itemCount: _filteredAlerts.length,
            itemBuilder: (context, index) {
              final alert = _filteredAlerts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: CustomAlertItem(
                  level: alert.level,
                  title: alert.title,
                  time: alert.time,
                  message: alert.message,
                  location: alert.location,
                  unit: alert.unit,
                  isNew: alert.isNew,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFiltersAndCategories() {
    // Breakpoint 설정 (예: 600px 미만이면 줄 바꿈)
    const double breakpoint = 600.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > breakpoint) {
          // 1. 넓은 화면: Row 사용 (Spacer를 이용해 중간을 비움)
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomDropdown(
                onChanged: (String value) {
                  setState(() {
                    _filteredAlerts = alertList.where((alert) => alert.location == value).toList();
                  });
                },
              ),
              const Spacer(), // <--- Spacer 사용 가능
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    _buildFilterButton('All', _selectedFilter == 'All'),
                    _buildFilterButton('Critical', _selectedFilter == 'Critical'),
                    _buildFilterButton('Warning', _selectedFilter == 'Warning'),
                  ],
                ),
              ),
            ],
          );
        } else {
          // 2. 좁은 화면: Wrap 사용 (자동 줄 바꿈)
          return Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CustomDropdown(
                onChanged: (String value) {
                  setState(() {
                    _filteredAlerts = alertList.where((alert) => alert.location == value).toList();
                  });
                },
              ), // 좁은 화면에서는 Spacer 대신 다음 줄로 넘어감
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 2))],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFilterButton('All', _selectedFilter == 'All'),
                    _buildFilterButton('Critical', _selectedFilter == 'Critical'),
                    _buildFilterButton('Warning', _selectedFilter == 'Warning'),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildFilterButton(String text, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = text;
          if (text == 'Critical') {
            _currentFilter = AlertLevel.critical;
            _filteredAlerts = alertList.where((alert) => alert.level == AlertLevel.critical).toList();
          } else if (text == 'Warning') {
            _currentFilter = AlertLevel.warning;
            _filteredAlerts = alertList.where((alert) => alert.level == AlertLevel.warning).toList();
          } else {
            _currentFilter = AlertLevel.normal;
            _filteredAlerts = alertList;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? themeYellow : Colors.white,
          borderRadius: BorderRadius.horizontal(
            left: text == 'All' ? const Radius.circular(4) : Radius.zero,
            right: text == 'Warning' ? const Radius.circular(4) : Radius.zero,
          ),
        ),
        child: Text(text, style: bodyTitle(isSelected ? commonWhite : commonGrey6)),
      ),
    );
  }
}

enum AlertLevel { critical, warning, normal }

class CustomAlertItem extends StatelessWidget {
  final AlertLevel level;
  final String title;
  final String time;
  final String message;
  final String location;
  final String unit;
  final bool isNew;

  const CustomAlertItem({
    super.key,
    required this.level,
    required this.title,
    required this.time,
    required this.message,
    required this.location,
    required this.unit,
    this.isNew = false,
  });

  Color get color =>
      level == AlertLevel.critical
          ? Colors.red
          : level == AlertLevel.warning
          ? themeYellow
          : commonGrey2;
  String get levelText =>
      level == AlertLevel.critical
          ? 'critical'
          : level == AlertLevel.warning
          ? 'warning'
          : 'normal';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: color, width: 12.0)),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [BoxShadow(color: commonBlack.withOpacity(0.2), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          levelText == 'normal'
              ? const SizedBox(width: 48)
              : Padding(
                padding: const EdgeInsets.only(top: 14),
                child: SvgPicture.asset(
                  levelText == 'critical' ? 'assets/images/ic_32_critical.svg' : 'assets/images/ic_32_warning.svg',
                  width: 48,
                  fit: BoxFit.fitWidth,
                ),
              ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    StatusChip(status: levelText),
                    const SizedBox(width: 8),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/ic_24_time.svg",
                            width: 16,
                            fit: BoxFit.fitWidth,
                            colorFilter: ColorFilter.mode(commonGrey5, BlendMode.srcIn),
                          ),
                          const SizedBox(width: 2),
                          Text(time, style: captionCommon(commonGrey5)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (isNew)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(4)),
                        child: Text('NEW', style: captionTitle(themeBlue)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(title, style: titleMedium(commonBlack)),
                const SizedBox(height: 12),
                Text(message, style: bodyCommon(commonGrey5)),
                const SizedBox(height: 8),
                Row(children: [_buildTag(location, true), const SizedBox(width: 8), _buildTag(unit, false)]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, bool isBuilding) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: commonGrey2, borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            isBuilding ? "assets/images/ic_24_office.svg" : "assets/images/ic_24_unit.svg",
            width: 16,
            fit: BoxFit.fitWidth,
            colorFilter: ColorFilter.mode(commonGrey5, BlendMode.srcIn),
          ),
          const SizedBox(width: 4),
          Text(text, style: captionCommon(commonGrey5)),
        ],
      ),
    );
  }
}
