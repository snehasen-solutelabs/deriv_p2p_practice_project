import 'package:flutter/material.dart';

/// A title style for text widgets shown in a bottom-sheet with a selectable
/// items list.
class SelectableItemText extends StatelessWidget {
  /// Sets a style of the Text widget for a given [value] value based on whether
  /// it is [selected] or not.
  ///
  /// [value] argument is required
  const SelectableItemText({
    required this.value,
    this.selected = false,
    Key? key,
  }) : super(key: key);

  /// The text value to be passed to a Text widget and to be given a style
  final String? value;

  /// To determine if the item is in selected and in active state or not.
  ///
  /// This defaults to false.
  final bool selected;

  @override
  Widget build(BuildContext context) => value != null
      ? Text(
          value!,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey,
          ),
        )
      : const SizedBox.shrink();
}
