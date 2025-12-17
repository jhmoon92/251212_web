import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moni_pod_web/config/style.dart';
import '../../../common_widgets/status_chip.dart';
import '../../../router.dart';
import '../../manage_building/domain/unit_model.dart';

void showCriticalUnitsDialog(BuildContext context, bool isCritical) {
  showDialog(
    context: context,
      useRootNavigator: true,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SizedBox(
          width: 900,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHeader(context, isCritical),
              Container(height: 4,color: isCritical ? warningRed : themeYellow),
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
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    decoration: BoxDecoration(
      color: commonWhite,
      borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
    ),
    child: Row(
      children: [
        isCritical
            ? Text('Critical ${dummyCriticalUnits.length} units', style: titleLarge(warningRed))
            : Text('Warning ${dummyWarningUnits.length} units', style: titleLarge(themeYellow)),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: isCritical
              ? Text('Critical Alert : No Movement for over 24 hours.', style: captionCommon(commonGrey5))
              : Text('Warning Alert: No Movement between 8 and 24 hours.', style: captionCommon(commonGrey5)),
        ),
        Expanded(child: Container()),
        IconButton(icon: const Icon(Icons.close, color: commonGrey5), onPressed: () => Navigator.of(context).pop(), tooltip: 'Exit'),
      ],
    ),
  );
}

Widget _buildListHeader() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 24),
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: const BoxDecoration(
      color: commonWhite, // 밝은 회색 배경
      border: Border(bottom: BorderSide(color: commonGrey5, width: 1)),
    ),
    child: Row(
      children: [
        Expanded(flex: 3, child: Text('REGION', style: bodyTitle(commonBlack), overflow: TextOverflow.ellipsis)),
        Expanded(flex: 4, child: Text('BUILDING', style: bodyTitle(commonBlack), overflow: TextOverflow.ellipsis)),
        Expanded(flex: 2, child: Text('UNIT', style: bodyTitle(commonBlack), overflow: TextOverflow.ellipsis)),
        Expanded(flex: 2, child: Text('LAST MOTION', style: bodyTitle(commonBlack), overflow: TextOverflow.ellipsis)),
        Expanded(flex: 2, child: Text('STATUS', style: bodyTitle(commonBlack), overflow: TextOverflow.ellipsis)),
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
          separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16, color: commonGrey3),
          itemBuilder: (context, index) {
            final unit = units[index];
            return InkWell(
              onTap: () {
                context.pushNamed(AppRoute.unitDetail.name, pathParameters: {'buildingId': unit.building.id, 'unitId': unit.id});
                context.pop();
              },
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text(unit.region, style: bodyCommon(commonBlack), overflow: TextOverflow.ellipsis)),
                        Expanded(flex: 4, child: Text(unit.building.name, style: bodyCommon(commonBlack), overflow: TextOverflow.ellipsis)),
                        Expanded(flex: 2, child: Text(unit.unit, style: bodyCommon(commonBlack), overflow: TextOverflow.ellipsis)),
                        Expanded(
                          flex: 2,
                          child: Text(unit.lastMotionTime, style: bodyCommon(commonBlack), overflow: TextOverflow.ellipsis),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [StatusChip(status: unit.status), const Icon(Icons.arrow_forward_ios, size: 12, color: commonBlack)],
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
