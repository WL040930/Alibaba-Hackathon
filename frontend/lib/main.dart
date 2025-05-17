import 'package:finance/core/router/routes.dart';
import 'package:finance/core/router/routes_name.dart';
import 'package:finance/core/theme/k_theme.dart';
import 'package:finance/modules/common/main_page/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MainViewModel>(
          create: (_) => MainViewModel()..init(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: KTheme.themeData(),
        onGenerateRoute: onGenerateRoute,
        initialRoute: RoutesName.mainPage,
      ),
    );
  }
}
