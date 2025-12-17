import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moni_pod_web/common_widgets/status_chip.dart';
import 'package:moni_pod_web/features/manage_building/presentation/building_detail_screen.dart';

import '../../../common/util/util.dart';
import '../../../common_widgets/button.dart';
import '../../../common_widgets/input_box.dart';
import '../../../common_widgets/manger_drop_down.dart';
import '../../../config/style.dart';
import '../domain/unit_model.dart';

class UnitDetailScreen extends ConsumerStatefulWidget {
  const UnitDetailScreen({required this.building, required this.unitInfo, super.key});

  final Building building;
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
          const double breakpoint = 1000.0;
          final bool isNarrowScreen = screenWidth < breakpoint;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                isNarrowScreen
                    ? Column(
                      children: [
                        _StatusCard(widget.unitInfo),
                        const SizedBox(height: 16),
                        _RightPanel(unitInfo: widget.unitInfo),
                        const SizedBox(height: 16),
                        _LeftPanel(unitInfo: widget.unitInfo),
                      ],
                    )
                    : Column(
                      children: [
                        _StatusCard(widget.unitInfo),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: _LeftPanel(unitInfo: widget.unitInfo)),
                            const SizedBox(width: 16),
                            Expanded(flex: 7, child: _RightPanel(unitInfo: widget.unitInfo)),
                          ],
                        ),
                      ],
                    ),
                const SizedBox(height: 24),
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
        InkWell(
          onTap: () {
            context.pop();
          },
          child: SvgPicture.asset('assets/images/ic_24_previous.svg', colorFilter: const ColorFilter.mode(commonBlack, BlendMode.srcIn)),
        ),
        const SizedBox(width: 12),
        Text(widget.unitInfo.number, style: headLineSmall(commonBlack)),
        Expanded(child: SizedBox()),
        SvgPicture.asset('assets/images/ic_24_location.svg', colorFilter: ColorFilter.mode(commonGrey6, BlendMode.srcIn)),
        const SizedBox(width: 4),
        Text(widget.building.address, style: captionCommon(commonBlack)),
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
        const SizedBox(height: 24),
        _ManagerCard(unitInfo: unitInfo),
        const SizedBox(height: 24),
        InstalledDeviceCard(devices: unitInfo.devices),
      ],
    );
  }
}

class _ManagerCard extends StatefulWidget {
  const _ManagerCard({required this.unitInfo});

  final Unit unitInfo;

  @override
  State<_ManagerCard> createState() => _ManagerCardState();
}

class _ManagerCardState extends State<_ManagerCard> {
  bool _isEditing = false;

