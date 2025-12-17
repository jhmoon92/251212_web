import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../config/style.dart';
import '../../../router.dart';
import '../../manage_building/domain/unit_model.dart';

class BaseScreen extends ConsumerStatefulWidget {
  const BaseScreen({super.key, required this.child});

  final Widget child;
  @override
  ConsumerState<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends ConsumerState<BaseScreen> {
  bool _isExpanded = true;
  bool _viewSignOut = false;
  int selectMenu = 0;
  int _hoveredMenuIndex = -1; // <--- 이 변수는 유지합니다.

  final List<String> _menuPaths = [
    AppRoute.home.name, // 인덱스 0: DashBoard (HomeScreen)
    AppRoute.alerts.name, // 인덱스 1: Alerts
    AppRoute.manageBuilding.name, // 인덱스 2: Managed Buildings
    AppRoute.assets.name, // 인덱스 3: Moni Pod Assets
    AppRoute.members.name, // 인덱스 4: Admin Members
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double collapseBreakpoint = 1200.0; // 임의의 기준점 (예: 800px)

    if (screenWidth < collapseBreakpoint && _isExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isExpanded = false;
          });
        }
      });
    }

    return Scaffold(
      backgroundColor: commonWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
        title: Row(
          children: [
            SvgPicture.asset("assets/images/img_logo_s_moni_resipass.svg"),
            const SizedBox(width: 8),
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text("Moni Residence Pass Management System", style: captionCommon(commonGrey3))),
          ],
        ),
        backgroundColor: commonGrey7,
      ),
      body: Row(
        children: [
          // 1. 왼쪽 사이드바 (마스킹 기법 적용)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _isExpanded ? 216 : 70, // 겉모양(창문) 너비
            curve: Curves.easeInOut,
            color: commonWhite,
            // [핵심 1] 창문보다 내용물이 클 때 밖으로 튀어나온 부분을 잘라냄 (에러 방지)
            clipBehavior: Clip.hardEdge,
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(), // 사용자가 스크롤하지 못하게 고정
              child: Stack(
                children: [
                  Container(
                    width: 216,
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        // 1. 메뉴 리스트
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              _buildMenuItem("assets/images/ic_24_home.svg", "Dashboard", 0),
                              _buildMenuItem("assets/images/ic_24_alert.svg", "Alerts", 1),
                              _buildMenuItem("assets/images/ic_24_office.svg", "Managed Buildings", 2),
                              _buildMenuItem("assets/images/ic_24_pod.svg", "Device Assets", 3),
                              _buildMenuItem("assets/images/ic_24_people.svg", "Admin Members", 4),
                            ],
                          ),
                        ),

                        // 2. 최하단 Manager 프로필 영역
                        Container(
                          padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
                          child: Row(
                            children: [
                              // 2-1. 이미지
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                                child: Container(
                                  height: 24,
                                  width: 24,
                                  // margin: EdgeInsets.only(left: _isExpanded ? 8 : 9),
                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: themeYellow),
                                  alignment: Alignment.center,
                                  child: Text("T", style: bodyTitle(commonWhite), maxLines: 1, overflow: TextOverflow.ellipsis),

                                  // child: SvgPicture.asset(
                                  //   "assets/images/ic_24_person.svg",
                                  //   width: 24,
                                  //   height: 24,
                                  //   colorFilter: const ColorFilter.mode(commonWhite, BlendMode.srcIn),
                                  // ),
                                ),
                              ),

                              // 2-2. 텍스트 (에러 없이 자연스럽게 가려짐)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Opacity(
                                  // 닫혔을 때는 투명하게 처리해서 잔상 제거 (선택사항)
                                  opacity: _isExpanded ? 1.0 : 0.0,
                                  child: Row(
                                    children: [
                                      Text("Master", style: bodyCommon(commonBlack), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      SizedBox(width: 64),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            context.goNamed(AppRoute.signIn.name);
                                            // _viewSignOut = !_viewSignOut;
                                          });
                                        },
                                        child: SvgPicture.asset("assets/images/ic_24_logout.svg"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // _viewSignOut
                  //     ? Positioned(
                  //       bottom: 44,
                  //       right: 20,
                  //       child: InkWell(
                  //         onTap: () {
                  //           context.goNamed(AppRoute.signIn.name);
                  //         },
                  //         child: Container(
                  //           padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  //           decoration: BoxDecoration(color: commonGrey2, borderRadius: BorderRadius.circular(8)),
                  //           child: Text("Sign Out", style: bodyTitle(commonGrey7), maxLines: 1, overflow: TextOverflow.ellipsis),
                  //         ),
                  //       ),
                  //     )
                  //     : Container(),
                ],
              ),
            ),
          ),
          Expanded(child: Container(color: commonGrey1, padding: EdgeInsets.only(top: 24), child: widget.child)),

          // Expanded(child: Padding(padding: EdgeInsets.all(16), child: selectMenu == 0 ? topTitle('Dashboard') : selectMenu == 1 ? ManageBuildingScreen() : AssetManagementScreen())),
        ],
      ),
    );
  }

  // 메뉴 아이템 빌더
  Widget _buildMenuItem(String iconPath, String title, int index) {
    final bool isHovered = index == _hoveredMenuIndex;
    final bool isSelected = index == selectMenu;

    return InkWell(
      onTap: () {
        setState(() {
          if (!_isExpanded) _isExpanded = true;
          selectMenu = index;
        });
        context.goNamed(_menuPaths[index]);
      },
      onHover: (isHovering) {
        setState(() {
          if (isHovering) {
            _hoveredMenuIndex = index;
          } else {
            _hoveredMenuIndex = -1;
          }
        });
      },
      child: Container(
        color:
            isSelected
                ? themeYellow
                : isHovered
                ? commonGrey1.withOpacity(0.5)
                : commonWhite,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(left: _isExpanded ? 24 : 23),
              child: Stack(
                children: [
                  SvgPicture.asset(
                    iconPath,
                    colorFilter: ColorFilter.mode(selectMenu == index ? commonWhite : commonBlack, BlendMode.srcIn),
                  ),
                  title == 'Alerts' && alertList.where((alert) => alert.isNew).isNotEmpty
                      ? Positioned(
                        top: 0,
                        right: 0,
                        child: Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: newBlue)),
                      )
                      : Container(),
                ],
              ),
            ),
            const SizedBox(width: 12),
            AnimatedOpacity(
              opacity: _isExpanded ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                title,
                style: selectMenu == index ? bodyTitle(commonWhite) : bodyCommon(commonBlack),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            title == 'Alerts' && alertList.where((alert) => alert.isNew).isNotEmpty
                ? AnimatedOpacity(
                  opacity: _isExpanded ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(left: 70),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: newBlue),
                    child: Text(
                      alertList.where((alert) => alert.isNew).length.toString(),
                      style: captionTitle(commonWhite),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                : Container(),
          ],
        ),
      ),
    );
  }
}

