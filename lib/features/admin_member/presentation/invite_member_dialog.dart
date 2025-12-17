import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common_widgets/button.dart';
import '../../../common_widgets/custom_dialog.dart';
import '../../../common_widgets/input_box.dart';
import '../../../config/style.dart';

void showInviteMemberDialog(BuildContext context) {
  showCustomDialog(context: context, title: 'Invite Member', content: const SizedBox(width: 680, height: 460, child: InviteMemberDialog()));
}

class InviteMemberDialog extends ConsumerStatefulWidget {
  const InviteMemberDialog({super.key});

  @override
  ConsumerState<InviteMemberDialog> createState() => _InviteMemberDialogState();
}

class _InviteMemberDialogState extends ConsumerState<InviteMemberDialog> {
  final String selectedSubRole = 'Manager';
  bool isManager = true;
  String assignGroup = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Widget _buildRadioOption({
    required String label,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged, // 상태 관리 로직 필요
            activeColor: Colors.blue,
          ),
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 4, color: themeYellow),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text('Send an invitation to a new administrator.', style: bodyTitle(commonGrey6)),
                const SizedBox(height: 24),
                _buildInputField(context, 'Name', 'Tanaka', Icons.person_outline, nameController),
                const SizedBox(height: 28),
                _buildInputField(context, 'Email', 'tanaka@example.com', Icons.email_outlined, emailController),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(flex: 24, child: Text('Select Role', style: titleCommon(commonBlack))),
                    Expanded(
                      flex: 44,
                      child: Container(
                        decoration: BoxDecoration(
                          color: commonWhite,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: commonGrey2, width: 1),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isManager = true;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isManager ? themeYellow : commonWhite,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text('Manager', style: bodyTitle(isManager ? commonWhite : commonGrey5)),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isManager = false;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: !isManager ? themeYellow : commonWhite,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text('Installer', style: bodyTitle(!isManager ? commonWhite : commonGrey5)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(flex: 24, child: Text('Assign Group', style: titleCommon(commonBlack))),
                    const SizedBox(height: 4),
                    Expanded(
                      flex: 44,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: commonGrey2, width: 1.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: commonGrey2, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(color: themeYellow, width: 2.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        hint: Text('Select Region...', style: bodyCommon(commonGrey7)),
                        value: null,
                        items:
                            ['Kanto (Tokyo)', 'Kansai (Osaka)', 'Hokkaido', 'Chubu (Nagoya)'].map((String value) {
                              return DropdownMenuItem<String>(value: value, child: Text(value, style: bodyCommon(commonGrey7)));
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            assignGroup = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        Container(padding: EdgeInsets.only(right: 24, bottom: 24), alignment: Alignment.bottomRight,child: addButton('Send Invite', () {},
            imageWidget: Container())),
      ],
    );
  }

  Widget _buildInputField(BuildContext context, String label, String hint, IconData icon, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 24, child: Text(label, style: titleCommon(commonBlack))),
        Expanded(
          flex: 44,
          child: InputBox(
            controller: controller,
            label: hint,
            maxLength: 32,
            isErrorText: true,
            onSaved: (val) {},
            textStyle: bodyCommon(commonBlack),
            textType: 'normal',
            validator: (value) {
              return null;
            },
          ),
        ),
      ],
    );
  }
}
