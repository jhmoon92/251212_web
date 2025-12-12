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
  showCustomDialog(context: context, title: 'Add Unit', content: const SizedBox(width: 500, height: 590, child: AddUnitDialog()));
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
          stepper(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20), // 좌우 패딩만 유지
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  Tab(child: step1Screen()),
                  Tab(child: step2Screen()),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              // ... 기존 스타일 유지 ...
              color: commonGrey2,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: bodyTitle(commonGrey4)),
                ),
                const SizedBox(width: 16),
                isStep1
                    ? Container()
                    : InkWell(
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 10), () {
                          if (mounted) {
                            setState(() {
                              FocusScope.of(context).unfocus();
                              _controller1.reverse();
                              _tabController.animateTo(0);
                              isStep1 = true;
                            });
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(color: commonWhite, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Transform.flip(flipX: true, child: Icon(Icons.arrow_right_alt, size: 24, color: commonGrey4)),
                            const SizedBox(width: 4),
                            Text('Back', style: bodyTitle(commonGrey4)),
                          ],
                        ),
                      ),
                    ),
                isStep1
                    ? addButton('Next Step', () {
                      _controller1.forward();
                      _tabController.animateTo(1);
                      if (mounted) {
                        setState(() {
                          isStep1 = false;
                        });
                      }
                    }, imageWidget: Icon(Icons.arrow_right_alt, size: 24, color: commonWhite))
                    : addButton('Add Unit', () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget stepper(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(height: 8, decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0), color: themeYellow)),
                const SizedBox(height: 4),
                Text('1. Basic Info', style: bodyTitle(isStep1 ? commonGrey7 : commonGrey3)),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              children: [
                LinearProgressIndicator(
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4.0),
                  backgroundColor: commonGrey2,
                  color: themeYellow,
                  value: _progressbarValue1,
                ),
                const SizedBox(height: 4),
                Text('2. Initial Setup', style: bodyTitle(!isStep1 ? commonGrey7 : commonGrey3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget step1Screen() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          inputText('Unit Number', '# e.g. 101', _unitNumberController, const Icon(Icons.tag_sharp, color: Colors.grey), isRequired: true),
          const SizedBox(height: 24),
          Container(height: 1, color: commonGrey2),
          const SizedBox(height: 24),
          Text("RESIDENT INFORMATION", style: bodyTitle(commonGrey5)),
          const SizedBox(height: 16),
          inputText('Resident Name', 'Unassigned', _residentNameController, const Icon(Icons.person_outline, color: Colors.grey)),
          const SizedBox(height: 24),
          inputText('Phone Number', 'e.g. 010-1234-5678', _phoneNumberController, const Icon(Icons.phone_outlined, color: Colors.grey)),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget step2Screen() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Number of Devices', style: bodyTitle(commonBlack)),
          const SizedBox(height: 12),
          _buildDeviceCounter(),
          const SizedBox(height: 8),
          Text("These devices will be created as 'Offline' placeholders.", style: bodyCommon(commonGrey5)),
          const SizedBox(height: 24),
          Divider(height: 1, color: commonGrey2),
          const SizedBox(height: 24),
          Text('Assign Installer (Optional)', style: bodyTitle(commonBlack)),
          const SizedBox(height: 12),
          _buildInstallerSearch(),
          const SizedBox(height: 12),
          _buildInstallerList(),
          const SizedBox(height: 24),
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
        Container(width: 50, alignment: Alignment.center, child: Text('$_deviceCount', style: bodyTitle(commonBlack))),
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
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: isEnabled ? commonWhite : commonGrey2,
          border: Border.all(color: isEnabled ? commonGrey4 : commonGrey3),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 20, color: isEnabled ? commonGrey7 : commonGrey5),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: bodyTitle(commonGrey7),
            children: [if (isRequired) TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontSize: 14))],
          ),
        ),
        const SizedBox(height: 4),
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
