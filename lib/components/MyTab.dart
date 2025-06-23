import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class MyTab extends StatelessWidget {
  final icon;
  const MyTab({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      // height: 80,
      child: Container(
        // height: 1,
        // padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
        ),
        child: Icon(
          LineIcons.values[icon],
          size: 36,
        ),
      ),
    );
  }
}
