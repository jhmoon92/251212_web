import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../config/style.dart';
import 'input_box.dart';

class InputBoxFilter extends StatefulWidget {
  // 1. 새로운 콜백 속성 추가
  const InputBoxFilter({
    super.key,
    required this.controller,
    required this.placeHolder,
    required this.filterTitle,
    required this.filters,
    required this.onFilterSelected,
  });

  final TextEditingController controller;
  final String placeHolder;
  final String filterTitle;
  final List<String> filters;
  final ValueChanged<int> onFilterSelected;

  @override
  State<InputBoxFilter> createState() => _InputBoxFilterState();
}

class _InputBoxFilterState extends State<InputBoxFilter> {
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _lockFocus = false;

  // 2. 선택된 필터 항목의 인덱스를 저장할 상태 변수
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _hideOverlay();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_lockFocus) {
      if (!_focusNode.hasFocus) {
        _focusNode.requestFocus();
      }
      return;
    }
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  void _showOverlay() {
    _lockFocus = true;

    if (_overlayEntry != null) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _lockFocus = false;

    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    return OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    // 바깥 클릭 → overlay 닫기
                    _hideOverlay();
                    _focusNode.unfocus();
                  },
                ),
              ),
              Positioned(
                width: size.width,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0.0, size.height + 4.0),
                  child: Material(
                    elevation: 8.0,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        color: commonWhite,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: commonGrey3, width: 1),
                      ),
                      // 3. OverlayEntry 내부에서 _buildOverlayContent 호출
                      child: _buildOverlayContent(),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  // 4. 필터 리스트 항목에 선택 로직 및 아이콘 토글 로직 추가
  Widget _buildOverlayContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(widget.filterTitle, style: bodyTitle(commonBlack))),
          const SizedBox(height: 12),
          Column(
            children: [
              ...List.generate(widget.filters!.length, (index) {
                final data = widget.filters![index];
                final isSelected = _selectedIndex == index;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    widget.onFilterSelected(index);
                    _overlayEntry?.markNeedsBuild();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SvgPicture.asset(isSelected ? "assets/images/ic_24_radio_on.svg" : "assets/images/ic_24_radio_off.svg"),
                        const SizedBox(width: 8),
                        Text(data, style: bodyCommon(isSelected ? commonBlack : commonGrey5)),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InputBox(
        controller: widget.controller,
        focus: _focusNode,
        placeHolder: widget.placeHolder,
        maxLength: 50,
        icon: Padding(padding: const EdgeInsets.only(left: 8), child: SvgPicture.asset('assets/images/ic_16_search.svg')),
        onSaved: (val) {},
        textStyle: bodyCommon(commonBlack),
        textType: 'normal',
        validator: (value) {
          return null;
        },
      ),
    );
  }
}
