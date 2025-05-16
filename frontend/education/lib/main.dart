import 'package:education/core/router/routes.dart';
import 'package:education/core/router/routes_name.dart';
import 'package:education/core/theme/k_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: KTheme.themeData(),
      onGenerateRoute: onGenerateRoute,
      initialRoute: RoutesName.mainPage,
    );
  }
}
