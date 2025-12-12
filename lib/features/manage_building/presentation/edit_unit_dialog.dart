import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common_widgets/button.dart';
import '../../../common_widgets/custom_dialog.dart';
import '../../../common_widgets/input_box.dart';
import '../../../config/style.dart';
import '../domain/unit_model.dart';

const String googleApiKey = 'AIzaSyBUc2bj_VUyH-kmgsFJxDgT4OXBUQBp2O0';

class Manager {
  final String name;
  final String id;
  final bool isMaster;

  Manager({required this.name, required this.id, this.isMaster = false});
}

void showEditUnitDialog(BuildContext context, Unit unit) {
  showCustomDialog(context: context, title: 'Edit Unit', content: SizedBox(width: 500, height: 410, child: EditUnitDialog(unit: unit)));
}

class EditUnitDialog extends ConsumerStatefulWidget {
  const EditUnitDialog({required this.unit, super.key});

  final Unit unit;
  @override
  ConsumerState<EditUnitDialog> createState() => _EditUnitDialogState();
}

const String unassignedInstallerId = 'none';

class _EditUnitDialogState extends ConsumerState<EditUnitDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _unitNumberController = TextEditingController();
  final TextEditingController _residentNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _unitNumberController.text = widget.unit.number;
    _residentNameController.text = widget.unit.resident.name;
    _phoneNumberController.text = widget.unit.resident.phone;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _unitNumberController.dispose();
    _residentNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20), // 좌우 패딩만 유지
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    inputText(
                      'Unit Number',
                      '# e.g. 101',
                      _unitNumberController,
                      const Icon(Icons.tag_sharp, color: Colors.grey),
                      isRequired: true,
                    ),
                    const SizedBox(height: 24),
                    Container(height: 1, color: commonGrey2),
                    const SizedBox(height: 24),
                    Text("RESIDENT INFORMATION", style: bodyTitle(commonGrey5)),
                    const SizedBox(height: 16),
                    inputText('Resident Name', 'Unassigned', _residentNameController, const Icon(Icons.person_outline, color: Colors.grey)),
                    const SizedBox(height: 24),
                    inputText(
                      'Phone Number',
                      'e.g. 010-1234-5678',
                      _phoneNumberController,
                      const Icon(Icons.phone_outlined, color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: commonGrey2,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: bodyTitle(commonGrey4)),
                ),
                const SizedBox(width: 16),
                addButton('Save Changes', () {}, imageWidget: const Icon(Icons.check, color: commonWhite, size: 24)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onPressed, bool isEnabled) {
    return InkWell(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: isEnabled ? commonWhite : commonGrey2,
          border: Border.all(color: isEnabled ? commonGrey4 : commonGrey3),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 20, color: isEnabled ? commonGrey7 : commonGrey5),
      ),
    );
  }

  Widget inputText(String title, String hint, TextEditingController controller, Widget icon, {bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: bodyTitle(commonGrey7),
            children: [if (isRequired) TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontSize: 14))],
          ),
        ),
        const SizedBox(height: 4),
        InputBox(
          controller: controller,
          label: hint,
          maxLength: 32,
          isErrorText: true,
          icon: icon,
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
