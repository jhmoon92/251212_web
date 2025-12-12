import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common_widgets/custom_dialog.dart';
import '../../../common_widgets/input_box.dart';
import '../../../config/style.dart';

void showInviteMemberDialog(BuildContext context) {
  showCustomDialog(
    context: context,
    title: '',
    titleWidget: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Invite Member', style: titleLarge(commonWhite)),
        Text('Send an invitation to a new administrator.', style: bodyCommon(commonGrey2)),
      ],
    ),
    content: InviteMemberDialog(),
  );
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
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BASIC INFORMATION', style: bodyTitle(commonGrey6)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildInputField(context, 'Name', 'Tanaka', Icons.person_outline, nameController)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildInputField(context, 'Email', 'tanaka@example.com', Icons.email_outlined, emailController)),
                  ],
                ),
                const SizedBox(height: 16),
                Container(height: 1, color: commonGrey2),
                const SizedBox(height: 16),
                Text('ROLE CONFIGURATION', style: bodyTitle(commonGrey6)),
                const SizedBox(height: 16),
                Text('Select Role', style: captionTitle(commonGrey7)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isManager = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          decoration: BoxDecoration(
                            color: isManager ? themeYellow20 : Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: isManager ? themeYellow : commonGrey3, width: 1.5),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.manage_accounts, size: 30, color: isManager ? themeYellow : commonGrey3),
                              const SizedBox(height: 5),
                              Text('Manager', style: bodyTitle(isManager ? themeYellow : commonGrey3)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isManager = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          decoration: BoxDecoration(
                            color: !isManager ? themeYellow20 : Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: !isManager ? themeYellow : commonGrey3, width: 1.5),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.construction, size: 30, color: !isManager ? themeYellow : commonGrey3),
                              const SizedBox(height: 5),
                              Text('Installer', style: bodyTitle(!isManager ? themeYellow : commonGrey3)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Text('Assign Group', style: captionTitle(commonGrey7)),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: commonGrey3, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: commonGrey3, width: 1.0),
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
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: commonGrey2,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel', style: bodyTitle(commonGrey4))),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.mail_outline, size: 18),
                label: Text('Send Invite', style: bodyTitle(commonWhite)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeYellow,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ],
          ),
        )

      ],
    );
  }

  Widget _buildInputField(BuildContext context, String label, String hint, IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: captionTitle(commonGrey7)),
        const SizedBox(height: 4),
        InputBox(
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
      ],
    );
  }
}
