import 'package:Finance/modules/common/main_page/main_page.dart';
import 'package:Finance/core/router/routes_name.dart';
import 'package:flutter/material.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RoutesName.mainPage:
      return MaterialPageRoute(builder: (context) => const MainPage());
  }
}