Widget topTitle(String title, String? subtitle, DateTime lastUpdatedTime, VoidCallback onReload, {bool isBackButton = false}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final bool hideUpdateText = constraints.maxWidth < 600;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              isBackButton
                  ? InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24, right: 12),
                      child: SvgPicture.asset(
                        'assets/images/ic_24_previous.svg',
                        colorFilter: const ColorFilter.mode(commonBlack, BlendMode.srcIn),
                      ),
                    ),
                  )
                  : Container(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: headLineSmall(commonBlack)),

                  subtitle != null
                      ? Padding(padding: EdgeInsets.only(top: 2), child: Text(subtitle, style: bodyCommon(commonGrey5)))
                      : Container(),
                ],
              ),
              Expanded(child: Container()),
              if (!hideUpdateText)
                Text('Updated date ${DateFormat('yyyy-MM-dd HH:mm:ss').format(lastUpdatedTime)}', style: bodyCommon(commonGrey6)),
              if (!hideUpdateText) const SizedBox(width: 12),
              InkWell(
                onTap: onReload,
                child: Container(
                  height: 36,
                  width: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: commonWhite, borderRadius: BorderRadius.circular(8)),
                  child: SvgPicture.asset(
                    "assets/images/ic_24_reload.svg",
                    colorFilter: const ColorFilter.mode(commonBlack, BlendMode.srcIn),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      );
    },
  );
}
