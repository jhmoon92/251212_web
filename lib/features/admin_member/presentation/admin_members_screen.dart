import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common_widgets/button.dart';
import '../../../config/style.dart';
import 'invite_member_dialog.dart';
import 'memeber_detail_dialog.dart';

class MemberCardData {
  final String name;
  final String role;
  final bool isActive;
  final String accountEmail;
  final String phoneNumber;
  final String assignedRegion;

  MemberCardData({
    required this.name,
    required this.role,
    required this.isActive,
    required this.accountEmail,
    required this.phoneNumber,
    required this.assignedRegion,
  });
}

class AdminMembersScreen extends ConsumerStatefulWidget {
  const AdminMembersScreen({super.key});

  @override
  ConsumerState<AdminMembersScreen> createState() => _AdminMembersScreenState();
}

class _AdminMembersScreenState extends ConsumerState<AdminMembersScreen> {
  final List<MemberCardData> members = [
    // 1. 최고 관리자 (Supervisor)
    MemberCardData(
      name: 'Tanaka',
      role: 'MASTER',
      isActive: true,
      accountEmail: 'tanaka.sup@monipod.jp',
      phoneNumber: '+81-3-1234-5678',
      assignedRegion: 'Global Access', // 전역 관리자
    ),
    // 2. 간토 지역 관리자 (Manager, Active)
    MemberCardData(
      name: 'Sato',
      role: 'SUBMASTER (MANAGER)',
      isActive: true,
      accountEmail: 'sato.mngr@monipod.jp',
      phoneNumber: '+81-3-2345-6789',
      assignedRegion: 'Kanto (Tokyo)', // 관동 지방 (도쿄)
    ),
    // 3. 간사이 지역 설치 기술자 (Installer, Active)
    MemberCardData(
      name: 'Kato',
      role: 'SUBMASTER (INSTALLER)',
      isActive: true,
      accountEmail: 'kato.inst@monipod.jp',
      phoneNumber: '+81-6-3456-7890',
      assignedRegion: 'Kansai (Osaka)', // 관서 지방 (오사카)
    ),
    // 4. 비활성화된 계정 (Inactive, Manager) - 홋카이도
    MemberCardData(
      name: 'Yamada',
      role: 'SUBMASTER (MANAGER)',
      isActive: false, // 🚨 비활성화 상태
      accountEmail: 'yamada.off@monipod.jp',
      phoneNumber: '+81-11-4567-8901',
      assignedRegion: 'Hokkaido', // 홋카이도
    ),
    // 5. 주부 지역 신규 설치 기술자 (New Installer) - 나고야
    MemberCardData(
      name: 'Suzuki',
      role: 'SUBMASTER (INSTALLER)',
      isActive: true,
      accountEmail: 'suzuki.new@monipod.jp',
      phoneNumber: '+81-52-5678-9012',
      assignedRegion: 'Chubu (Nagoya)', // 중부 지방 (나고야)
    ),
    // 6. 규슈 지역 예비 관리자 (Reserve Manager) - 후쿠오카
    MemberCardData(
      name: 'Takahashi',
      role: 'SUBMASTER (MANAGER)',
      isActive: false,
      accountEmail: 'takahashi.res@monipod.jp',
      phoneNumber: '+81-92-6789-0123',
      assignedRegion: 'Kyushu (Fukuoka)', // 규슈 지방 (후쿠오카)
    ),
    // 7. 도호쿠 지역 기술자 (Tohoku) - 센다이
    MemberCardData(
      name: 'Kobayashi',
      role: 'SUBMASTER (INSTALLER)',
      isActive: false,
      accountEmail: 'koba.field@monipod.jp',
      phoneNumber: '+81-22-7890-1234',
      assignedRegion: 'Tohoku (Sendai)', // 도호쿠 지방 (센다이)
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [_buildHeader(), const SizedBox(height: 32), _buildResponsiveMemberGrid()]),
      ),
    );
  }

  Widget _buildHeader() {
    // 📐 Breakpoint 설정: 이 너비(예: 600.0)보다 좁아지면 줄 바꿈 시작
    const double breakpoint = 600.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        // 1. 넓은 화면 (maxWidth > breakpoint): Row와 Expanded를 사용해 양 끝 정렬 유지
        if (constraints.maxWidth > breakpoint) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment.end 대신 SpaceBetween 효과를 내기 위해 Expanded를 사용
            children: [
              // 제목/설명 Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Admin Members', style: headLineSmall(commonBlack)),
                  Text('Manage system administrators and roles', style: bodyCommon(commonGrey5)),
                ],
              ),
              // 남은 공간을 모두 차지하여 버튼을 오른쪽으로 밀어내는 Spacer 역할
              Expanded(child: Container()),
              // 버튼
              addButton('Invite Member', () {
                showInviteMemberDialog(context);
              }),
            ],
          );
        } else {
          // 2. 좁은 화면 (maxWidth <= breakpoint): Wrap을 사용하여 공간 부족 시 버튼이 다음 줄로 내려가게 함
          return Wrap(
            spacing: 16.0, // 수평 간격
            runSpacing: 16.0, // 줄 바꿈 시 수직 간격
            crossAxisAlignment: WrapCrossAlignment.center,
            // 좁은 화면에서는 제목과 버튼을 순서대로 배치하고, 공간 부족 시 줄 바꿈
            children: [
              // 제목/설명 Column (화면 너비 전체를 차지하도록 제약)
              SizedBox(
                width: constraints.maxWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admin Members', style: headLineSmall(commonBlack)),
                    Text('Manage system administrators and roles', style: bodyCommon(commonGrey5)),
                  ],
                ),
              ),
              // 버튼 (좁아지면 아래로 내려옴)
              SizedBox(
                width: 158,
                child: addButton('Invite Member', () {
                  showInviteMemberDialog(context);
                }),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildResponsiveMemberGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        const double minCardWidth = 300;
        const double spacing = 16.0;

        int crossAxisCount = ((screenWidth + spacing) / (minCardWidth + spacing)).floor();
        int actualCrossAxisCount = crossAxisCount.clamp(1, 4);
        final double itemWidth = (screenWidth - (actualCrossAxisCount - 1) * spacing) / actualCrossAxisCount;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children:
              members.map((data) {
                return SizedBox(
                  width: itemWidth,
                  child: MemberCard(data: data),
                );
              }).toList(),
        );
      },
    );
  }
}

