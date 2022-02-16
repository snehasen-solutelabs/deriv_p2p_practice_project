import 'package:flutter/material.dart';

/// This is a data model for item details that can possibly be used
/// for both selectable and radio types widgets
class SelectableItemModel {
  /// Both [id] and [title] are required and must not be null
  ///
  /// Other arguments are optional and can be ignored
  /// [groupValue] has a default value of -1
  /// [selected] has a default value of false
  SelectableItemModel({
    required this.id,
    required this.title,
    this.value,
    this.subtitle,
    this.leading,
    this.trailing,
    this.groupValue = -1,
    this.selected = false,
    this.error,
  });

  /// The id of the item.
  ///
  /// It must not be null
  int id;

  /// The display title of the item.
  ///
  /// It must not be null
  String title;

  /// An optional value to pass a value of any type.
  final dynamic value;

  /// The subtitle of the item.
  String? subtitle;

  /// The leading widget
  final Widget? leading;

  /// The trailing widget, its value can be modified
  Widget? trailing;

  /// The current selected group value for a [Radio] item, its value can be
  /// modified if needed
  ///
  /// This default to -1
  int groupValue;

  /// Whether an item is selected or not, its value can be modified if needed
  ///
  /// This default to false
  bool selected;

  /// Error value. Null if no errors found.
  bool? error;
}
