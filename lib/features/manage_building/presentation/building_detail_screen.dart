import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moni_pod_web/common_widgets/button.dart';
import 'package:moni_pod_web/common_widgets/status_chip.dart';
import 'package:moni_pod_web/features/manage_building/presentation/edit_unit_dialog.dart';
import 'package:moni_pod_web/features/manage_building/presentation/unit_detail_screen.dart';

import '../../../common/util/util.dart';
import '../../../common_widgets/input_box.dart';
import '../../../config/style.dart';

import '../../../router.dart';
import '../../home/presentation/base_screen.dart';
import '../domain/unit_model.dart';
import 'add_unit_dialog.dart';

class UnitTile extends StatefulWidget {
  final Unit unit;
  final VoidCallback onTap;

  const UnitTile({super.key, required this.unit, required this.onTap});

  @override
  State<UnitTile> createState() => _UnitTileState();
}

class _UnitTileState extends State<UnitTile> with SingleTickerProviderStateMixin {
  bool _isOverlayVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 타일 내부 콘텐츠 (애니메이션 여부에 관계없이 재사용)
  Widget _buildTileContent(Color mainTextColor, Color iconColor, Color detailColor) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 상단 (유닛 번호 및 Wi-Fi 아이콘)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                color:
                    widget.unit.status == 'critical'
                        ? warningRedBg2
                        : widget.unit.status == 'warning'
                        ? cautionYellowBg2
                        : widget.unit.status == 'offline'
                        ? commonGrey3
                        : successGreenBg2,
              ),

              child: Row(
                children: [
                  Expanded(child: Text(widget.unit.number, style: headLineSmall(commonBlack), overflow: TextOverflow.ellipsis)),
                  StatusChip(status: widget.unit.status),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isOverlayVisible = !_isOverlayVisible;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.transparent),
                      child: const Icon(Icons.more_vert, size: 24, color: commonGrey7),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset("assets/images/ic_24_person.svg", colorFilter: const ColorFilter.mode(commonGrey6, BlendMode.srcIn)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.unit.resident.name,
                          style: bodyCommon(commonBlack),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SvgPicture.asset("assets/images/ic_24_time.svg", colorFilter: const ColorFilter.mode(commonGrey6, BlendMode.srcIn)),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Last Motion: ${formatMinutesToTimeAgo(widget.unit.lastMotion)}",
                            style: bodyCommon(commonBlack),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        _isOverlayVisible
            ? Positioned(
              top: 52,
              right: 12,
              child: Container(
                height: 90,
                width: 100,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: commonWhite,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _isOverlayVisible = false;
                          });
                          showEditUnitDialog(context, widget.unit);
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/images/ic_16_edit.svg", colorFilter: ColorFilter.mode(commonGrey6, BlendMode.srcIn)),
                            const SizedBox(width: 4),
                            Text('Edit', style: bodyCommon(commonGrey6)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/images/ic_16_delete.svg", colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn)),
                          const SizedBox(width: 4),
                          Text('Delete ', style: bodyCommon(Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final unit = widget.unit;
    final Color staticBackgroundColor =
        unit.isAlert
            ? Colors.red.withOpacity(0.3)
            : unit.status == 'normal'
            ? themeGreen.withOpacity(0.3)
            : commonWhite;
    final Color borderColor = unit.tileColor;
    final Color mainTextColor = unit.isAlert || unit.status == 'offline' ? commonWhite : commonBlack;
    final Color detailColor = unit.isAlert ? commonWhite : commonGrey6;
    final Color iconColor = unit.isAlert || unit.status == 'offline' ? commonWhite : commonGrey6;

    // 타일 전체 디자인
    Widget tileDesign(Color bgColor) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: commonWhite,
          boxShadow: [BoxShadow(color: commonBlack.withOpacity(0.25), offset: const Offset(0, 4), blurRadius: 4, spreadRadius: 0)],
        ),
        child: _buildTileContent(mainTextColor, iconColor, detailColor),
      );
    }

    return InkWell(onTap: widget.onTap, child: tileDesign(staticBackgroundColor));
  }
}

class BuildingDetailScreen extends ConsumerStatefulWidget {
  const BuildingDetailScreen({required this.building, super.key});

  final Building building;
  @override
  ConsumerState<BuildingDetailScreen> createState() => _BuildingDetailScreenState();
}

