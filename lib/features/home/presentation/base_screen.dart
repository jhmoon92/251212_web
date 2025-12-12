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
            SvgPicture.asset("assets/images/Moni_top_logo_signiture.svg"),
            const SizedBox(width: 8),
            Text("MSMS (Moni Service Monitoring System)", style: captionCommon(commonGrey4)),
          ],
        ),
        backgroundColor: commonGrey7,
      ),
      body: Row(
        children: [
          // 1. 왼쪽 사이드바 (마스킹 기법 적용)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _isExpanded ? 240 : 70, // 겉모양(창문) 너비
            curve: Curves.easeInOut,
            color: commonGrey2,

            // [핵심 1] 창문보다 내용물이 클 때 밖으로 튀어나온 부분을 잘라냄 (에러 방지)
            clipBehavior: Clip.hardEdge,

            child: SingleChildScrollView(
              // [핵심 2] 가로 공간을 무한대로 제공하여 'RenderFlex overflowed' 에러 원천 차단
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(), // 사용자가 스크롤하지 못하게 고정
              child: Stack(
                children: [
                  Container(
                    width: 240, // [핵심 3] 내부는 접혀있든 펴져있든 항상 '넓은 상태'로 고정
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        // 1. 메뉴 리스트
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              _buildMenuItem("assets/images/ic_24_home.svg", "Home(Dashboard)", 0),
                              _buildMenuItem("assets/images/ic_24_alert.svg", "Alerts", 1),
                              _buildMenuItem("assets/images/ic_24_office.svg", "Managed Buildings", 2),
                              _buildMenuItem("assets/images/ic_24_pod.svg", "Moni Pod Assets", 3),
                              _buildMenuItem("assets/images/ic_24_people.svg", "Admin Members", 4),
                            ],
                          ),
                        ),

                        // 2. 최하단 Manager 프로필 영역
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                                  height: 32,
                                  width: 32,
                                  // 70px 상태일 때 중앙 정렬 효과를 위해 마진 조정 ( (70-20-32)/2 = 9 )
                                  margin: EdgeInsets.only(left: _isExpanded ? 8 : 9),
                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: themeYellow),
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    "assets/images/ic_24_person.svg",
                                    width: 24,
                                    height: 24,
                                    colorFilter: const ColorFilter.mode(commonWhite, BlendMode.srcIn),
                                  ),
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
                                      Text("Manager", style: bodyCommon(commonGrey7), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      SizedBox(width: 80),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _viewSignOut = !_viewSignOut;
                                          });
                                        },
                                        child: const Icon(Icons.more_vert, size: 20, color: commonGrey6),
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
                  _viewSignOut
                      ? Positioned(
                        bottom: 54,
                        right: 16,
                        child: InkWell(
                          onTap: () {
                            context.goNamed(AppRoute.signIn.name);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(color: commonWhite, borderRadius: BorderRadius.circular(8)),
                            child: Text("Sign Out", style: bodyTitle(commonGrey5), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      )
                      : Container(),
                ],
              ),
            ),
          ),
          Expanded(child: Padding(padding: EdgeInsets.only(left: 16, right: 16, top: 16), child: widget.child)),

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
                ? commonGrey3.withOpacity(0.5)
                : commonGrey2,
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
                    colorFilter: ColorFilter.mode(selectMenu == index ? commonWhite : commonGrey7, BlendMode.srcIn),
                  ),
                  title == 'Alerts' && alertList.where((alert) => alert.isNew).isNotEmpty
                      ? Positioned(
                        top: 0,
                        right: 0,
                        child: Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red)),
                      )
                      : Container(),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedOpacity(
              opacity: _isExpanded ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                title,
                style: selectMenu == index ? bodyTitle(commonWhite) : bodyCommon(commonGrey7),
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
                    margin: const EdgeInsets.only(left: 104),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
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

Widget topTitle(String title, String? subtitle, DateTime lastUpdatedTime, VoidCallback onReload) {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: headLineSmall(commonBlack)),
                  subtitle != null ? Text(subtitle, style: bodyCommon(commonGrey5)) : Container(),
                ],
              ),
              Expanded(child: Container()),
              if (!hideUpdateText)
                Text('Updated date ${DateFormat('yyyy-MM-dd HH:mm:ss').format(lastUpdatedTime)}', style: bodyCommon(commonGrey5)),
              if (!hideUpdateText) const SizedBox(width: 8),
              InkWell(
                onTap: onReload,
                child: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: commonGrey2, borderRadius: BorderRadius.circular(8)),
                  child: SvgPicture.asset("assets/images/ic_24_reload.svg"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      );
    },
  );
}
