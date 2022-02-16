import 'package:flutter/material.dart';

class DefaultTabBar extends StatefulWidget {
  final GlobalKey? tabBarKey;
  final int length;
  final List<Widget> tabs;
  final Function onTap;
  final Color? color;

  DefaultTabBar({
    required this.length,
    required this.tabs,
    required this.onTap,
    this.tabBarKey,
    this.color,
  });

  @override
  _DefaultTabBarState createState() => _DefaultTabBarState();
}

class _DefaultTabBarState extends State<DefaultTabBar>
    with SingleTickerProviderStateMixin {
  int? _oldValue;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: widget.length);
  }

  @override
  Widget build(BuildContext context) => Material(
        color: widget.color ?? Colors.blue,
        child: InkWell(
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              DefaultTabController(
                length: widget.length,
                child: SizedBox(
                  height: 48,
                  child: TabBar(
                    key: widget.tabBarKey,
                    tabs: widget.tabs,
                    controller: _tabController,
                    onTap: _onTap,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  void _onTap(int value) {
    if (_shouldSwitch(value)) {
      _oldValue = value;
      _tabController!.animateTo(value);
      widget.onTap(value);
    }
  }

  bool _shouldSwitch(int value) =>
      (_oldValue != null && _oldValue != value) ||
      (_oldValue == null && value != 0);

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
