part of 'expandable_bottom_sheet.dart';

class _ExpandableBottomSheetHintBubble extends StatelessWidget {
  const _ExpandableBottomSheetHintBubble({
    required this.isVisible,
    Key? key,
  }) : super(key: key);

  final bool? isVisible;

  @override
  Widget build(BuildContext context) {
    final _ExpandableBottomSheetProvider expandableBottomSheetProvider =
        _ExpandableBottomSheetProvider.of(context)!;

    return expandableBottomSheetProvider.hint == null
        ? const SizedBox.shrink()
        : Visibility(
            visible: isVisible!,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: _getHintMessageWidth(context),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  8,
                ),
                color: Colors.blue,
              ),
              child: Text(
                expandableBottomSheetProvider.hint!,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
            ),
          );
  }

  double _getHintMessageWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * 0.7;
}
