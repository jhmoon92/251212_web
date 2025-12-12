import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moni_pod_web/config/style.dart';
import '../../../common_widgets/status_chip.dart';
import '../../../router.dart';
import '../../manage_building/domain/unit_model.dart';

void showCriticalUnitsDialog(BuildContext context, bool isCritical) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SizedBox(
          width: 1000,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHeader(context, isCritical),
              Divider(height: 1, color: isCritical ? Colors.red : themeYellow),
              _buildListHeader(),
              _buildUnitList(isCritical ? dummyCriticalUnits : dummyWarningUnits, isCritical),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildHeader(BuildContext context, bool isCritical) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    decoration: BoxDecoration(
      color: isCritical ? themeRed20 : themeYellow20,
      borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
    ),
    child: Row(
      children: [
        SvgPicture.asset(
          isCritical ? "assets/images/ic_32_critical.svg" : "assets/images/ic_32_warning.svg",
          width: 48,
          fit: BoxFit.fitWidth,
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isCritical
                ? Text('Critical ${dummyCriticalUnits.length} units', style: titleMedium(Colors.red))
                : Text('Warning ${dummyWarningUnits.length} units', style: titleMedium(themeYellow)),
            isCritical
                ? Text('Units with No Motion ≥ 24h', style: bodyCommon(Colors.red))
                : Text('Units with 8h ≤ No Motion < 24h', style: bodyCommon(themeYellow)),
          ],
        ),
        Expanded(child: Container()),
        IconButton(icon: const Icon(Icons.close, color: commonGrey5), onPressed: () => Navigator.of(context).pop(), tooltip: 'Exit'),
      ],
    ),
  );
}

Widget _buildListHeader() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    decoration: const BoxDecoration(
      color: commonGrey1, // 밝은 회색 배경
      border: Border(bottom: BorderSide(color: commonGrey2, width: 1)),
    ),
    child: Row(
      children: [
        Expanded(flex: 3, child: Text('REGION', style: bodyCommon(commonGrey5), overflow: TextOverflow.ellipsis)),
        Expanded(flex: 4, child: Text('BUILDING', style: bodyCommon(commonGrey5), overflow: TextOverflow.ellipsis)),
        Expanded(flex: 2, child: Text('UNIT', style: bodyCommon(commonGrey5), overflow: TextOverflow.ellipsis)),
        Expanded(flex: 2, child: Text('LAST MOTION', style: bodyCommon(commonGrey5), overflow: TextOverflow.ellipsis)),
        Expanded(flex: 2, child: Text('STATUS', style: bodyCommon(commonGrey5), overflow: TextOverflow.ellipsis)),
      ],
    ),
  );
}

Widget _buildUnitList(List<CriticalUnit> units, bool isCritical) {
  final ScrollController scrollController = ScrollController();

  return ConstrainedBox(
    constraints: BoxConstraints(maxHeight: 400), // 리스트의 최대 높이 지정 (스크롤 가능)
    child: ScrollbarTheme(
      data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(commonGrey3), trackColor: WidgetStateProperty.all(commonGrey3)),
      child: Scrollbar(
        controller: scrollController,
        interactive: true,
        thumbVisibility: true,
        thickness: 8.0,
        child: ListView.separated(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: units.length,
          separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
          itemBuilder: (context, index) {
            final unit = units[index];
            return InkWell(
              onTap: () {
                context.pushNamed(AppRoute.unitDetail.name, pathParameters: {'buildingId': unit.building.id, 'unitId': unit.id});
                context.pop();
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text(unit.region, style: bodyCommon(commonGrey7), overflow: TextOverflow.ellipsis)),
                        Expanded(flex: 4, child: Text(unit.building.name, style: bodyCommon(commonGrey7), overflow: TextOverflow.ellipsis)),
                        Expanded(flex: 2, child: Text(unit.unit, style: bodyCommon(commonGrey7), overflow: TextOverflow.ellipsis)),
                        Expanded(
                          flex: 2,
                          child: Text(unit.lastMotionTime, style: bodyCommon(commonGrey7), overflow: TextOverflow.ellipsis),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [StatusChip(status: unit.status), const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)],
                          ),
                        ),
                      ],
                    ),
                  ),
                  index == units.length - 1
                      ? Container()
                      : Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Divider(height: 1, color: commonGrey2)),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}
