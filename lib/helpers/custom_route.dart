// Example: flutter_shop
//          src/mobile/flutter/learning/udemy/flutter-dart-complete-guide/flutter_shop

// How to use it in the main file:
//  MaterialApp(
//           title: 'MyShop',
//           theme: ThemeData(
//             pageTransitionsTheme: PageTransitionsTheme(builders: {
//               TargetPlatform.android: CustomPageTransitionBuilder(),
//               TargetPlatform.iOS: CustomPageTransitionBuilder(),
//             }),

import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (route.settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
