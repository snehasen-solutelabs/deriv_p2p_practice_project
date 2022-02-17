part of 'radio_list_sheet.dart';

/// Radio item section that starts with a radio icon that changes based on its
/// selection status
class _RadioItem<T> extends StatelessWidget {
  /// Creates a combination of a list tile and a radio button.
  ///
  /// When the radio button is selected, the widget calls the [onChanged] callback.
  /// Widgets that use a radio button will listen for the [onChanged] callback
  /// and rebuild the radio tile with a new [groupValue] to update the visual
  /// appearance of the radio button.
  ///
  /// The following arguments are required:
  ///
  /// * [title] to display useful information for the each radio item
  /// * [value] and [groupValue] together determine whether the radio button is
  ///   selected.
  /// * [onChanged] is called when the user selects this radio button.
  const _RadioItem({
    required this.title,
    required this.groupValue,
    required this.onChanged,
    required this.value,
    this.subtitle,
    this.secondary,
    this.color,
    this.showBorder = true,
    Key? key,
  }) : super(key: key);

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final Widget? subtitle;

  /// A widget to display on the opposite side of the tile from the radio button.
  ///
  /// Typically an [Icon] widget.
  final Widget? secondary;

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for this group of radio buttons.
  ///
  /// This radio button is considered selected if its [value] matches the
  /// [groupValue].
  final T groupValue;

  /// Called when the user selects this radio button.
  ///
  /// The radio button passes [value] as a parameter to this callback. The radio
  /// button does not actually change state until the parent widget rebuilds the
  /// radio tile with the new [groupValue].
  ///
  /// If null, the radio button will be displayed as disabled.
  ///
  /// The provided callback will not be invoked if this radio button is already
  /// selected.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method.
  final ValueChanged<T?> onChanged;

  /// The background color of the radio item.
  ///
  /// If null, `base07Color` will be set
  final Color? color;

  /// To determine whether a boarder around the radio item should be drawn or
  /// not. The border color will change based on the selection status; if
  /// [value] equals [groupValue] the border will take 'brandGreenishColor'
  /// however if [value] does not equal [groupValue], the border color will be
  /// 'base06Color'
  ///
  /// This defaults to true
  final bool showBorder;

  @override
  Widget build(BuildContext context) => Container(
        key: const Key('_RadioItem'),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            8,
          ),
          border: showBorder
              ? Border.all(
                  color: value == groupValue ? Colors.red : Colors.cyan,
                )
              : Border.all(width: 0),
          color: color ?? Colors.black,
        ),
        child: RadioListTile<T>(
          title: title,
          subtitle: subtitle,
          value: value,
          activeColor: Colors.grey,
          groupValue: groupValue,
          onChanged: onChanged,
          secondary: secondary,
        ),
      );
}
