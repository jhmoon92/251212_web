import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moni_pod_web/features/manage_building/presentation/building_detail_screen.dart';

import '../../../common/util/util.dart';
import '../../../common_widgets/button.dart';
import '../../../common_widgets/input_box.dart';
import '../../../config/style.dart';
import '../domain/unit_model.dart';

class UnitDetailScreen extends ConsumerStatefulWidget {
  const UnitDetailScreen({required this.unitInfo, super.key});

  final Unit unitInfo;

  @override
  ConsumerState<UnitDetailScreen> createState() => _UnitDetailScreenState();
}

class _UnitDetailScreenState extends ConsumerState<UnitDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;
          const double minContentWidth = 1000.0;
          const double maxTotalPadding = 400.0;
          double totalAvailableMargin = screenWidth - minContentWidth;
          if (totalAvailableMargin > maxTotalPadding) {
            totalAvailableMargin = maxTotalPadding;
          } else if (totalAvailableMargin < 0) {
            totalAvailableMargin = 0;
          }
          final double horizontalPadding = totalAvailableMargin / 2;
          const double breakpoint = 1000.0;
          final bool isNarrowScreen = screenWidth < breakpoint;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                isNarrowScreen
                    ? Column(
                      children: [_RightPanel(unitInfo: widget.unitInfo), const SizedBox(height: 16), _LeftPanel(unitInfo: widget.unitInfo)],
                    )
                    : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _LeftPanel(unitInfo: widget.unitInfo)),
                        const SizedBox(width: 16),
                        Expanded(flex: 7, child: _RightPanel(unitInfo: widget.unitInfo)),
                      ],
                    ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                context.pop();
              },
              child: const Icon(Icons.arrow_back, size: 24, color: commonBlack),
            ),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.unitInfo.number}', style: headLineSmall(commonBlack)),
                const SizedBox(height: 4),
                Text('123 Maple Ave, Springfield', style: bodyCommon(commonGrey6)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _LeftPanel extends StatelessWidget {
  const _LeftPanel({required this.unitInfo});

  final Unit unitInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ResidentCard(unitInfo: unitInfo),
        const SizedBox(height: 16),
        _ManagerCard(unitInfo: unitInfo),
        const SizedBox(height: 16),
        InstalledDeviceCard(devices: unitInfo.devices),
      ],
    );
  }
}

class _ManagerCard extends StatelessWidget {
  const _ManagerCard({required this.unitInfo});

  final Unit unitInfo;

  Widget _buildInfoRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key, style: bodyCommon(commonGrey7)),
          Row(
            children: [
              if (key == 'Contact')
                SvgPicture.asset(
                  'assets/images/ic_32_call.svg',
                  width: 20,
                  fit: BoxFit.fitWidth,
                  colorFilter: ColorFilter.mode(commonBlack, BlendMode.srcIn),
                ),
              Text(value, style: bodyCommon(commonBlack)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: commonWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: commonGrey2, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.manage_accounts, size: 24, color: commonGrey6),
              SizedBox(width: 8),
              Text('Manager', style: titleLarge(commonBlack)),
              Expanded(child: Container()),
              InkWell(
                onTap: () {}, // 취소 시 false 전달
                child: const Icon(Icons.edit_outlined, color: commonGrey5, size: 20),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1, color: commonGrey2),
          _buildInfoRow('Name', unitInfo.manager.name),
          const SizedBox(height: 8),
          _buildInfoRow('Account', unitInfo.manager.account),
          const SizedBox(height: 8),
          _buildInfoRow('Contact', unitInfo.manager.contact),
        ],
      ),
    );
  }
}

class _ResidentCard extends StatefulWidget {
  const _ResidentCard({required this.unitInfo});

  final Unit unitInfo;

  @override
  State<_ResidentCard> createState() => _ResidentCardState();
}

class _ResidentCardState extends State<_ResidentCard> {
  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bornController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _genderValue = 'Other';

  final List<String> _genderOptions = ['Female', 'Male', 'Other'];

  @override
  void initState() {
    _nameController.text = widget.unitInfo.resident.name;
    _bornController.text = widget.unitInfo.resident.born.toString();
    _phoneController.text = widget.unitInfo.resident.phone;
    _genderValue = widget.unitInfo.resident.gender;
    super.initState();
  }

