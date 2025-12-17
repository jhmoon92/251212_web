import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moni_pod_web/common_widgets/status_chip.dart';
import 'package:moni_pod_web/config/style.dart';
import 'package:moni_pod_web/router.dart';

import '../../../common_widgets/button.dart';
import '../../../common_widgets/input_box.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topTitle('Managed Buildings', 'Monitor and manage your properties', _lastUpdatedTime, () {
            setState(() {
              _lastUpdatedTime = DateTime.now();
            });
          }),

          LayoutBuilder(
            builder: (context, constraints) {
              final double screenWidth = constraints.maxWidth;
              const double threshold = 900;
              final Widget inputBox = ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 408),
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
                  height: 40,
                  width: 116,
                  decoration: BoxDecoration(color: themeYellow, borderRadius: BorderRadius.circular(4)),
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

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                const double breakpointLarge = 1100.0; // 3분할 -> 2분할 전환점
                const double breakpointMedium = 800.0; // 2분할 -> 1분할 전환점
                const double spacing = 24.0;
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
                              child: Container(height: 338, width: itemWidth, child: BuildingCard(building: data)),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: commonBlack.withOpacity(0.25), offset: const Offset(0, 4), blurRadius: 4, spreadRadius: 0)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 72,
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:
                          widget.building.hasAlert
                              ? warningRedBg2
                              : widget.building.warningUnit != 0
                              ? cautionYellowBg2
                              : successGreenBg2,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 24),
                        Expanded(child: Text(widget.building.name, style: headLineSmall(commonBlack), overflow: TextOverflow.ellipsis)),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isOverlayVisible = !_isOverlayVisible;
                            });
                          },
                          child: const Icon(Icons.more_vert, size: 24, color: commonGrey7),
                        ),
                        const SizedBox(width: 24),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 160,
                    child: Row(
                      children: [
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/ic_24_location.svg',
                                    colorFilter: ColorFilter.mode(commonGrey6, BlendMode.srcIn),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Text(
                                        widget.building.address,
                                        style: bodyCommon(commonGrey6),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/ic_24_person.svg',
                                    colorFilter: ColorFilter.mode(commonGrey6, BlendMode.srcIn),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Text(
                                        widget.building.manager,
                                        style: bodyCommon(commonGrey6),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Image.asset("assets/images/img_default_building.png", height: 160, fit: BoxFit.fitHeight),
                      ],
                    ),
                  ),
                ],
              ),
              _isOverlayVisible
                  ? Positioned(
                    top: 60,
                    right: 20,
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
          Container(height: 1, color: commonGrey3),
          Container(
            height: 103,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
              color: commonWhite,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StatusChip(status: 'total'),
                      const SizedBox(height: 12),
                      Text(widget.building.totalUnit.toString(), style: bodyTitle(commonBlack)),
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
                      Text(widget.building.criticalUnit.toString(), style: titleSmall(Colors.red)),
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
                      Text(widget.building.warningUnit.toString(), style: titleSmall(themeYellow)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
