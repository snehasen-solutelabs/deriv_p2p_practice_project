part of 'expandable_bottom_sheet.dart';

class _ExpandableBottomSheetProvider extends InheritedWidget {
  const _ExpandableBottomSheetProvider({
    required Widget child,
    required this.controller,
    this.upperContent,
    this.lowerContent,
    this.title,
    this.hint,
    this.leftAction,
    this.rightAction,
    this.showToggler,
    this.changeStateDuration,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.onTogglerTap,
  }) : super(child: child);

  final _ExpandableBottomSheetController controller;

  final Widget? upperContent;
  final Widget? lowerContent;

  final String? title;
  final String? hint;

  final Widget? leftAction;
  final Widget? rightAction;

  final bool? showToggler;

  final Duration? changeStateDuration;

  final GestureDragUpdateCallback? onVerticalDragUpdate;
  final GestureDragEndCallback? onVerticalDragEnd;

  final VoidCallback? onTogglerTap;

  static _ExpandableBottomSheetProvider? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_ExpandableBottomSheetProvider>();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
