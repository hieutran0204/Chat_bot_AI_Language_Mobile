// name: app_responsive.dart
// description: Screen adaptive layout engine and proportional scaling extensions.
//              Detects device type (mobile, tablet, desktop) and scales UI elements.

import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Supported device classifications based on screen width breakpoints.
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// Baseline mobile viewport reference (standard iPhone / Android target).
class ResponsiveConfig {
  static const double baseWidth  = 375.0;
  static const double baseHeight = 812.0;

  // Breakpoints (in logical pixels)
  static const double tabletBreakpoint  = 600.0;
  static const double desktopBreakpoint = 1024.0;

  // Maximum content width constraint on tablets/desktops to prevent stretched layouts
  static const double maxContentWidth = 560.0;
}

/// Core responsive calculations and helpers.
class AppResponsive {
  AppResponsive._();

  /// Classifies device type by screen logical width.
  static DeviceType getDeviceType(double width) {
    if (width >= ResponsiveConfig.desktopBreakpoint) {
      return DeviceType.desktop;
    } else if (width >= ResponsiveConfig.tabletBreakpoint) {
      return DeviceType.tablet;
    }
    return DeviceType.mobile;
  }

  /// Calculates proportional width based on base 375dp canvas.
  /// Clamped between [minFactor] and [maxFactor] to prevent extreme distortions.
  static double scaleWidth(
    BuildContext context,
    double size, {
    double minFactor = 0.85,
    double maxFactor = 1.35,
  }) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final factor = (screenWidth / ResponsiveConfig.baseWidth).clamp(minFactor, maxFactor);
    return size * factor;
  }

  /// Calculates proportional height based on base 812dp canvas.
  static double scaleHeight(
    BuildContext context,
    double size, {
    double minFactor = 0.85,
    double maxFactor = 1.35,
  }) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final factor = (screenHeight / ResponsiveConfig.baseHeight).clamp(minFactor, maxFactor);
    return size * factor;
  }

  /// Calculates scalable font size (sp).
  /// Clamped tightly (0.9 to 1.25) to preserve typography legibility without overflowing.
  static double scaleFont(
    BuildContext context,
    double fontSize, {
    double minScale = 0.9,
    double maxScale = 1.25,
  }) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final textScaler = MediaQuery.textScalerOf(context);
    final widthFactor = (screenWidth / ResponsiveConfig.baseWidth).clamp(minScale, maxScale);
    return textScaler.scale(fontSize * widthFactor);
  }

  /// Calculates scalable corner radius.
  static double scaleRadius(BuildContext context, double radius) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final factor = math.min(screenWidth / ResponsiveConfig.baseWidth, 1.2);
    return radius * factor;
  }
}

// ─────────────────────────────────────────────────────────────
// BuildContext Extensions for seamless access
// ─────────────────────────────────────────────────────────────
extension ResponsiveContextX on BuildContext {
  /// Screen size
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  /// Orientation
  Orientation get orientation => MediaQuery.orientationOf(this);
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;

  /// Device classification
  DeviceType get deviceType => AppResponsive.getDeviceType(screenWidth);
  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Safe area insets
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  double get topPadding => padding.top;
  double get bottomPadding => padding.bottom;

  /// Proportional scaling methods
  double w(double size) => AppResponsive.scaleWidth(this, size);
  double h(double size) => AppResponsive.scaleHeight(this, size);
  double sp(double fontSize) => AppResponsive.scaleFont(this, fontSize);
  double r(double radius) => AppResponsive.scaleRadius(this, radius);

  /// Selects value based on current device type
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    switch (deviceType) {
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.mobile:
        return mobile;
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Responsive Layout Builder Widget
// ─────────────────────────────────────────────────────────────
class ResponsiveLayout extends StatelessWidget {
  final Widget Function(BuildContext context) mobile;
  final Widget Function(BuildContext context)? tablet;
  final Widget Function(BuildContext context)? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final device = context.deviceType;
    if (device == DeviceType.desktop && desktop != null) {
      return desktop!(context);
    }
    if ((device == DeviceType.tablet || device == DeviceType.desktop) && tablet != null) {
      return tablet!(context);
    }
    return mobile(context);
  }
}

// ─────────────────────────────────────────────────────────────
// Responsive Container (Constrains max-width on tablet/desktop)
// ─────────────────────────────────────────────────────────────
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = ResponsiveConfig.maxContentWidth,
    this.alignment = Alignment.center,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}
