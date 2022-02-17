import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

part 'expandable_bottom_sheet_controller.dart';

part 'expandable_bottom_sheet_hint_bubble.dart';

part 'expandable_bottom_sheet_hint_button.dart';

part 'expandable_bottom_sheet_lower_content.dart';

part 'expandable_bottom_sheet_provider.dart';

part 'expandable_bottom_sheet_title.dart';

part 'expandable_bottom_sheet_title_bar.dart';

part 'expandable_bottom_sheet_toggler.dart';

part 'expandable_bottom_sheet_upper_content.dart';

/// Expandable bottom sheet widget
class ExpandableBottomSheet extends StatefulWidget {
  /// This widget helps showing an expandable bottom sheet with [title], [upperContent] and [lowerContent] parts.
  ///
  /// All properties are optional.
  /// You can set [openMaximized] to true, if you want to open bottom sheet in full size.
  /// By default height in minimize state is calculated by [upperContent],
  /// but if you set [maxHeight] and [lowerContent], that value will be overridden.
  const ExpandableBottomSheet({
    Key? key,
    this.upperContent,
    this.lowerContent,
    this.title,
    this.hint,
    this.leftAction,
    this.rightAction,
    this.showToggler = true,
    this.maxHeight,
    this.openMaximized = false,
    this.dismissable = true,
    this.changeStateDuration = const Duration(milliseconds: 150),
    this.onOpen,
    this.onClose,
    this.onToggle,
    this.onDismiss,
  }) : super(key: key);

  /// Upper content widget
  ///
  /// This part will be shown in close and open state
  final Widget? upperContent;

  /// Lower content widget
  ///
  /// This part will be shown in open state
  final Widget? lowerContent;

  /// Expandable bottom sheet title
  ///
  /// Title part will be invisible if [title] not set
  final String? title;

  /// Expandable bottom sheet hint
  ///
  /// Hint button will be invisible if [hint] or [title] not set
  /// If [hint] has been set, [right Action] won't be accessible anymore.
  final String? hint;

  /// Action placed on left side of the title
  final Widget? leftAction;

  /// Action placed on right side of the title
  ///
  /// If [hint] has been set, [right Action] won't be accessible anymore.
  final Widget? rightAction;

  /// Sets toggler visibility
  ///
  /// If value sets to `false`, `dragging` and `toggle` actions will be disabled.
  /// Default value is `true`
  final bool showToggler;

  /// Sets maximum height for expandable bottom sheet
  ///
  /// Expandable bottom sheet will be full screen if [maxHeight] not set
  final double? maxHeight;

  /// Opens expandable bottom sheet in maximized state
  ///
  /// Default value is `false`
  final bool openMaximized;

  /// Defines whether the bottom sheet should get closed when user swips it down.
  ///
  /// Default value is `true`.
  final bool dismissable;

  /// Change state animation duration
  ///
  /// Default value is `150 milliseconds`
  final Duration changeStateDuration;

  /// [onOpen] callback
  /// This callback will be called when expandable bottom sheet is open
  final VoidCallback? onOpen;

  /// [onClose] callback
  /// This callback will be called when expandable bottom sheet is close
  final VoidCallback? onClose;

  /// [onToggle] callback
  /// This callback will be called when toggle expandable bottom sheet
  final VoidCallback? onToggle;

  /// [onDismiss] callback
  /// This callback will be called on expandable bottom sheet dismiss
  final VoidCallback? onDismiss;

  @override
  _ExpandableBottomSheetState createState() => _ExpandableBottomSheetState();
}

class _ExpandableBottomSheetState extends State<ExpandableBottomSheet> {
  bool _isDragDirectionUp = false;
  late double _upperContentHeight;
  PointerDownEvent? _dragStartDetails;

  final _ExpandableBottomSheetController _controller =
      _ExpandableBottomSheetController();

