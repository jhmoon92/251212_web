import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common_widgets/button.dart';
import '../../../common_widgets/custom_dialog.dart';
import '../../../common_widgets/input_box.dart';
import '../../../config/style.dart';
import '../domain/unit_model.dart';

const String googleApiKey = 'AIzaSyBUc2bj_VUyH-kmgsFJxDgT4OXBUQBp2O0';

class Manager {
  final String name;
  final String id;
  final bool isMaster;

  Manager({required this.name, required this.id, this.isMaster = false});
}

void showAddUnitDialog(BuildContext context) {
  showCustomDialog(context: context, title: 'Add Unit', content: const SizedBox(width: 680, height: 700, child: AddUnitDialog()));
}

class AddUnitDialog extends ConsumerStatefulWidget {
  const AddUnitDialog({super.key});
  @override
  ConsumerState<AddUnitDialog> createState() => _AddUnitDialogState();
}

const String unassignedInstallerId = 'none';

class _AddUnitDialogState extends ConsumerState<AddUnitDialog> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _buildingNameController = TextEditingController();

  final TextEditingController _unitNumberController = TextEditingController();
  final TextEditingController _residentNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _deviceNumberController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  double _progressbarValue1 = 0;
  bool isStep1 = true;
  late TabController _tabController;
  late Animation<double> _animation1;
  late AnimationController _controller1;
  int _deviceCount = 1;
  String? _selectedInstallerId = unassignedInstallerId;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, animationDuration: const Duration(milliseconds: 500));
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      reverseDuration: const Duration(seconds: 1),
    );
    _animation1 = CurvedAnimation(parent: _controller1, curve: Curves.easeIn);
    _animation1.addListener(() {
      if (mounted)
        setState(() {
          _progressbarValue1 = _animation1.value;
        });
    });
  }

  @override
  void dispose() {
    _buildingNameController.dispose();
    _debounce?.cancel();
    _controller1.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    _unitNumberController.dispose();
    _residentNameController.dispose();
    _phoneNumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(height: 4, color: themeYellow),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24), // 좌우 패딩만 유지
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  inputText(
                    'Unit Number',
                    '# e.g. 101',
                    _unitNumberController,
                    const Icon(Icons.tag_sharp, color: Colors.grey),
                    isRequired: true,
                  ),
                  const SizedBox(height: 28),

                  inputText('Resident Name', 'Unassigned', _residentNameController, const Icon(Icons.person_outline, color: Colors.grey)),
                  const SizedBox(height: 28),
                  inputText(
                    'Phone Number',
                    'e.g. 010-1234-5678',
                    _phoneNumberController,
                    const Icon(Icons.phone_outlined, color: Colors.grey),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(flex: 24, child: Text('Number of Devices', style: titleCommon(commonBlack))),
                      Expanded(flex: 44, child: _buildDeviceCounter()),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.only(left: 222),
                    child: Text("These devices will be created as 'Offline' placeholders.", style: bodyCommon(commonGrey5)),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Assign Installer', style: titleCommon(commonBlack)),
                            Text('(Optional)', style: bodyCommon(commonGrey5)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 44,
                        child: Column(children: [_buildInstallerSearch(), const SizedBox(height: 12), _buildInstallerList()]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(padding: EdgeInsets.only(right: 24, bottom: 24), alignment: Alignment.bottomRight,child: addButton('Add Unit', () {},
              imageWidget: Container())),
        ],
      ),
    );
  }

  Widget _buildDeviceCounter() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCounterButton(Icons.remove, () {
          setState(() {
            if (_deviceCount > 1) _deviceCount--;
          });
        }, _deviceCount > 1),
        const SizedBox(width: 16),
        Container(width: 50, alignment: Alignment.center, child: Text('$_deviceCount', style: bodyTitle(commonBlack))),

        // SizedBox(
        //   width: 144,
        //   child: InputBox(
        //     controller: _deviceNumberController,
        //     initialText: _deviceCount.toString(),
        //     maxLength: 32,
        //     isErrorText: true,
        //     onSaved: (val) {},
        //     textStyle: bodyTitle(commonBlack),
        //     textType: 'normal',
        //     validator: (value) {
        //       return null;
        //     },
        //   ),
        // ),
        const SizedBox(width: 16),
        _buildCounterButton(Icons.add, () {
          if (_deviceCount < 4) {
            setState(() {
              _deviceCount++;
            });
          }
        }, _deviceCount < 4),
      ],
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onPressed, bool isEnabled) {
    return InkWell(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: isEnabled ? commonWhite : commonGrey3,
          border: Border.all(color: commonGrey2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 20, color: isEnabled ? commonBlack : commonWhite),
      ),
    );
  }

  Widget _buildInstallerSearch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: commonWhite, border: Border.all(color: commonGrey4), borderRadius: BorderRadius.circular(4)),
      child: TextField(
        decoration: InputDecoration(
          icon: const Icon(Icons.search, color: commonGrey5, size: 20),
          hintText: 'Search installers...',
          hintStyle: bodyCommon(commonGrey5),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        style: bodyCommon(commonBlack),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildInstallerList() {
    final List<Map<String, dynamic>> installerOptions = _getFilteredInstallerOptions();

    return Container(
      height: 200,
      decoration: BoxDecoration(border: Border.all(color: commonGrey3), borderRadius: BorderRadius.circular(4)),
      child: ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(commonGrey3),
          trackColor: WidgetStateProperty.all(Colors.grey.shade300),
        ),
        child: Scrollbar(
          controller: _scrollController,
          interactive: true,
          thumbVisibility: true,
          thickness: 8.0,
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            itemCount: installerOptions.length,
            itemBuilder: (context, index) {
              final option = installerOptions[index];
              return _buildInstallerItem(id: option['id']!, name: option['name']!, icon: option['icon']!);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInstallerItem({required String id, required String name, required IconData icon}) {
    final bool isSelected = id == _selectedInstallerId;
    final bool isUnassigned = id == unassignedInstallerId;

    final Color iconColor = isSelected ? themeYellow : commonGrey5;
    final Color textColor = isSelected ? themeYellow : commonBlack;
    final Color tileColor = isSelected && !isUnassigned ? commonGrey1 : Colors.transparent;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedInstallerId = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: tileColor,
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Text(name, style: isUnassigned ? (isSelected ? bodyTitle(themeYellow) : bodyTitle(commonBlack)) : bodyCommon(textColor)),
          ],
        ),
      ),
    );
  }

  Widget inputText(String title, String hint, TextEditingController controller, Widget icon, {bool isRequired = false}) {
    return Row(
      children: [
        Expanded(
          flex: 24,
          child: RichText(
            text: TextSpan(
              text: title,
              style: titleCommon(commonBlack),
              children: [if (isRequired) TextSpan(text: ' *', style: titleCommon(Colors.red))],
            ),
          ),
        ),
        Expanded(
          flex: 44,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputBox(
                controller: controller,
                label: hint,
                maxLength: 32,
                isErrorText: true,
                icon: icon,
                onSaved: (val) {},
                textStyle: bodyCommon(commonBlack),
                textType: 'normal',
                validator: (value) {
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 3. 설치자 목록 필터링 함수
  List<Map<String, dynamic>> _getFilteredInstallerOptions() {
    final List<Map<String, dynamic>> allOptions = [
      {'id': unassignedInstallerId, 'name': 'Do not assign yet', 'icon': Icons.person_off_outlined},
      ...dummyInstallers.map((i) => {'id': i.id, 'name': i.name, 'icon': Icons.person_outline}),
    ];

    if (_searchQuery.isEmpty) {
      return allOptions;
    }

    final lowerCaseQuery = _searchQuery.toLowerCase();

    // 'Do not assign yet' 항목을 분리
    final unassignedOption = allOptions.first;

    // 나머지 설치자 목록을 필터링 (이름에 검색어가 포함되는지 확인)
    final filteredInstallers =
        allOptions.sublist(1).where((option) {
          final name = option['name']!.toLowerCase();
          return name.contains(lowerCaseQuery);
        }).toList();

    // 필터링된 목록 앞에 'Do not assign yet'을 다시 추가
    return [unassignedOption, ...filteredInstallers];
  }
}