  Widget _buildInfoRow(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 90, child: Text(key, style: titleCommon(commonGrey7))),
        Expanded(
          child:
              _isEditing && key == 'Name'
                  ? SizedBox(
                    height: 40,
                    child: MangerDropDown(
                      onChanged: (String value) {
                        setState(() {});
                      },
                    ),
                  )
                  : Text(value, style: titleCommon(commonBlack), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
              Text('Manager', style: titleLarge(commonBlack)),
              Expanded(child: Container()),
              !_isEditing
                  ? InkWell(
                    onTap: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    child: SvgPicture.asset(
                      "assets/images/ic_24_edit.svg",
                      colorFilter: const ColorFilter.mode(commonBlack, BlendMode.srcIn),
                    ),
                  )
                  : Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (_isEditing) {
                              _isEditing = !_isEditing;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/ic_24_cancel.svg",
                              colorFilter: const ColorFilter.mode(commonGrey6, BlendMode.srcIn),
                            ),
                            Text('Cancel', style: captionTitle(commonBlack)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (_isEditing) {
                              _isEditing = !_isEditing;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/ic_24_check.svg",
                              colorFilter: const ColorFilter.mode(successGreen, BlendMode.srcIn),
                            ),
                            Text('Save', style: captionTitle(successGreen)),
                          ],
                        ),
                      ),
                    ],
                  ),
            ],
          ),
          SizedBox(height: _isEditing ? 16 : 24),
          Column(
            children: [
              _buildInfoRow('Name', widget.unitInfo.manager.name),
              SizedBox(height: _isEditing ? 22 : 28),
              _buildInfoRow('Account', widget.unitInfo.manager.account),
              const SizedBox(height: 28),
              _buildInfoRow('Contact', widget.unitInfo.manager.contact),
            ],
          ),
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
      padding: const EdgeInsets.all(24),
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
              Text('Resident', style: titleLarge(commonBlack)),
              Expanded(child: Container()),
              !_isEditing
                  ? InkWell(
                    onTap: () => _toggleEdit(false),
                    child: SvgPicture.asset(
                      "assets/images/ic_24_edit.svg",
                      colorFilter: const ColorFilter.mode(commonBlack, BlendMode.srcIn),
                    ),
                  )
                  : Row(
                    children: [
                      InkWell(
                        onTap: () => _toggleEdit(false),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/ic_24_cancel.svg",
                              colorFilter: const ColorFilter.mode(commonGrey6, BlendMode.srcIn),
                            ),
                            Text('Cancel', style: captionTitle(commonBlack)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () => _toggleEdit(true), // 저장 시 true 전달
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/ic_24_check.svg",
                              colorFilter: const ColorFilter.mode(successGreen, BlendMode.srcIn),
                            ),
                            Text('Save', style: captionTitle(successGreen)),
                          ],
                        ),
                      ),
                    ],
                  ),
            ],
          ),
          const SizedBox(height: 24),
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
        const SizedBox(height: 28),
        _buildReadRow('Born', _bornController.text),
        const SizedBox(height: 28),
        _buildReadRow('Gender', _genderValue),
        const SizedBox(height: 28),
        _buildReadRow('Phone', _phoneController.text),
      ],
    );
  }

  Widget _buildEditMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEditField('Name', _nameController),
        const SizedBox(height: 8),
        _buildEditField('Born', _bornController),
        const SizedBox(height: 8),
        _buildEditDropdown('Gender', _genderOptions, _genderValue, (String? newValue) {
          if (newValue != null) {
            setState(() => _genderValue = newValue);
          }
        }),
        const SizedBox(height: 8),

        _buildEditField('Phone', _phoneController),
      ],
    );
  }

  Widget _buildReadRow(String key, String value) {
    return Row(
      children: [
        SizedBox(width: 90, child: Text(key, style: titleCommon(commonGrey7))),
        Expanded(child: Text(value, style: titleCommon(commonBlack), maxLines: 1, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildEditField(String key, TextEditingController controller) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(key, style: titleCommon(commonGrey7))),
        Expanded(
          child: InputBox(
            controller: controller,
            label: key,
            maxLength: 32,
            isErrorText: true,
            onSaved: (val) {},
            textStyle: bodyCommon(commonBlack),
            textType: 'normal',
            validator: (value) {
              return null;
            },
            isTight: true,
          ),
        ),
      ],
    );
  }

  Widget _buildEditDropdown(String key, List<String> options, String currentValue, Function(String?) onChanged) {
    return Row(
      children: [
        SizedBox(width: 90, child: Text(key, style: titleCommon(commonGrey7))),
        Expanded(
          child: Container(
            height: 40,
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: commonWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: commonGrey2, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Installed Devices', style: titleLarge(commonBlack)),
          const SizedBox(height: 4),
          ListView.builder(
            shrinkWrap: true,
            itemCount: devices.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  _DeviceListItem(devices: devices[index]),
                  index == devices.length - 1 ? SizedBox() : Container(height: 1, color: commonGrey3),
                ],
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: commonWhite),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/images/ic_24_pod.svg', colorFilter: ColorFilter.mode(commonBlack, BlendMode.srcIn)),
              const SizedBox(width: 4),
              Text(devices.name, style: bodyCommon(commonBlack)),
              Expanded(child: SizedBox()),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: devices.status == 'ONLINE' ? successGreenBg1 : commonGrey2,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 6,
                      width: 6,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: devices.status == 'ONLINE' ? successGreen : commonGrey6),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      devices.status == 'ONLINE' ? 'Online' : 'Offline',
                      style: captionPoint(devices.status == 'ONLINE' ? successGreen : commonGrey6),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          Padding(padding: const EdgeInsets.only(left: 32), child: Text(devices.serialNumber, style: captionCommon(commonGrey5))),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(width: 32),

              Text('Installed by', style: captionCommon(commonBlack)),
              const SizedBox(width: 4),
              Text(devices.installer, style: captionCommon(commonBlack)),
              const Spacer(),
              Text(DateFormat('yyyy.MM.dd. HH:mm').format(devices.installationDate), style: captionCommon(commonGrey5)),
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_CareLogCard()]);
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard(this.unit);

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color:
            unit.status == 'critical'
                ? warningRedBg2
                : unit.status == 'warning'
                ? cautionYellowBg2
                : unit.status == 'offline'
                ? commonGrey3
                : successGreenBg2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          StatusChip(status: unit.status),
          const SizedBox(width: 12),
          Text(
            'Last Motion : ${formatMinutesToTimeAgo(unit.lastMotion)}',
            style: titleLarge(
              unit.status == 'critical'
                  ? warningRed
                  : unit.status == 'warning'
                  ? themeYellow
                  : unit.status == 'offline'
                  ? commonGrey6
                  : successGreen,
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
          Text('Care Log', style: titleLarge(commonBlack)),
          SizedBox(height: 12),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // 외부 스크롤 사용
            padding: EdgeInsets.zero,
            children: const [
              _CareLogItem(
                user: 'John Doe',
                message:
                    'Throughout the day, the system continuously monitored the resident’s activity levels and confirmed consistent movement during key daily routines, suggesting that the resident was able to carry out essential activities independently; additionally, no signs of distress or unusual inactivity were identified, and the overall behavioral pattern remains within the normal range for this resident, providing reassurance regarding their current well-being.',
                time: '2023-10-25 14:00',
              ),
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
          const SizedBox(height: 48),

          Text('Add new log entry', style: titleSmall(commonBlack)),
          const SizedBox(height: 12),
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
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(shape: BoxShape.circle, color: isSystem ? commonGrey5 : themeBlue),
            alignment: Alignment.center,
            child: Text(isSystem ? 'S' : user![0], style: titleLarge(commonWhite)),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isSystem ? type! : user!, style: bodyTitle(commonBlack)),
                const SizedBox(height: 2),
                Text(message, style: titleCommon(commonGrey7)),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(color: newBlueBg1, borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("assets/images/ic_16_attach.svg"),
          const SizedBox(width: 8),
          Text(fileName, style: captionCommon(commonBlack)),
          const SizedBox(width: 16),
          SvgPicture.asset("assets/images/ic_16_download.svg"),
        ],
      ),
    );
  }
}

class _NewLogEntry extends StatelessWidget {
  const _NewLogEntry();

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [addButton('Add Log', () {})]),
      ],
    );
  }
}
