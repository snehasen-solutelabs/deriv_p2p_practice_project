part of 'expandable_bottom_sheet.dart';

class _ExpandableBottomSheetToggler extends StatelessWidget {
  const _ExpandableBottomSheetToggler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ExpandableBottomSheetProvider expandableBottomSheetProvider =
        _ExpandableBottomSheetProvider.of(context)!;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragUpdate: expandableBottomSheetProvider.onVerticalDragUpdate,
      onVerticalDragEnd: expandableBottomSheetProvider.onVerticalDragEnd,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 32,
          ),
          height: 4,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      onTap: expandableBottomSheetProvider.onTogglerTap,
    );
  }
}