class _BuildingDetailScreenState extends ConsumerState<BuildingDetailScreen> {
  DateTime _lastUpdatedTime = DateTime.now();
  TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topTitle('Building Details', 'Unit Status Overview', DateTime.now(), () {
                setState(() {
                  _lastUpdatedTime = DateTime.now();
                });
              }, isBackButton: true),
              LayoutBuilder(
                builder: (context, constraints) {
                  final double screenWidth = constraints.maxWidth;
                  const double threshold = 900;
                  final Widget inputBox = ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 408),
                    child: InputBox(
                      controller: controller,
                      label: 'Search unit',
                      maxLength: 32,
                      isErrorText: true,
                      icon: Padding(padding: const EdgeInsets.only(left: 8), child: SvgPicture.asset('assets/images/ic_16_search.svg')),
                      onSaved: (val) {},
                      textStyle: bodyCommon(commonBlack),
                      textType: 'normal',
                      validator: (value) {
                        return null;
                      },
                    ),
                    // child: InputBoxFilter(
                    //   controller: controller,
                    //   filterTitle: 'Filter for searching building',
                    //   placeHolder: 'Search building',
                    //   filters: const ['Building', 'Address', 'Manager'],
                    //   onFilterSelected: (index) {
                    //     setState(() {
                    //       currentFilterIndex = index;
                    //       selectedFilterValue = ['Building', 'Address', 'Manager'][index];
                    //     });
                    //   },
                    // ),
                  );
                  final Widget searchButton = InkWell(
                    onTap: () {},
                    child: Container(
                      height: 40,
                      width: 116,
                      decoration: BoxDecoration(color: themeYellow, borderRadius: BorderRadius.circular(4)),
                      alignment: Alignment.center,
                      child: Text('Search', style: bodyTitle(commonWhite)),
                    ),
                  );
                  final Widget addButtonWidget = addButton('Add Building', () {
                    showAddUnitDialog(context);
                  });
                  if (screenWidth > threshold) {
                    return Row(
                      children: [
                        inputBox,
                        const SizedBox(width: 12),
                        searchButton,
                        const Expanded(child: SizedBox()),
                        const SizedBox(width: 12),
                        addButtonWidget,
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(flex: 14, child: inputBox),
                            const SizedBox(width: 8),
                            searchButton,
                            const Expanded(child: SizedBox()),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(children: [const SizedBox(width: 12), addButtonWidget]),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              buildResponsiveBuildingCard(),
              const SizedBox(height: 16),
            ],
          ),
        ),
        Expanded(child: SingleChildScrollView(child: _buildUnitGrid())),
      ],
    );
  }

  Widget buildResponsiveBuildingCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: commonWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: commonGrey2, width: 1),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double breakpoint = 900.0;
          final bool isNarrow = constraints.maxWidth < breakpoint;
          final Widget leftSection = SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: isNarrow ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/img_default_building.png", height: 160, fit: BoxFit.fitHeight),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Text(widget.building.name, style: headLineSmall(commonBlack), overflow: TextOverflow.ellipsis, maxLines: 1),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/ic_24_location.svg',
                          colorFilter: const ColorFilter.mode(commonGrey6, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 4),
                        Text(widget.building.address, style: bodyCommon(commonGrey6), overflow: TextOverflow.ellipsis, maxLines: 1),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SvgPicture.asset('assets/images/ic_24_person.svg', colorFilter: ColorFilter.mode(commonGrey6, BlendMode.srcIn)),
                        const SizedBox(width: 4),
                        Text(widget.building.manager, style: bodyCommon(commonGrey6), maxLines: 1),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );

          final Widget rightSection = Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StatusChip(status: 'total'),
                      const SizedBox(height: 12),
                      Text(widget.building.totalUnit.toString(), style: titleLarge(commonBlack)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StatusChip(status: 'normal'),
                      const SizedBox(height: 12),
                      Text(widget.building.activeUnit.toString(), style: titleLarge(successGreen)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StatusChip(status: 'critical'),
                      const SizedBox(height: 12),
                      Text(widget.building.criticalUnit.toString(), style: titleLarge(warningRed)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StatusChip(status: 'warning'),
                      const SizedBox(height: 12),
                      Text(widget.building.warningUnit.toString(), style: titleLarge(themeYellow)),
                    ],
                  ),
                ),
              ],
            ),
          );

          if (isNarrow) {
            return Column(
              mainAxisSize: MainAxisSize.min, // 필요한 최소 높이만 차지
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                leftSection,
                Container(height: 1, width: double.infinity, color: commonGrey2),
                const SizedBox(width: 24),
                Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: rightSection),
              ],
            );
          } else {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Expanded(flex: 2, child: leftSection), const SizedBox(width: 24), Expanded(flex: 1, child: rightSection)],
            );
          }
        },
      ),
    );
  }

  Widget _buildUnitGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: ScrollbarTheme(
        data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(commonGrey3), trackColor: WidgetStateProperty.all(commonGrey3)),
        child: Scrollbar(
          controller: scrollController,
          interactive: true,
          thumbVisibility: true,
          thickness: 8.0,
          child: SingleChildScrollView(
            controller: scrollController,
            child: LayoutBuilder(
              builder: (context, constraints) {
                const double minItemWidth = 400.0;
                const double spacing = 24.0;
                final int crossAxisCount = ((constraints.maxWidth + spacing) / (minItemWidth + spacing)).floor();
                final int actualCrossAxisCount = crossAxisCount.clamp(1, 10);
                final double itemWidth = (constraints.maxWidth - (actualCrossAxisCount - 1) * spacing) / actualCrossAxisCount;
                return Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children:
                        widget.building.unitList.asMap().entries.map((entry) {
                          final int index = entry.key;
                          final unit = entry.value;
                          return SizedBox(
                            height: 176,
                            width: itemWidth,
                            child: UnitTile(
                              unit: unit,
                              onTap: () {
                                context.pushNamed(
                                  AppRoute.unitDetail.name,
                                  pathParameters: {
                                    'buildingId': widget.building.id.toString(), // 상위 Building ID
                                    'unitId': unit.id.toString(), // Unit ID
                                  },
                                );
                              },
                            ),
                          );
                        }).toList(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