class MemberCard extends ConsumerStatefulWidget {
  final MemberCardData data;

  const MemberCard({required this.data, super.key});

  @override
  ConsumerState<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends ConsumerState<MemberCard> {
  bool _isOverlayVisible = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: commonWhite,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: commonGrey2, width: 2),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            widget.data.role == 'MASTER'
                                ? themeYellow20
                                : widget.data.role == 'SUBMASTER (MANAGER)'
                                ? themeBlue20
                                : commonGrey2,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color:
                              widget.data.role == 'MASTER'
                                  ? themeYellow.withOpacity(0.3)
                                  : widget.data.role == 'SUBMASTER (MANAGER)'
                                  ? themeBlue.withOpacity(0.3)
                                  : commonGrey5.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        widget.data.role,
                        style: captionTitle(
                          widget.data.role == 'MASTER'
                              ? themeYellow
                              : widget.data.role == 'SUBMASTER (MANAGER)'
                              ? themeBlue
                              : commonGrey6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              widget.data.role == 'MASTER'
                                  ? themeYellow
                                  : widget.data.role == 'SUBMASTER (MANAGER)'
                                  ? themeBlue
                                  : commonGrey5,
                          radius: 24,
                          child: Text(widget.data.name[0], style: titleLarge(commonWhite)),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.data.name, style: titleLarge(commonBlack)),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: widget.data.isActive ? Colors.lightGreen : commonGrey5,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.data.isActive ? 'Active' : 'Inactive',
                                  style: captionPoint(widget.data.isActive ? commonBlack : commonGrey5),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        InkWell(
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
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.email_outlined, size: 20, color: commonGrey5),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  widget.data.accountEmail,
                                  style: bodyPoint(commonGrey6),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              // SvgPicture.asset(
                              //   'assets/images/ic_32_call.svg',
                              //   width: 22,
                              //   fit: BoxFit.fitWidth,
                              //   colorFilter: ColorFilter.mode(commonGrey5, BlendMode.srcIn),
                              // ),
                              Icon(Icons.phone, size: 20, color: commonGrey6),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  widget.data.phoneNumber,
                                  style: bodyPoint(commonGrey6),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(margin: EdgeInsets.symmetric(horizontal: 8), height: 1, color: commonGrey2),
                    const SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ASSIGNED TO', style: captionTitle(commonGrey6), overflow: TextOverflow.ellipsis, maxLines: 1),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/images/ic_24_location.svg",
                                width: 20,
                                fit: BoxFit.fitWidth,
                                colorFilter: ColorFilter.mode(pointGreen, BlendMode.srcIn),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  widget.data.assignedRegion,
                                  style: bodyPoint(commonGrey6),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                width: double.infinity,
                color: commonGrey2,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/ic_24_time.svg",
                      width: 16,
                      fit: BoxFit.fitWidth,
                      colorFilter: ColorFilter.mode(commonGrey5, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 4),
                    Text('Last access: 2023-11-25 09:30', style: captionPoint(commonGrey6), overflow: TextOverflow.ellipsis, maxLines: 1),
                  ],
                ),
              ),
            ],
          ),
        ),
        _isOverlayVisible
            ? Positioned(
          top: 112,
          right: 16,
          child: Container(
            height: 140,
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
                      showMemberDetailDialog(context, widget.data);
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
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isOverlayVisible = false;
                      });
                    },
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
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isOverlayVisible = false;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, size: 16, color: themeYellow),
                        const SizedBox(width: 4),
                        Text('Suspend', style: bodyCommon(themeYellow)),
                      ],
                    ),
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
}
