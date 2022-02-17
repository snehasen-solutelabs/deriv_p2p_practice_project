part of 'expandable_bottom_sheet.dart';

typedef HeightCalculatedHandler = void Function(double);

class _ExpandableBottomSheetUpperContent extends StatelessWidget {
  const _ExpandableBottomSheetUpperContent({
    required this.onHeightCalculated,
    this.onHeightChanged,
    Key? key,
  }) : super(key: key);

  final HeightCalculatedHandler onHeightCalculated;
  final VoidCallback? onHeightChanged;

  @override
  Widget build(BuildContext context) {
    final Widget? upperContent =
        _ExpandableBottomSheetProvider.of(context)!.upperContent;

    return Builder(
      builder: (BuildContext context) {
        SchedulerBinding.instance!.addPostFrameCallback(
          (_) => onHeightCalculated(context.size!.height),
        );

        return NotificationListener<LayoutChangedNotification>(
          onNotification: (_) => _heightChangeHandler(context),
          child: SizeChangedLayoutNotifier(
            child: upperContent ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  bool _heightChangeHandler(BuildContext context) {
    Future<void>(() {
      onHeightCalculated(context.size!.height);
      onHeightChanged?.call();
    });

    return true;
  }
}
