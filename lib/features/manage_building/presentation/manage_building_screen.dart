import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moni_pod_web/common_widgets/status_chip.dart';
import 'package:moni_pod_web/config/style.dart';
import 'package:moni_pod_web/router.dart';

import '../../../common_widgets/button.dart';
import '../../../common_widgets/input_box.dart';
import '../../../common_widgets/input_box_filter.dart';
import '../../home/presentation/base_screen.dart';
import '../../manage_building/presentation/add_building_dialog.dart';
import '../domain/unit_model.dart';
import 'edit_building_dialog.dart';

class ManageBuildingScreen extends ConsumerStatefulWidget {
  const ManageBuildingScreen({super.key});

  @override
  ConsumerState<ManageBuildingScreen> createState() => _ManageBuildingScreenState();
}

class _ManageBuildingScreenState extends ConsumerState<ManageBuildingScreen> {
  TextEditingController controller = TextEditingController();
  int? currentFilterIndex;
  String? selectedFilterValue;
  DateTime _lastUpdatedTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topTitle('Managed Buildings', 'Monitor and manage your properties',_lastUpdatedTime, () {
            setState(() {
              _lastUpdatedTime = DateTime.now();
            });
          }),
          const SizedBox(height: 16),

          LayoutBuilder(
            builder: (context, constraints) {
              final double screenWidth = constraints.maxWidth;
              const double threshold = 900;
              final Widget inputBox = ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: InputBox(
                  controller: controller,
                  label: 'Search building',
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
                  height: 48,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(color: themeYellow, borderRadius: BorderRadius.circular(8)),
                  alignment: Alignment.center,
                  child: Text('Search', style: bodyTitle(commonWhite)),
                ),
              );
              final Widget addButtonWidget = addButton('Add Building', () {
                showAddBuildingDialog(context);
              });
              if (screenWidth > threshold) {
                return Row(
                  children: [
                    inputBox,
                    const SizedBox(width: 8),
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

          const SizedBox(height: 32),

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                const double breakpointLarge = 1100.0; // 3분할 -> 2분할 전환점
                const double breakpointMedium = 800.0; // 2분할 -> 1분할 전환점
                const double spacing = 16.0;
                final double screenWidth = constraints.maxWidth;
                int crossAxisCount;
                if (screenWidth >= breakpointLarge) {
                  crossAxisCount = 3;
                } else if (screenWidth >= breakpointMedium) {
                  crossAxisCount = 2;
                } else {
                  crossAxisCount = 1;
                }
                final double totalSpacingWidth = spacing * (crossAxisCount - 1);
                final double itemWidth = (screenWidth - totalSpacingWidth) / crossAxisCount;

                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children:
                          buildings.map((data) {
                            return InkWell(
                              onTap: () {
                                context.pushNamed(AppRoute.buildingDetail.name, pathParameters: {'buildingId': data.id});
                              },
                              child: SizedBox(height: 360, width: itemWidth, child: BuildingCard(building: data)),
                            );
                          }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BuildingCard extends ConsumerStatefulWidget {
  const BuildingCard({super.key, required this.building});

  final Building building;

  @override
  ConsumerState<BuildingCard> createState() => _BuildingCardState();
}

class _BuildingCardState extends ConsumerState<BuildingCard> {
  bool _isOverlayVisible = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.building.hasAlert ? Colors.red : Colors.grey.shade300;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: widget.building.hasAlert ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: commonGrey3,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                  child: Image.asset("assets/images/img_bg_building2.JPG", fit: BoxFit.cover),
                ),
                // child: Center(child: Icon(Icons.apartment, color: Colors.white.withOpacity(0.5), size: 160)),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isOverlayVisible = !_isOverlayVisible;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: commonWhite),
                    child: const Icon(Icons.more_vert, size: 24, color: commonGrey7),
                  ),
                ),
              ),
              _isOverlayVisible
                  ? Positioned(
                    top: 46,
                    right: 8,
                    child: Container(
                      height: 90,
                      width: 100,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: commonWhite,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 2)),
                        ],
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
                                showEditBuildingDialog(context, widget.building);
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/ic_16_edit.svg",
                                    colorFilter: ColorFilter.mode(commonGrey6, BlendMode.srcIn),
                                  ),
                                  const SizedBox(width: 4),
                                  Text('Edit', style: bodyCommon(commonGrey6)),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/images/ic_16_delete.svg",
                                  colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
                                ),
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
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            height: 136,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(widget.building.name, style: headLineSmall(commonBlack), overflow: TextOverflow.ellipsis)),
                    StatusChip(status: 'critical'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 20, color: commonGrey6),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(widget.building.address, style: bodyPoint(commonGrey6), overflow: TextOverflow.ellipsis, maxLines: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // SvgPicture.asset('assets/images/ic_24_office.svg', colorFilter: ColorFilter.mode(commonGrey6, BlendMode.srcIn)),
                    Icon(Icons.manage_accounts, size: 20, color: commonGrey6),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(widget.building.manager, style: bodyPoint(commonGrey6), overflow: TextOverflow.ellipsis, maxLines: 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
                color: commonGrey1,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('TOTAL', style: captionPoint(commonBlack)),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            SvgPicture.asset("assets/images/ic_24_office.svg", width: 16, fit: BoxFit.fitWidth),
                            const SizedBox(width: 1),

                            Text(widget.building.totalUnit.toString(), style: bodyTitle(commonBlack)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 24, color: commonGrey5),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('CRITICAL', style: captionPoint(Colors.red)),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/images/ic_32_critical.svg", width: 24, fit: BoxFit.fitWidth),
                            Text(widget.building.criticalUnit.toString(), style: titleSmall(Colors.red)),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 24, color: commonGrey5),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('WARNING', style: captionPoint(themeYellow)),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/images/ic_32_warning.svg", width: 24, fit: BoxFit.fitWidth),
                            Text(widget.building.warningUnit.toString(), style: titleSmall(themeYellow)),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
