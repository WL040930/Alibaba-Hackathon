import 'package:flutter/material.dart';

class KPage extends StatelessWidget {
  final Widget child;
  const KPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeData.light().scaffoldBackgroundColor,
      child: child,
    );
  }
}
