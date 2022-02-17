part of 'expandable_bottom_sheet.dart';

class _ExpandableBottomSheetHintButton extends StatelessWidget {
  const _ExpandableBottomSheetHintButton({
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final _ExpandableBottomSheetProvider expandableBottomSheetProvider =
        _ExpandableBottomSheetProvider.of(context)!;

    return expandableBottomSheetProvider.title == null ||
            expandableBottomSheetProvider.hint == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ClipOval(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Icon(
                    Icons.info_outline,
                    size: 24,
                    color: Colors.white,
                  ),
                  onTap: onTap,
                ),
              ),
            ),
          );
  }
}
