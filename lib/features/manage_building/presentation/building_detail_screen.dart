import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moni_pod_web/common_widgets/button.dart';
import 'package:moni_pod_web/common_widgets/status_chip.dart';
import 'package:moni_pod_web/features/manage_building/presentation/edit_unit_dialog.dart';
import 'package:moni_pod_web/features/manage_building/presentation/unit_detail_screen.dart';

import '../../../common/util/util.dart';
import '../../../config/style.dart';
import '../../../router.dart';
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
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                color:
                    widget.unit.status == 'critical'
                        ? Colors.red.withOpacity(0.1)
                        : widget.unit.status == 'warning'
                        ? Colors.yellow.withOpacity(0.1)
                        : widget.unit.status == 'offline'
                        ? commonGrey2
                        : commonWhite,
              ),

              child: Row(
                children: [
                  Expanded(child: Text(widget.unit.number, style: titleLarge(commonBlack), overflow: TextOverflow.ellipsis)),
                  StatusChip(status: widget.unit.status),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      print("@");
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
            Container(height: 1, width: double.infinity, color: commonGrey2),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 24,
                        width: 24,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: commonGrey3),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          "assets/images/ic_24_person.svg",
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(commonGrey6, BlendMode.srcIn),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(widget.unit.resident.name, style: bodyCommon(commonBlack)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        height: 24,
                        width: 24,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: commonGrey3),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          "assets/images/ic_24_motion.svg",
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(commonGrey6, BlendMode.srcIn),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Last Motion", style: captionPoint(commonGrey4)),
                          Text(formatMinutesToTimeAgo(widget.unit.lastMotion), style: bodyCommon(commonBlack)),
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
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 2))]
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
                          showEditUnitDialog(context,widget.unit);
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
          border: Border.all(color: borderColor, width: 1.5),
          // boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back, size: 24, color: commonBlack),
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.building.name, style: headLineSmall(commonBlack)),
                    const SizedBox(height: 2),
                    Text('Unit Status Overview', style: bodyCommon(commonGrey6)),
                  ],
                ),
              ],
            ),
            Expanded(child: Container()),
            addButton('Add Unit', () {
              showAddUnitDialog(context);
            }),
            const SizedBox(width: 16),
          ],
        ),
        const SizedBox(height: 16),
        buildResponsiveBuildingCard(),
        const SizedBox(height: 16),
        Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: SingleChildScrollView(child: _buildUnitGrid()))),
      ],
    );
  }

  Widget buildResponsiveBuildingCard() {
    return Container(
      margin: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: commonWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: commonGrey2, width: 2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double breakpoint = 700.0;
          final bool isNarrow = constraints.maxWidth < breakpoint;
          final Widget leftSection = Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: isNarrow ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/images/img_80_building.svg'),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.building.name, style: headLineSmall(commonBlack), overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/ic_24_location.svg',
                            colorFilter: const ColorFilter.mode(commonGrey5, BlendMode.srcIn),
                          ),
                          const SizedBox(width: 4),
                          Text(widget.building.address, style: bodyCommon(commonGrey6), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const SizedBox(width: 3),
                        const Icon(Icons.manage_accounts, size: 20, color: commonGrey5),
                        const SizedBox(width: 5),
                        Text('Manager: ${widget.building.manager}', style: bodyCommon(commonGrey6)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );

          final Widget rightSection = Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(isNarrow ? 0 : 8.0), bottomRight: Radius.circular(8.0)),
              color: commonGrey2,
            ),
            padding: isNarrow ? const EdgeInsets.symmetric(vertical: 8) : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.building.totalUnit.toString(), style: headLineMedium(commonBlack)),
                      const SizedBox(height: 6),
                      Text('TOTAL', style: bodyTitle(commonBlack)),
                    ],
                  ),
                ),
                Container(width: 1, height: 24, color: commonGrey5),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.building.activeUnit.toString(), style: headLineMedium(themeBlue)),
                      const SizedBox(height: 6),
                      Text('ACTIVE', style: bodyTitle(themeBlue)),
                    ],
                  ),
                ),
                Container(width: 1, height: 24, color: commonGrey5),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.building.criticalUnit.toString(), style: headLineMedium(Colors.red)),
                      const SizedBox(height: 6),
                      Text('CRITICAL', style: bodyTitle(Colors.red)),
                    ],
                  ),
                ),
                Container(width: 1, height: 24, color: commonGrey5),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.building.warningUnit.toString(), style: headLineMedium(themeYellow)),
                      const SizedBox(height: 6),
                      Text('WARNING', style: bodyTitle(themeYellow)),
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
              children: [leftSection, Container(height: 1, width: double.infinity, color: commonGrey2), rightSection],
            );
          } else {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Expanded(flex: 3, child: leftSection), Expanded(flex: 2, child: rightSection)],
            );
          }
        },
      ),
    );
  }

  Widget _buildUnitGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double minItemWidth = 400.0;
        const double spacing = 16.0;
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
    );
  }
}
