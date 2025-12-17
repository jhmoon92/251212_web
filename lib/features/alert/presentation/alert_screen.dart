import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moni_pod_web/common_widgets/status_chip.dart';
import 'package:moni_pod_web/features/home/presentation/base_screen.dart';

import '../../../common_widgets/custom_drop_down.dart';
import '../../../common_widgets/select_status_chip.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              topTitle('System Alerts', 'Real-time notifications and events', _lastUpdatedTime, () {
                setState(() {
                  _lastUpdatedTime = DateTime.now();
                });
              }),
              _buildFiltersAndCategories(),
              const SizedBox(height: 16),
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: commonWhite),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _filteredAlerts.length,
                itemBuilder: (context, index) {
                  final alert = _filteredAlerts[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                    child: Container(
                      margin: EdgeInsets.only(top: index == 0 ? 14 : 0, bottom: index == _filteredAlerts.length - 1 ? 14 : 0),
                      child: CustomAlertItem(
                        level: alert.level,
                        title: alert.title,
                        time: alert.time,
                        message: alert.message,
                        location: alert.location,
                        unit: alert.unit,
                        isNew: alert.isNew,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersAndCategories() {
    // Breakpoint 설정 (예: 600px 미만이면 줄 바꿈)
    const double breakpoint = 900.0;

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
              Row(
                children: [
                  SelectStatusChip(
                    status: 'all',
                    isSelect: _selectedFilter == 'All',
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'All';
                        _currentFilter = AlertLevel.normal;
                        _filteredAlerts = alertList;
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
                        _currentFilter = AlertLevel.critical;
                        _filteredAlerts = alertList.where((alert) => alert.level == AlertLevel.critical).toList();
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
                        _currentFilter = AlertLevel.warning;
                        _filteredAlerts = alertList.where((alert) => alert.level == AlertLevel.warning).toList();
                      });
                    },
                  ),
                ],
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
              Row(
                children: [
                  SelectStatusChip(
                    status: 'all',
                    isSelect: _selectedFilter == 'All',
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'All';
                        _currentFilter = AlertLevel.normal;
                        _filteredAlerts = alertList;
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
                        _currentFilter = AlertLevel.critical;
                        _filteredAlerts = alertList.where((alert) => alert.level == AlertLevel.critical).toList();
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
                        _currentFilter = AlertLevel.warning;
                        _filteredAlerts = alertList.where((alert) => alert.level == AlertLevel.warning).toList();
                      });
                    },
                  ),
                ],
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
        width: 132,
        padding: EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: isSelected ? themeYellow : Colors.white, borderRadius: BorderRadius.circular(4)),
        child: Text(text, style: bodyTitle(isSelected ? commonWhite : commonGrey5)),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 84, width: 8, color: isNew ? newBlue : commonGrey3),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusChip(status: levelText),
              const SizedBox(height: 10),
              Text(message, style: titleSmall(commonBlack)),
              const SizedBox(height: 10),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/ic_24_time.svg",
                    width: 16,
                    fit: BoxFit.fitWidth,
                    colorFilter: ColorFilter.mode(commonGrey5, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 2),
                  Text(time, style: captionCommon(commonGrey5)),
                  const SizedBox(width: 16),
                  _buildTag(location, true),
                  const SizedBox(width: 16),
                  _buildTag(unit, false),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, bool isBuilding) {
    return Row(
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
    );
  }
}