  void _toggleEdit(bool save) {
    setState(() {
      if (_isEditing) {
        if (!save) {
          // 취소: 원래 값으로 되돌림
          _nameController.text = widget.unitInfo.resident.name;
          _bornController.text = widget.unitInfo.resident.born.toString();
          _phoneController.text = widget.unitInfo.resident.phone;
          _genderValue = widget.unitInfo.resident.gender;
        } else {
          // // 저장: 현재 값을 초기값으로 업데이트
          // _initialName = _nameController.text;
          // _initialBorn = _bornController.text;
          // _initialPhone = _phoneController.text;
          // _initialGender = _genderValue;
        }
      }
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: commonWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: commonGrey2, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/images/ic_24_person.svg', colorFilter: ColorFilter.mode(commonGrey6, BlendMode.srcIn)),
              const SizedBox(width: 8),
              Text('Resident', style: titleLarge(commonBlack)),
              Expanded(child: Container()),
              !_isEditing
                  ? InkWell(onTap: () => _toggleEdit(false), child: const Icon(Icons.edit_outlined, color: commonGrey5, size: 20))
                  : Row(
                    children: [
                      InkWell(onTap: () => _toggleEdit(false), child: const Icon(Icons.close, color: Colors.red, size: 24)),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () => _toggleEdit(true), // 저장 시 true 전달
                        child: const Icon(Icons.check, color: themeGreen, size: 24),
                      ),
                    ],
                  ),
            ],
          ),
          const Divider(height: 24, thickness: 1, color: commonGrey2),
          _isEditing ? _buildEditMode() : _buildReadMode(),
        ],
      ),
    );
  }

  Widget _buildReadMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReadRow('Name', _nameController.text),
        const SizedBox(height: 8),
        _buildReadRow('Born', _bornController.text),
        const SizedBox(height: 8),
        _buildReadRow('Gender', _genderValue),
        const SizedBox(height: 8),
        _buildReadRow('Phone', _phoneController.text),
      ],
    );
  }

  Widget _buildEditMode() {
    return Column(
      children: [
        _buildEditField('Name', _nameController),
        _buildEditField('Born', _bornController),
        _buildEditDropdown('Gender', _genderOptions, _genderValue, (String? newValue) {
          if (newValue != null) {
            setState(() => _genderValue = newValue);
          }
        }),
        _buildEditField('Phone', _phoneController),
      ],
    );
  }

  Widget _buildReadRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(key, style: bodyCommon(commonGrey7)), Text(value, style: bodyCommon(commonBlack))],
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: bodyCommon(commonGrey7)),
        const SizedBox(height: 4),
        InputBox(
          controller: controller,
          label: label,
          maxLength: 32,
          isErrorText: true,
          onSaved: (val) {},
          textStyle: bodyCommon(commonBlack),
          textType: 'normal',
          validator: (value) {
            return null;
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildEditDropdown(String label, List<String> options, String currentValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: bodyCommon(commonGrey7)),
        const SizedBox(height: 4),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(border: Border.all(color: commonGrey4, width: 1), borderRadius: BorderRadius.circular(4)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: currentValue,
              icon: const Icon(Icons.keyboard_arrow_down, color: commonGrey7),
              style: bodyCommon(commonBlack),
              onChanged: onChanged,
              items:
                  options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value, style: bodyCommon(commonBlack)));
                  }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class InstalledDeviceCard extends StatelessWidget {
  const InstalledDeviceCard({required this.devices, super.key});

  final List<InstalledDevice> devices;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: commonWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: commonGrey2, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              SvgPicture.asset('assets/images/ic_24_pod.svg', colorFilter: ColorFilter.mode(commonGrey6, BlendMode.srcIn)),
              const SizedBox(width: 8),
              Text('Installed Devices', style: titleLarge(commonBlack)),
            ],
          ),
          const Divider(height: 24, thickness: 1, color: commonGrey2),
          ListView.builder(
            shrinkWrap: true,
            itemCount: devices.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(bottom: index == devices.length - 1 ? 0 : 12),
                child: _DeviceListItem(devices: devices[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DeviceListItem extends StatelessWidget {
  const _DeviceListItem({required this.devices});

  final InstalledDevice devices;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: commonGrey1.withOpacity(0.7), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 이름 및 ONLINE/OFFLINE 태그
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(devices.name, style: bodyCommon(commonBlack)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: devices.status == 'ONLINE' ? themeGreen.withOpacity(0.1) : commonGrey4.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  devices.status == 'ONLINE' ? 'ONLINE' : 'OFFLINE',
                  style: captionPoint(devices.status == 'ONLINE' ? themeGreen : commonGrey5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          Text(devices.serialNumber, style: captionCommon(commonGrey7)),

          const Divider(height: 20, thickness: 0.3, color: commonGrey4),

          // 3. 설치 정보
          Row(
            children: [
              Text('Installed by', style: captionCommon(commonGrey7)),
              const SizedBox(width: 4),
              Text(devices.installer, style: captionCommon(themeBlue)),
              const Spacer(),
              Text(DateFormat('yyyy.MM.dd. HH:mm').format(devices.installationDate), style: captionCommon(commonGrey7)),
            ],
          ),
        ],
      ),
    );
  }
}

class _RightPanel extends StatelessWidget {
  const _RightPanel({required this.unitInfo});

  final Unit unitInfo;

  @override
  Widget build(BuildContext context) {
    // 👈 Expanded 제거
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_StatusCard(unitInfo), SizedBox(height: 16), _CareLogCard()]);
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard(this.unit);

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            unit.status == 'critical'
                ? Colors.red.withOpacity(0.1)
                : unit.status == 'warning'
                ? themeYellow.withOpacity(0.1)
                : unit.status == 'offline'
                ? commonGrey2
                : pointGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              unit.status == 'critical'
                  ? Colors.red
                  : unit.status == 'warning'
                  ? themeYellow
                  : unit.status == 'offline'
                  ? commonGrey5
                  : pointGreen,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            unit.status == 'critical'
                ? 'assets/images/ic_32_critical.svg'
                : unit.status == 'warning'
                ? 'assets/images/ic_32_warning.svg'
                : unit.status == 'offline'
                ? 'assets/images/ic_48_wi-fi_error.svg'
                : 'assets/images/ic_48_wi-fi.svg',
            width: 48,
            fit: BoxFit.fitWidth,
            colorFilter: unit.status == 'critical' || unit.status == 'warning' // 이 부분을 수정했습니다.
                ? null // 'critical' 또는 'warning'일 때는 ColorFilter를 적용하지 않음
                : ColorFilter.mode(
              unit.status == 'offline'
                  ? commonGrey5
                  : pointGreen,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            unit.status.toUpperCase(),
            style: headLineSmall(
              unit.status == 'critical'
                  ? Colors.red
                  : unit.status == 'warning'
                  ? themeYellow
                  : unit.status == 'offline'
                  ? commonGrey5
                  : pointGreen,
            ),
          ),
          Expanded(child: Container()),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color:
                  unit.status == 'critical'
                      ? Colors.red
                      : unit.status == 'warning'
                      ? themeYellow
                      : unit.status == 'offline'
                      ? commonGrey4
                      : themeGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                SvgPicture.asset('assets/images/ic_24_motion.svg', colorFilter: ColorFilter.mode(commonWhite, BlendMode.srcIn)),
                Text('Last Motion : ${formatMinutesToTimeAgo(unit.lastMotion)}', style: bodyTitle(commonWhite)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CareLogCard extends StatelessWidget {
  const _CareLogCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: commonWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: commonGrey2, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/images/ic_24_log.svg', colorFilter: ColorFilter.mode(commonGrey6, BlendMode.srcIn)),
              const SizedBox(width: 8),
              Text('Care Log', style: titleLarge(commonBlack)),
            ],
          ),
          const Divider(height: 24, thickness: 1, color: commonGrey2),

          // 👈 ListView 수정: Expanded 대신 shrinkWrap 사용
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // 외부 스크롤 사용
            padding: EdgeInsets.zero,
            children: const [
              _CareLogItem(user: 'John Doe', message: 'Routine checkup call completed.', time: '2023-10-25 14:00'),
              _CareLogItem(
                type: 'System',
                message: 'Monthly activity report generated.',
                fileName: 'oct_activity_report.pdf',
                time: '2023-10-24 16:30',
              ),
              _CareLogItem(
                user: 'Sarah Conner',
                message: 'Exported sensor raw data for analysis.',
                fileName: 'sensor_data_log.csv',
                time: '2023-10-22 09:13',
              ),
              _CareLogItem(
                user: 'John Doe',
                message: 'Maintenance schedule updated.',
                fileName: 'maintenance_schedule_v2.xlsx',
                time: '2023-10-20 11:00',
              ),
            ],
          ),

          const Divider(height: 24, thickness: 1, color: commonGrey2),
          Text('ADD NEW LOG ENTRY', style: captionCommon(commonGrey7)),
          const SizedBox(height: 8),
          const _NewLogEntry(),
        ],
      ),
    );
  }
}

