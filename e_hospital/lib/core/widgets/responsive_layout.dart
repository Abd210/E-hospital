import 'package:flutter/material.dart';

/// A utility class to handle responsive layouts
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 650 &&
      MediaQuery.of(context).size.width < 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // If width is more than 1100, we consider it a desktop
    if (size.width >= 1100) {
      return desktop;
    }
    // If width is less than 1100 and more than 650, we consider it a tablet
    else if (size.width >= 650 && tablet != null) {
      return tablet!;
    }
    // Otherwise, we consider it a mobile
    else {
      return mobile;
    }
  }
} 