  @override
  void initState() {
    super.initState();

    if (widget.lowerContent != null && widget.openMaximized) {
      SchedulerBinding.instance!.addPostFrameCallback(
        (_) => Future<void>.delayed(const Duration(), open),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_controller.isOpen) {
      open(withCallback: false);
    } else {
      close(withCallback: false);
    }
  }

  @override
  Widget build(BuildContext context) => _ExpandableBottomSheetProvider(
        controller: _controller,
        upperContent: widget.upperContent,
        lowerContent: widget.lowerContent,
        title: widget.title,
        hint: widget.hint,
        leftAction: widget.leftAction,
        rightAction: widget.rightAction,
        showToggler: widget.showToggler,
        changeStateDuration: widget.changeStateDuration,
        onVerticalDragEnd: widget.showToggler ? _onVerticalDragEnd : null,
        onVerticalDragUpdate: widget.showToggler ? _onVerticalDragUpdate : null,
        onTogglerTap: widget.showToggler ? _onTogglerTap : null,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragUpdate: _onVerticalDragUpdate,
                onVerticalDragEnd: _onVerticalDragEnd,
                child: Column(
                  children: <Widget>[
                    const _ExpandableBottomSheetTitleBar(),
                    _ExpandableBottomSheetUpperContent(
                      onHeightCalculated: (double height) =>
                          _upperContentHeight = height,
                      onHeightChanged: () => _controller.height =
                          _controller.isOpen ? _getAvailableHeight() : 0,
                    ),
                  ],
                ),
              ),
              widget.lowerContent == null
                  ? const SizedBox.shrink()
                  : Listener(
                      onPointerDown: (PointerDownEvent details) =>
                          _dragStartDetails = details,
                      onPointerMove: _onPointerMove,
                      onPointerUp: (PointerUpEvent details) =>
                          _onVerticalDragEnd(DragEndDetails()),
                      child: const _ExpandableBottomSheetLowerContent(),
                    ),
            ],
          ),
        ),
      );

  void _onPointerMove(PointerMoveEvent details) {
    if (_dragStartDetails == null) {
      return;
    }
    if (_hasPassedScrollThreshold(details)) {
      _onVerticalDragUpdate(
        DragUpdateDetails(
          delta: details.delta,
          globalPosition: details.position,
        ),
      );
    }
  }

  void _onVerticalDragUpdate(DragUpdateDetails data) {
    if (_controller.height - data.delta.dy > 0 &&
        _controller.height - data.delta.dy < _getAvailableHeight()) {
      _isDragDirectionUp = data.delta.dy <= 0;
      _controller.height -= data.delta.dy;
    }
  }

  void _onVerticalDragEnd(DragEndDetails data) {
    if (widget.lowerContent != null && _isDragDirectionUp) {
      open();
    } else if (widget.dismissable) {
      close(dismiss: !_controller.isOpen);
    } else {
      close();
    }
  }

  void _onTogglerTap() {
    widget.onToggle?.call();

    if (_controller.isOpen) {
      close();
    } else {
      open();
    }
  }

  void open({bool withCallback = true}) {
    if (withCallback) {
      widget.onOpen?.call();

      _closeHintBubble();
    }
    _isDragDirectionUp = true;
    _controller.height = _getAvailableHeight();
  }

  void close({
    bool withCallback = true,
    bool dismiss = false,
  }) {
    if (withCallback) {
      dismiss ? widget.onDismiss?.call() : widget.onClose?.call();

      _closeHintBubble();
    }

    _isDragDirectionUp = false;
    _controller.height = 0;

    if (dismiss) {
      Navigator.pop(context);
    }
  }

  void _closeHintBubble() {
    if (_controller.isHintOpen) {
      _controller.isHintOpen = false;
    }
  }

  bool _hasPassedScrollThreshold(PointerMoveEvent details) =>
      (details.position.dy - _dragStartDetails!.position.dy).abs() > 30;

  double _getAppBarHeight() {
    const double notificationsBarHeight = 25;
    final double? appBarMaxHeight = Scaffold.of(context).appBarMaxHeight;

    return appBarMaxHeight == null
        ? 0
        : appBarMaxHeight - notificationsBarHeight;
  }

  double _getTogglerHeight() => widget.showToggler ? 44 : 24;

  double _getTitleHeight() =>
      _getTogglerHeight() + (widget.title == null ? 0 : 48);

  double _getDeviceHeight() => MediaQuery.of(context).size.height;

  double _getAvailableHeight() {
    final double availableHeight =
        _getDeviceHeight() - _getAppBarHeight() - _getTitleHeight();

    return (widget.maxHeight == null
            ? availableHeight
            : min(widget.maxHeight!, availableHeight)) -
        _upperContentHeight;
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }
}