class _CareLogItem extends StatelessWidget {
  final String? user;
  final String? type;
  final String message;
  final String time;
  final String? fileName;

  const _CareLogItem({required this.message, required this.time, this.user, this.type, this.fileName})
    : assert(user != null || type != null, 'Either user or type must be provided');

  @override
  Widget build(BuildContext context) {
    final bool isSystem = type != null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(shape: BoxShape.circle, color: isSystem ? commonGrey5 : themeBlue),
            alignment: Alignment.center,
            child: Text(isSystem ? 'S' : user![0], style: bodyCommon(commonWhite).copyWith(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isSystem ? type! : user!, style: bodyCommon(commonBlack).copyWith(fontWeight: FontWeight.bold)),
                Text(message, style: bodyCommon(commonGrey7)),
                if (fileName != null) _buildAttachmentChip(fileName!),
              ],
            ),
          ),

          Text(time.substring(5), style: captionCommon(commonGrey5)),
        ],
      ),
    );
  }

  Widget _buildAttachmentChip(String fileName) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: commonGrey2, borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.file_present, size: 14, color: commonGrey7),
          const SizedBox(width: 4),
          Text(fileName, style: captionCommon(commonBlack)),
          const SizedBox(width: 4),
          const Icon(Icons.download_outlined, size: 14, color: commonGrey7),
        ],
      ),
    );
  }
}

class _NewLogEntry extends StatelessWidget {
  const _NewLogEntry();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: commonGrey2, width: 1), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          TextFormField(
            style: bodyCommon(commonBlack),
            decoration: InputDecoration(
              hintText: "Enter consultation notes or actions taken...",
              isDense: true,
              hintStyle: bodyCommon(commonGrey3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                // 2. 포커스 시 테마 색상 적용
                borderSide: const BorderSide(color: themeYellow, width: 2.0),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            maxLines: 3,
            // validator: validator,
          ),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [addButton('Add Log', () {})]),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
