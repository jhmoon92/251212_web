import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../config/style.dart';
import '../features/manage_building/domain/unit_model.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  final ValueChanged<String> onChanged;
  final String? initialValue;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue = 'All Buildings';
  final GlobalKey _dropdownKey = GlobalKey();
  double _buttonHeight = 0;
  double _buttonWidth = 0;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue ?? 'All Buildings';
    WidgetsBinding.instance.addPostFrameCallback((_) => _getButtonSize());
  }

  void _getButtonSize() {
    final RenderBox? renderBox = _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _buttonHeight = renderBox.size.height;
        _buttonWidth = renderBox.size.width;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 360, child: _buildCustomDropdown());
  }

  Widget _buildCustomDropdown() {
    return PopupMenuButton<String>(
      offset: Offset(0, _buttonHeight),
      constraints: BoxConstraints(minWidth: _buttonWidth),
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: Container(
        key: _dropdownKey,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(border: Border.all(color: commonGrey5), borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/ic_24_office.svg",
                    width: 20,
                    fit: BoxFit.fitWidth,
                    colorFilter: const ColorFilter.mode(commonBlack, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  Text(selectedValue ?? 'Select Item', style: TextStyle(fontSize: 16, color: commonBlack)),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: commonBlack),
          ],
        ),
      ),

      itemBuilder: (BuildContext context) {
        List<String> items = buildings.map((building) => building.name).toList();
        items.insert(0, 'All Buildings');
        return items.map((String item) {
          final bool isSelected = item == selectedValue;

          return PopupMenuItem<String>(
            value: item,
            padding: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              color: isSelected ? themeYellow : Colors.white,
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/ic_24_office.svg",
                    width: 20,
                    fit: BoxFit.fitWidth,
                    colorFilter: ColorFilter.mode(isSelected ? commonWhite : commonBlack, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 4),
                  Text(item, style: TextStyle(fontSize: 16, color: isSelected ? Colors.white : commonBlack)),
                ],
              ),
            ),
          );
        }).toList();
      },

      onSelected: (String newValue) {
        setState(() {
          selectedValue = newValue;
        });
        widget.onChanged(newValue);
      },
    );
  }
}
