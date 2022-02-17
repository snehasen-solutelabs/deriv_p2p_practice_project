part of 'expandable_bottom_sheet.dart';

class _ExpandableBottomSheetTitleBar extends StatelessWidget {
  const _ExpandableBottomSheetTitleBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ExpandableBottomSheetProvider expandableBottomSheetProvider =
        _ExpandableBottomSheetProvider.of(context)!;

    final _ExpandableBottomSheetController controller =
        expandableBottomSheetProvider.controller;

    return StreamBuilder<bool>(
      stream: controller.hintStateStream,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) => Column(
        children: <Widget>[
          if (expandableBottomSheetProvider.showToggler!)
            const _ExpandableBottomSheetToggler(),
          Container(
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                const _ExpandableBottomSheetTitle(),
                if (_isLeftActionVisible(expandableBottomSheetProvider))
                  Positioned(
                    child: expandableBottomSheetProvider.leftAction!,
                    left: 16,
                  ),
                if (_isRightActionVisible(expandableBottomSheetProvider))
                  Positioned(
                    child: expandableBottomSheetProvider.rightAction!,
                    right: 16,
                  ),
                Positioned(
                  child: _ExpandableBottomSheetHintButton(
                    onTap: () => controller.isHintOpen = !controller.isHintOpen,
                  ),
                  right: 16,
                ),
                Positioned(
                  child: _ExpandableBottomSheetHintBubble(
                    isVisible: snapshot.data,
                  ),
                  right: controller.isOpen ? 44 : 18,
                  bottom: controller.isOpen ? 0 : 42,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isLeftActionVisible(_ExpandableBottomSheetProvider provider) =>
      provider.title != null && provider.leftAction != null;

  bool _isRightActionVisible(_ExpandableBottomSheetProvider provider) =>
      provider.title != null &&
      provider.hint == null &&
      provider.rightAction != null;
}
