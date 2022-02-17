import 'package:deriv_p2p_practice_project/enums.dart';

/// This is the controller for Sort option. It has a [onSortSelected] function
/// That is a callback for when an item in the sort will be selected.
class SortController {
  Function(AdvertSortType)? onSortSelected;

  void dispose() {
    onSortSelected = null;
  }
}
