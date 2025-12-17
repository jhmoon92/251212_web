import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moni_pod_web/common_widgets/input_box.dart';
import 'package:moni_pod_web/config/style.dart';
import '../../../common_widgets/button.dart';
import '../../../common_widgets/custom_dialog.dart';
import 'admin_members_screen.dart';

void showMemberDetailDialog(BuildContext context, MemberCardData member) {
  showCustomDialog(
    context: context,
    title: 'Member Detail',
    content: SizedBox(width: 680, height: 320, child: MemberDetailDialog(member: member)),
  );
}

class MemberDetailDialog extends StatefulWidget {
  const MemberDetailDialog({required this.member, super.key});

  final MemberCardData member;

  @override
  State<MemberDetailDialog> createState() => _MemberDetailDialogState();
}

class _MemberDetailDialogState extends State<MemberDetailDialog> {
  // ⭐️ 상태: 편집 모드 여부
  bool _isEditing = true;

  // ⭐️ 컨트롤러: 편집 시 값 관리를 위해 사용
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _regionController;

  @override
  void initState() {
    super.initState();
    // 초기값 설정
    _nameController = TextEditingController(text: widget.member.name);
    _emailController = TextEditingController(text: widget.member.accountEmail);
    _phoneController = TextEditingController(text: widget.member.phoneNumber);
    _regionController = TextEditingController(text: widget.member.assignedRegion);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 4, color: themeYellow),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                _buildInfoField('Account', _emailController, _isEditing),
                const SizedBox(height: 28),
                _buildInfoField('Phone', _phoneController, _isEditing),
                const SizedBox(height: 28),
                _buildInfoField('Assignments', _regionController, _isEditing),
              ],
            ),
          ),
        ),
        Container(padding: EdgeInsets.only(right: 24, bottom: 24), alignment: Alignment.bottomRight,child: addButton('Send Invite', () {},
            imageWidget: Container()))
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: commonGrey2,
            borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
          ),
          child: Row(
            children: [
              Text("Member Details", style: titleLarge(commonBlack)),
              Expanded(child: Container()),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset("assets/images/ic_32_circle_cancel.svg", height: 32, width: 32, fit: BoxFit.none),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: commonGrey1),

          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    widget.member.role == 'MASTER'
                        ? themeYellow
                        : widget.member.role == 'SUBMASTER (MANAGER)'
                        ? themeBlue
                        : commonGrey5,
                radius: 24,
                child: Text(widget.member.name[0], style: titleLarge(commonWhite)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.member.name, style: titleLarge(commonBlack)),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: widget.member.isActive ? Colors.lightGreen : commonGrey5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.member.isActive ? 'Active' : 'Inactive',
                        style: captionPoint(widget.member.isActive ? commonBlack : commonGrey5),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Stack(
                children: [
                  Positioned.fill(child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.white))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          widget.member.role == 'MASTER'
                              ? themeYellow20
                              : widget.member.role == 'SUBMASTER (MANAGER)'
                              ? themeBlue20
                              : commonGrey2,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color:
                            widget.member.role == 'MASTER'
                                ? themeYellow.withOpacity(0.3)
                                : widget.member.role == 'SUBMASTER (MANAGER)'
                                ? themeBlue.withOpacity(0.3)
                                : commonGrey5.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.member.role,
                      style: captionTitle(
                        widget.member.role == 'MASTER'
                            ? themeYellow
                            : widget.member.role == 'SUBMASTER (MANAGER)'
                            ? themeBlue
                            : commonGrey6,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     // 이름 및 상태
        //     Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //
        //         Text(widget.member.name, style: titleLarge(commonBlack)),
        //         Text(
        //             widget.member.isActive ? 'Active' : 'Inactive',
        //             style: bodyCommon(widget.member.isActive ? Colors.green : Colors.red)
        //         ),
        //       ],
        //     ),
        //
        //     // ElevatedButton(
        //     //   onPressed: () {
        //     //     setState(() {
        //     //       if (_isEditing) {
        //     //         _saveProfile();
        //     //         _isEditing = false;
        //     //       } else {
        //     //         _isEditing = true;
        //     //       }
        //     //     });
        //     //   },
        //     //   style: ElevatedButton.styleFrom(
        //     //     backgroundColor: _isEditing ? Colors.green : Colors.blue, // 저장/편집 색상 구분
        //     //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        //     //   ),
        //     //   child: Text(
        //     //       _isEditing ? 'Save Changes' : 'Edit Profile',
        //     //       style: bodyCommon(commonWhite)
        //     //   ),
        //     // ),
        //   ],
        // ),
      ],
    );
  }

  // 정보 표시/입력 필드 위젯
  Widget _buildInfoField(String label, TextEditingController controller, bool isEditable) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 24, child: Text(label, style: titleCommon(commonBlack))),
        Expanded(
          flex: 44,
          child: Stack(
            children: [
              InputBox(
                controller: controller,
                readOnly: !isEditable,
                label: label,
                maxLength: 32,
                isErrorText: true,
                onSaved: (val) {},
                textStyle: bodyCommon(commonBlack),
                textType: 'normal',
                validator: (value) {
                  return null;
                },
              ),
              isEditable ? Container() : Positioned.fill(child: Container(color: Colors.transparent)),
            ],
          ),
        ),
      ],
    );
  }

  // ⭐️ 저장 로직 (더미)
  void _saveProfile() {
    // 1. 여기서 API를 호출하여 수정된 데이터를 서버에 전송합니다.
    // final updatedData = MemberCardData(
    //   name: _nameController.text,
    //   accountEmail: _emailController.text,
    //   // ... 나머지 필드 ...
    // );

    // 2. 서버 통신 성공 시, GoRouter/Riverpod 등을 이용해 UI 상태를 업데이트합니다.
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved successfully!')));
  }
}
