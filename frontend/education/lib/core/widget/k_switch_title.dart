import 'package:education/core/widget/k_padding.dart';
import 'package:flutter/material.dart';

class SwitchTitle extends StatelessWidget {
  final String title;
  final bool value;
  final void Function(bool) onChanged;
  TextStyle? textStyle;
  EdgeInsets? padding;
  BoxDecoration? decoration;

  SwitchTitle({
    required this.title,
    required this.value,
    required this.onChanged,
    this.textStyle,
    this.padding,
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        padding: padding ?? KPadding.all_8.copyWith(left: 16, right: 16),
        decoration:
            decoration ??
            BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey, width: 1),
                bottom: BorderSide(color: Colors.grey, width: 1),
              ),
              color: Colors.transparent,
            ),
        child: Row(
          children: [
            Text(
              title,
              style:
                  textStyle ??
                  TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
