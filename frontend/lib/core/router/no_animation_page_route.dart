import 'package:flutter/material.dart';

/// A page route that doesn't have any transition animation
class NoAnimationPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  NoAnimationPageRoute({required this.builder, RouteSettings? settings})
    : super(settings: settings, fullscreenDialog: false);

  @override
  bool get opaque => true;

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration.zero;

  @override
  Duration get reverseTransitionDuration => Duration.zero;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

/// Extension method for Navigator to provide no-animation navigation
extension NoAnimationNavigatorExt on NavigatorState {
  /// Push a route with no animation
  Future<T?> pushNoAnimation<T extends Object?>(Widget page) {
    return push<T>(NoAnimationPageRoute<T>(builder: (_) => page));
  }

  /// Pop with no animation
  void popNoAnimation<T extends Object?>([T? result]) {
    pop<T>(result);
  }
}
