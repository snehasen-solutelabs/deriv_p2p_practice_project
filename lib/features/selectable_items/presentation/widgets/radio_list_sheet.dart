import 'package:deriv_p2p_practice_project/api/models/selectable_item_model.dart';
import 'package:deriv_p2p_practice_project/features/selectable_items/presentation/widgets/expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:deriv_p2p_practice_project/features/selectable_items/presentation/widgets/selectable_item_text.dart';
import 'package:flutter/material.dart';

part 'radio_item.dart';

/// A list of radio buttons shown on an expandable bottom-sheet
class RadioListSheet extends StatefulWidget {
  /// Creates a list of radio buttons and show it on an expandable bottom sheet
  ///
  /// When a radio button is selected, the widget calls the [onChanged] callback that
  /// would change `selected` status of that item's [data] and would dismiss the
  /// bottom-sheet.
  ///
  /// The following arguments are required:
  ///
  /// * [data] contains the selectable items details to be displayed vertically
  /// in the expandable bottom-sheet
  /// * [title] to display a header title for the bottom-sheet
  /// * [onChanged] is called when the item is tapped
  const RadioListSheet({
    required this.data,
    required this.onChanged,
    required this.title,
    this.hint,
    this.rightAction,
    this.leftAction,
    this.showBorder = true,
    this.closeAfterChanged = true,
    this.color,
    Key? key,
  }) : super(key: key);

  /// The radio buttons items data contents
  final List<SelectableItemModel> data;

  /// Called when a user selects a radio item.
  ///
  /// Radio item returns the index of the selected item in the list which
  /// can be used to fetch the right [SelectableItemModel] object from the [data]
  /// list
  final ValueChanged<int> onChanged;

  /// The headline of the bottom sheet
  final String title;

  /// A hint that can optionally be shown at the bottom sheet
  final String? hint;

  /// Action placed on right side of the title
  ///
  /// If [hint] has been set, [right Action] won't be accessible anymore.
  final Widget? rightAction;

  /// Action placed on left side of the title
  final Widget? leftAction;

  /// To determine whether a boarder around the radio item should be drawn or
  /// not. The border will have a different color based on [SelectableItemModel.selected]
  /// value.
  ///
  /// This defaults to true
  final bool showBorder;

  /// To determine whether close after [onChanged] callback or not.
  ///
  /// This defaults to true
  final bool closeAfterChanged;

  /// The background color of the selectable item.
  ///
  /// If null, `base07Color` will be set
  final Color? color;

  @override
  _RadioListSheetState createState() => _RadioListSheetState();
}

class _RadioListSheetState extends State<RadioListSheet> {
  // This prevents multiple tapping on items in the list that causes crash the app.
  bool _isSelectedItemChanged = false;

  @override
  Widget build(BuildContext context) => ExpandableBottomSheet(
        hint: widget.hint,
        title: widget.title,
        upperContent: Container(
          margin: const EdgeInsets.all(16),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.data.length,
            semanticChildCount: widget.data.length,
            itemBuilder: (BuildContext context, int index) => _RadioItem<int>(
              title: SelectableItemText(
                value: widget.data[index].title,
                selected: widget.data[index].selected,
              ),
              subtitle: widget.data[index].subtitle != null
                  ? SelectableItemText(
                      value: widget.data[index].subtitle,
                      selected: widget.data[index].selected,
                    )
                  : widget.data[index].subtitle as Widget?,
              value: index,
              groupValue: widget.data[index].selected ? index : -1,
              secondary: widget.data[index].trailing,
              color: widget.color ?? Colors.black45,
              showBorder: widget.showBorder,
              onChanged: (int? index) async =>
                  _isSelectedItemChanged ? null : _onItemSelectedChange(index),
            ),
          ),
        ),
        rightAction: widget.rightAction,
        leftAction: widget.leftAction,
      );

  Future<void> _onItemSelectedChange(int? index) async {
    _isSelectedItemChanged = true;

    _resetSelected(widget.data);
    widget.data[index!].selected = true;

    // Show the change of radio item selection before dismissing the sheet
    setState(() {});

    if (widget.closeAfterChanged) {
      await Future<void>.delayed(
        const Duration(milliseconds: 200),
        () => Navigator.pop(context),
      );
    }

    widget.onChanged(index);
  }

  void _resetSelected(List<SelectableItemModel> data) {
    for (final SelectableItemModel model in data) {
      model
        ..groupValue = -1
        ..selected = false
        ..trailing = const SizedBox.shrink();
    }
  }
}
