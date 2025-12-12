import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:moni_pod_web/common_widgets/button.dart';
import '../../../common_widgets/custom_dialog.dart';
import '../../../common_widgets/input_box.dart';
import '../../../config/style.dart';

const String googleApiKey = 'AIzaSyBUc2bj_VUyH-kmgsFJxDgT4OXBUQBp2O0';

class Manager {
  final String name;
  final String id;
  final bool isMaster;

  Manager({required this.name, required this.id, this.isMaster = false});
}

void showAddBuildingDialog(BuildContext context) {
  showCustomDialog(context: context, title: 'Add Building', content: const SizedBox(width: 500, height: 760, child: AddBuildingDialog()));

  // showCustomDialog(context: context, title: 'Add Building', content: AddBuildingDialog());
}

class AddBuildingDialog extends ConsumerStatefulWidget {
  const AddBuildingDialog({super.key});
  @override
  ConsumerState<AddBuildingDialog> createState() => _AddBuildingDialogState();
}

class _AddBuildingDialogState extends ConsumerState<AddBuildingDialog> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _buildingNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _startFloorController = TextEditingController();
  final TextEditingController _endFloorController = TextEditingController();
  final TextEditingController _unitsPerFloorController = TextEditingController();
  final TextEditingController _customUnitController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<String> _addressSuggestions = [];
  Timer? _debounce;
  bool _isSearchingAddress = false;
  double _progressbarValue1 = 0;
  bool isStep1 = true;
  late TabController _tabController;
  late Animation<double> _animation1;
  late AnimationController _controller1;

  List<String> _unitSet = [];

  List<Manager> _managers = [
    Manager(name: 'Yamada Taro (Master)', id: 'taro_admin', isMaster: true),
    Manager(name: 'Tanaka Kenji', id: 'tanaka_k'),
    Manager(name: 'Sato Haruka', id: 'sato_h'),
    Manager(name: 'Suzuki Ryota', id: 'suzuki_r'),
    Manager(name: 'Takahashi Aoi', id: 'takahashi_a'),
    Manager(name: 'Watanabe Yui', id: 'watanabe_y'),
  ];

  Map<String, bool> _selectedManagers = {};

  // 선택된 이미지 파일 이름
  String? _imageFileName;
  // 2. 이미지 미리보기를 위한 바이트 데이터 저장
  Uint8List? _imageFileBytes;

  @override
  void initState() {
    super.initState();
    _generateUnits();
    for (var manager in _managers) {
      _selectedManagers[manager.id] = manager.isMaster;
    }
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
    _addressController.dispose();
    _debounce?.cancel();
    _controller1.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    _startFloorController.dispose();
    _endFloorController.dispose();
    _unitsPerFloorController.dispose();
    _customUnitController.dispose();
    super.dispose();
  }

  // 1. Google Maps 주소 검색 로직 (API 호출 구조 활성화)
  void _onAddressSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (query.isEmpty) {
        setState(() {
          _addressSuggestions = [];
        });
        return;
      }

      setState(() {
        _isSearchingAddress = true;
      });

      // 실제 Google Places API Autocomplete 호출 로직 활성화
      // 참고: 이 코드가 정상 작동하려면 프로젝트에 'http' 패키지가 추가되어야 합니다.
      final apiUrl = '/api/places/maps/api/place/autocomplete/json?input=$query&key=$googleApiKey&language=ko&components=country:kr';
      // final apiUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$googleApiKey&language=ko&components=country:kr';

      try {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final predictions = data['predictions'] as List<dynamic>;
          if (mounted) {
            setState(() {
              // 최대 5개의 주소 제안 목록
              _addressSuggestions = predictions.map((p) => p['description'] as String).take(5).toList();
            });
          }
        } else {
          print('Google Places API Error: ${response.statusCode}');
          if (mounted) {
            setState(() {
              _addressSuggestions = ['주소 검색 오류 발생 (Code: ${response.statusCode})'];
            });
          }
        }
      } catch (e) {
        print('Exception during address search: $e');
        if (mounted) {
          setState(() {
            _addressSuggestions = ['주소 검색 중 예외 발생'];
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSearchingAddress = false;
          });
        }
      }
    });
  }

  // 주소 제안 항목 선택 처리
  void _selectAddress(String address) {
    _addressController.text = address;
    setState(() {
      _addressSuggestions = [];
    });
  }

  // 2. 이미지 파일 선택 및 미리보기 구현 (웹 전용)
  void _pickImage() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*'; // 이미지 파일만 선택하도록 설정
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files!.isNotEmpty) {
        final file = files[0];

        // 파일을 읽어서 바이트 데이터로 변환 (미리보기를 위함)
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((e) {
          if (reader.result != null) {
            setState(() {
              _imageFileName = file.name;
              _imageFileBytes = reader.result as Uint8List;
            });
          }
        });
      }
    });
  }

  // 건물 추가 버튼 클릭
  void _handleAddBuilding() {
    // if (_formKey.currentState!.validate()) {
    //   // 폼 데이터 수집
    //   final data = {
    //     'name': _buildingNameController.text,
    //     'address': _addressController.text,
    //     // 실제로는 _imageFileBytes를 서버로 업로드하는 로직 필요
    //     'imageFileName': _imageFileName,
    //     'managers': _selectedManagers.entries.where((e) => e.value).map((e) => e.key).toList(),
    //   };
    //
    //   // [NOTE] 실제로는 여기서 데이터를 백엔드로 전송하는 로직 구현
    //   print('건물 추가 데이터: $data');
    //
    //   // 다이얼로그 닫기
    //   Navigator.of(context).pop();
    // }
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
                  Tab(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildImageUploader(),
                          const SizedBox(height: 20),
                          _buildAddressInput(),
                          const SizedBox(height: 20),
                          inputText(
                            'Building Name',
                            'e.g.Sunrise Senior Care',
                            _buildingNameController,
                            const Icon(Icons.person_outline, color: Colors.grey),
                            isRequired: true,
                          ),
                          const SizedBox(height: 20),
                          _buildAssignedManagers(),
                        ],
                      ),
                    ),
                  ),
                  // Tab 2 Content
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
                    : addButton('Add Building', () {}),
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
                Text('2. Unit Generator', style: bodyTitle(!isStep1 ? commonGrey7 : commonGrey3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Address Search',
            style: bodyTitle(commonGrey7),
            children: [TextSpan(text: ' *', style: bodyTitle(Colors.red))],
          ),
        ),
        const SizedBox(height: 4),
        InputBox(
          controller: _addressController,
          label: 'Type to search (e.g. Seoul)...',
          maxLength: 32,
          isErrorText: true,
          icon: Padding(padding: const EdgeInsets.only(left: 8), child: SvgPicture.asset('assets/images/ic_16_search.svg')),
          onSaved: (val) {},
          textStyle: bodyCommon(commonBlack),
          textType: 'normal',
          validator: (value) => value == null || value.isEmpty ? 'Please Enter Address' : null,
          onChanged: _onAddressSearch,
        ),
        const SizedBox(height: 20),

        RichText(text: TextSpan(text: 'Region (Auto-filled)', style: bodyTitle(commonGrey7), children: [])),
        const SizedBox(height: 4),
        Stack(
          children: [
            InputBox(
              controller: _addressController,
              label: 'Select address first',
              maxLength: 32,
              isErrorText: true,
              onSaved: (val) {},
              textStyle: bodyCommon(commonBlack),
              textType: 'normal',
              validator: (value) => value == null || value.isEmpty ? 'Please Enter Address' : null,
              onChanged: _onAddressSearch,
            ),
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: commonGrey2.withOpacity(0.5)),
            ),
          ],
        ),

        // 검색 결과 목록
        if (_addressSuggestions.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 4)],
            ),
            margin: const EdgeInsets.only(top: 8),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _addressSuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _addressSuggestions[index];
                return ListTile(
                  // 2. 검색 제안 텍스트 색상 검은색으로 변경
                  title: Text(suggestion, style: bodyCommon(commonBlack)),
                  leading: const Icon(Icons.location_on, size: 20, color: themeYellow),
                  onTap: () => _selectAddress(suggestion),
                );
              },
            ),
          ),
      ],
    );
  }

  // 4. Building Image 업로드 위젯 (이미지 미리보기 기능 추가)
  Widget _buildImageUploader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Building Image', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            // BorderStyle.dashed를 BorderStyle.none으로 변경
            border: Border.all(color: Colors.grey.shade300, style: BorderStyle.none),
          ),
          child: InkWell(
            onTap: _pickImage, // PC 파일 탐색기 열기
            borderRadius: BorderRadius.circular(8),
            child: Center(
              // 2. 이미지 미리보기 로직
              child:
                  _imageFileBytes != null
                      ? Stack(
                        fit: StackFit.expand,
                        children: [
                          // 미리보기 이미지
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(_imageFileBytes!, fit: BoxFit.cover, alignment: Alignment.center),
                          ),
                          // 파일 이름 오버레이
                          Container(
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _imageFileName!,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // 아이콘 오버레이 (선택됨 표시)
                          Positioned(top: 8, right: 8, child: Icon(Icons.check_circle, size: 24, color: themeYellow)),
                        ],
                      )
                      // 파일이 선택되지 않은 경우
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload, size: 30, color: Colors.grey.shade600),
                          const SizedBox(height: 4),
                          Text('이미지 파일을 선택하거나 드래그하세요', style: TextStyle(color: Colors.grey.shade600)),
                        ],
                      ),
            ),
          ),
        ),
      ],
    );
  }

  // 5. Assigned Managers 위젯
  Widget _buildAssignedManagers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Assigned Managers', style: bodyTitle(commonGrey7)),
        const SizedBox(height: 6),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 150.0),
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: commonGrey4), borderRadius: BorderRadius.circular(8)),
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
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _managers.length,
                  itemBuilder: (context, index) {
                    final manager = _managers[index];
                    final isChecked = _selectedManagers[manager.id] ?? false;
                    final isDisabled = manager.isMaster; // Master Admin은 선택 해제 불가

                    return CheckboxListTile(
                      title: Text(manager.name, style: bodyCommon(isDisabled ? commonGrey5 : commonGrey7)),
                      value: isChecked,
                      onChanged:
                          isDisabled
                              ? null
                              : (bool? newValue) {
                                setState(() {
                                  _selectedManagers[manager.id] = newValue ?? false;
                                });
                              },
                      controlAffinity: ListTileControlAffinity.leading,
                      checkColor: Colors.white,
                      activeColor: themeYellow,
                      tileColor: isDisabled ? Colors.grey.shade50 : Colors.white,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
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
            children: [if (isRequired) TextSpan(text: ' *', style: bodyTitle(Colors.red))],
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

  void _generateUnits() {
    final int? startFloor = int.tryParse(_startFloorController.text);
    final int? endFloor = int.tryParse(_endFloorController.text);
    final int? unitsPerFloor = int.tryParse(_unitsPerFloorController.text);

    if (startFloor == null || endFloor == null || unitsPerFloor == null || unitsPerFloor <= 0) {
      return;
    }

    final Set<int> generatedUnits = {};
    int currentFloor;

    if (startFloor <= endFloor) {
      for (currentFloor = startFloor; currentFloor <= endFloor; currentFloor++) {
        for (int unit = 1; unit <= unitsPerFloor; unit++) {
          int unitNumber = currentFloor * 100 + unit;
          generatedUnits.add(unitNumber);
        }
      }
    } else {
      for (currentFloor = startFloor; currentFloor >= endFloor; currentFloor--) {
        for (int unit = 1; unit <= unitsPerFloor; unit++) {
          int unitNumber = currentFloor * 100 + unit;
          generatedUnits.add(unitNumber);
        }
      }
    }

    List<int> sortedIntUnits = generatedUnits.toList();
    sortedIntUnits.sort((a, b) => b.compareTo(a));
    List<String> finalDisplayUnits = sortedIntUnits.map((unit) => unit.toString()).toList();
    setState(() {
      _unitSet = finalDisplayUnits;
    });
  }

  void _deleteUnit(String unitNumber) {
    if (!unitNumber.contains('유효한')) {
      setState(() {
        _unitSet.remove(unitNumber);
      });
    }
  }

  void _addCustomUnit() {
    final String customUnit = _customUnitController.text.trim();
    if (customUnit.isEmpty) return;

    // 유효성 검사: 숫자만, 중복 X
    if (!RegExp(r'^\d+$').hasMatch(customUnit)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('유닛 번호는 숫자만 입력 가능합니다.')));
      return;
    }

    if (_unitSet.contains(customUnit)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('이미 목록에 존재하는 유닛 번호입니다.')));
      return;
    }

    setState(() {
      _unitSet.add(customUnit);
      _customUnitController.clear();
    });
  }

  // 7. 텍스트 필드 템플릿
  Widget _buildTextField({required String label, required TextEditingController controller}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: bodyCommon(commonGrey7)),
          const SizedBox(height: 4),
          InputBox(
            controller: controller,
            label:
                label == 'Start Floor'
                    ? '1'
                    : label == 'End Floor'
                    ? '12'
                    : '4',
            maxLength: 4,
            isErrorText: true,
            onSaved: (val) {},
            textStyle: bodyCommon(commonBlack),
            textType: 'number',
            validator: (value) {
              return null;
            },
            onChanged: (value) {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget step2Screen() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Text('Configuration', style: bodyTitle(commonBlack)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: commonWhite, borderRadius: BorderRadius.circular(8), border: Border.all(color: commonGrey4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildTextField(label: 'Start Floor', controller: _startFloorController),
                      const SizedBox(width: 16),
                      _buildTextField(label: 'End Floor', controller: _endFloorController),
                      const SizedBox(width: 16),
                      _buildTextField(label: 'Units per Floor', controller: _unitsPerFloorController),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _generateUnits,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _startFloorController.text.isNotEmpty &&
                                    _endFloorController.text.isNotEmpty &&
                                    _unitsPerFloorController.text.isNotEmpty
                                ? themeYellow
                                : commonGrey3,
                        foregroundColor: commonWhite,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: Text('Generate Preview', style: bodyTitle(commonWhite)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Text('Preview (${_unitSet.length})', style: bodyTitle(commonBlack)),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: commonWhite, borderRadius: BorderRadius.circular(8), border: Border.all(color: commonGrey4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InputBox(
                          controller: _customUnitController,
                          label: 'Add custom...',
                          maxLength: 4,
                          isErrorText: true,
                          icon: Icon(Icons.layers_outlined, size: 22, color: commonGrey5),
                          onSaved: (val) {},
                          textStyle: bodyCommon(commonBlack),
                          textType: 'number',
                          validator: (value) {
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _addCustomUnit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeYellow,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          child: const Icon(Icons.add, size: 24, color: commonWhite),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // 미리보기 그리드
                  if (_unitSet.isNotEmpty)
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      clipBehavior: Clip.none,
                      children:
                          _unitSet.map((unit) {
                            // 유효성 검사 메시지인 경우
                            if (unit.contains('유효한')) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(unit, style: TextStyle(color: Colors.red.shade700)),
                              );
                            }
                            // 🚨 호버 및 삭제 기능이 있는 칩 위젯 사용
                            return _UnitChip(unitNumber: unit, onDelete: _deleteUnit);
                          }).toList(),
                    )
                  else
                    SizedBox(height: 180, child: Center(child: Text('No units generated yet.', style: bodyCommon(commonGrey5)))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitChip extends StatefulWidget {
  final String unitNumber;
  final ValueChanged<String> onDelete;

  const _UnitChip({required this.unitNumber, required this.onDelete});

  @override
  State<_UnitChip> createState() => _UnitChipState();
}

class _UnitChipState extends State<_UnitChip> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // 예: 2px씩 확장
            decoration: BoxDecoration(
              color: Colors.transparent, // 배경색 지정 (원하는 색상으로 변경)
            ),
            child: Text(widget.unitNumber, style: bodyTitle(Colors.transparent)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: themeYellow20, border: Border.all(color: themeYellow), borderRadius: BorderRadius.circular(4)),
            child: Text(widget.unitNumber, style: bodyTitle(commonGrey6)),
          ),

          // 2. 🚨 호버 시 나타나는 삭제 버튼 ('X' 아이콘)
          if (_isHovering)
            Positioned(
              top: 0, // 상단 경계선에 붙이기
              right: 0, // 우측 경계선에 붙이기
              child: GestureDetector(
                onTap: () => widget.onDelete(widget.unitNumber),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  padding: const EdgeInsets.all(3),
                  child: const Icon(Icons.close, size: 10, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
