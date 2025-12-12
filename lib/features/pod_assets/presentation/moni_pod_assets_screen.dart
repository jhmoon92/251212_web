import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moni_pod_web/features/home/presentation/base_screen.dart';
import 'dart:html' if (dart.library.io) 'package:universal_html/html.dart' as html;
import 'package:data_table_2/data_table_2.dart';

import '../../../common_widgets/input_box.dart';
import '../../../config/style.dart';
import '../../manage_building/domain/unit_model.dart';

class MoniPodAssetsScreen extends ConsumerStatefulWidget {
  const MoniPodAssetsScreen({super.key});

  @override
  ConsumerState<MoniPodAssetsScreen> createState() => _MoniPodAssetsScreenState();
}

class _MoniPodAssetsScreenState extends ConsumerState<MoniPodAssetsScreen> {
  TextEditingController controller = TextEditingController();
  final ScrollController verticalScrollController = ScrollController();
  final ScrollController horizontalScrollController = ScrollController();
  DateTime _lastUpdatedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          Expanded(
            child: ScrollbarTheme(
              data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(commonGrey3), trackColor: WidgetStateProperty.all(commonGrey3)),
              child: Scrollbar(
                controller: verticalScrollController,
                interactive: true,
                thumbVisibility: true,
                thickness: 8.0,
                child: _buildDataTable(),
              ),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  void _handleRegisterDevice() {
    print('Register Device button pressed');
  }

  // 💡 3. Import CSV 기능 구현 (File Picker 사용)
  void _handleImportCsv() async {
    // 웹 환경에서 File Picker 사용
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final bytes = file.bytes;

        if (bytes != null) {
          // CSV 내용을 String으로 변환 (웹에서는 bytes로 접근)
          String csvContent = String.fromCharCodes(bytes);

          // TODO: 실제로는 여기서 csvContent를 파싱하여 _assets 리스트를 업데이트해야 합니다.
          print('CSV File picked: ${file.name}');
          print('Content preview: ${csvContent.substring(0, csvContent.length > 200 ? 200 : csvContent.length)}');

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('"${file.name}" 파일이 성공적으로 업로드되었으며, 데이터 파싱을 준비합니다.')));
          }
        }
      } else {
        // User canceled the picker
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CSV 파일 선택이 취소되었습니다.')));
        }
      }
    } catch (e) {
      print('Error picking file: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('파일 선택 중 오류가 발생했습니다: $e')));
      }
    }
  }

  // 💡 4. Export CSV 기능 구현 (dart:html 사용)
  void _handleExportCsv() {
    // CSV 헤더 정의 (Asset.toCsvString()의 순서와 일치)
    const headers = 'MAC ADDRESS,FIRMWARE VERSION,SIGNAL (RSSI),PAIRING STATUS,STATUS,REGISTERED BY,DATE,SENSOR TYPE\n';

    // 데이터 행 생성
    final csvData = allGlobalDevicesList.map((device) => device.toCsvString()).join('\n');
    final csvContent = headers + csvData;

    // Flutter Web 환경인지 확인
    if (kIsWeb) {
      try {
        final bytes = Uint8List.fromList(csvContent.codeUnits);
        // dart:html의 Blob 및 AnchorElement 사용
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);

        final anchor =
            html.AnchorElement(href: url)
              ..setAttribute("download", "moni_pod_assets_${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}.csv")
              ..click();

        html.Url.revokeObjectUrl(url); // 메모리 해제

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CSV 파일 다운로드를 시작합니다.')));
        }
      } catch (e) {
        print("CSV Export failed: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('다운로드 중 오류가 발생했습니다.')));
        }
      }
    } else {
      // Web이 아닌 환경 (콘솔 출력으로 대체)
      print("CSV Export: Web 환경에서만 다운로드가 지원됩니다.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CSV 다운로드는 웹 환경에서만 지원됩니다.')));
      }
    }
  }

  // 💡 2. 상단 헤더 위젯 (반응형 구현은 기존 코드를 유지합니다.)
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 버튼이 검색창 아래로 내려갈 기준 너비 설정
          const double breakpoint = 1000.0;
          final bool isNarrow = constraints.maxWidth < breakpoint;

          // 버튼 그룹 위젯
          final buttonGroup = Row(
            children: [
              // _buildActionButton('Register Device', 'assets/images/ic_24_add.svg', themeYellow, commonWhite, _handleRegisterDevice),
              // const SizedBox(width: 8),
              // _buildActionButton('Upload (CSV)', 'assets/images/ic_24_upload.svg', commonWhite, commonGrey6, _handleImportCsv),
              // const SizedBox(width: 8),
              _buildActionButton('Export CSV', 'assets/images/ic_24_download.svg', commonWhite, commonGrey6, _handleExportCsv),
            ],
          );

          // 검색 필드 위젯
          final searchField = SizedBox(
            // 화면이 넓을 때는 고정 너비, 좁을 때는 Expanded(남은 공간 모두 차지)
            width: isNarrow ? null : 380,
            child: InputBox(
              controller: controller,
              placeHolder: "Search MAC, Building or Unit...",
              maxLength: 50,
              icon: Padding(padding: EdgeInsets.only(left: 8), child: SvgPicture.asset('assets/images/ic_16_search.svg')),
              onSaved: (val) {},
              textStyle: bodyCommon(commonBlack),
              textType: 'normal',
              validator: (value) {
                return null;
              },
            ),

            // TextFormField(
            //   controller: controller,
            //   style: bodyCommon(commonBlack),
            //   decoration: InputDecoration(
            //     hintText: "Search",
            //     hintStyle: bodyCommon(commonGrey3),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8),
            //       borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8),
            //       borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8),
            //       // 2. 포커스 시 테마 색상 적용
            //       borderSide: const BorderSide(color: themeYellow, width: 2.0),
            //     ),
            //     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            //   ),
            //   // validator: validator,
            // ),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topTitle('Moni Pod List', 'Asset Management', _lastUpdatedTime, () {
                setState(() {
                  _lastUpdatedTime = DateTime.now();
                });
              }),
              const SizedBox(height: 16),
              if (!isNarrow)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Spacer(), buttonGroup, const SizedBox(width: 16), searchField],
                ),
              if (isNarrow)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [buttonGroup, const Spacer()]),
                    const SizedBox(height: 16),
                    searchField,
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  // 액션 버튼 위젯
  Widget _buildActionButton(String text, String icon, Color bgColor, Color textColor, VoidCallback onTap) {
    bool isPrimary = bgColor == themeYellow;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
          border: isPrimary ? null : Border.all(color: commonGrey4),
        ),
        child: Row(children: [SvgPicture.asset(icon), const SizedBox(width: 8), Text(text, style: bodyTitle(textColor))]),
      ),
    );
  }

  Widget _buildDataTable() {
    const double minTableWidth = 1600.0;

    return DataTable2(
      scrollController: horizontalScrollController,
      fixedTopRows: 1,
      minWidth: minTableWidth,
      headingRowColor: WidgetStateProperty.all<Color>(commonGrey1),
      border: TableBorder(horizontalInside: BorderSide(color: commonGrey2, width: 1.0), bottom: BorderSide(color: commonGrey2, width: 1.0)),
      columnSpacing: 30, // 열 간격 조정
      horizontalMargin: 0,
      headingRowHeight: 48,
      dataRowHeight: 56, // 행 높이 조정
      columns: [
        DataColumn2(
          label: Padding(padding: EdgeInsets.only(left: 24), child: Text('MAC ADDRESS', style: bodyCommon(commonGrey5))),
          size: ColumnSize.M,
        ),
        DataColumn2(
          label: Padding(padding: EdgeInsets.only(left: 16), child: Text('BUILDING', style: bodyCommon(commonGrey5))),
          size: ColumnSize.M,
        ),
        DataColumn2(
          label: Padding(padding: EdgeInsets.only(left: 16), child: Text('UNIT', style: bodyCommon(commonGrey5))),
          size: ColumnSize.S,
        ),
        DataColumn2(
          label: Padding(padding: EdgeInsets.only(left: 16), child: Text('RESIDENT', style: bodyCommon(commonGrey5))),
          size: ColumnSize.L,
        ),
        DataColumn2(
          label: Padding(padding: EdgeInsets.only(left: 16), child: Text('FIRMWARE', style: bodyCommon(commonGrey5))),
          size: ColumnSize.S,
        ),
        DataColumn2(
          label: Padding(padding: EdgeInsets.only(left: 16), child: Text('STATUS', style: bodyCommon(commonGrey5))),
          size: ColumnSize.S,
        ),
        DataColumn2(
          label: Padding(padding: EdgeInsets.only(left: 16), child: Text('INSTALLER', style: bodyCommon(commonGrey5))),

          size: ColumnSize.M,
        ),
        DataColumn2(
          label: Padding(padding: EdgeInsets.only(left: 16), child: Text('REG.DATE', style: bodyCommon(commonGrey5))),
          size: ColumnSize.L,
        ),
      ],
      rows:
          allGlobalDevicesList
              .map(
                (device) => DataRow(
                  cells: [
                    DataCell(
                      Padding(
                        padding: EdgeInsets.only(left: 24),
                        child: Text(device.serialNumber, style: bodyCommon(commonBlack), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(device.buildingName, style: bodyCommon(commonBlack), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(device.unitNumber, style: bodyCommon(commonBlack), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/images/ic_24_person.svg', colorFilter: ColorFilter.mode(commonGrey5, BlendMode.srcIn)),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                device.residentName,
                                style: bodyCommon(commonBlack),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text('v1.2.0', style: bodyCommon(commonBlack), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: device.status == 'ONLINE' ? themeGreen.withOpacity(0.1) : themeRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            device.status == 'ONLINE' ? 'Online' : 'Offline',
                            style: bodyCommon(device.status == 'ONLINE' ? themeGreen : themeRed),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Row(
                          children: [
                            Icon(Icons.manage_accounts, size: 20, color: commonGrey5),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(device.installer, style: bodyCommon(commonBlack), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          DateFormat('yyyy.MM.dd. HH:mm').format(device.installationDate),
                          style: bodyCommon(commonGrey4),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
    );
  }
}
