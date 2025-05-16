import 'package:finance/core/widget/k_app_bar.dart';
import 'package:finance/core/widget/k_padding.dart';
import 'package:finance/core/widget/k_page.dart';
import 'package:finance/core/widget/k_switch_title.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return KPage(
      child: Scaffold(
        appBar: KAppBar(title: Text('Settings')),
        body: Padding(
          padding: KPadding.defaultPagePadding,
          child: SwitchTitle(
            title: "Dark Mode",
            value: true,
            onChanged: (value) {
              // Handle the switch value change
              print("Dark Mode: $value");
            },
          ),
        ),
      ),
    );
  }
}
