// name: app_spacing.dart
// description: Consistent spacing, padding, radius, and elevation tokens.
//              Follows an 8-point grid system with 4-point micro-spacing.

import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // ── Grid Spacing Values ───────────────────────────────────
  static const double xxs     = 2.0;
  static const double xs      = 4.0;
  static const double sm      = 8.0;
  static const double md      = 12.0;
  static const double lg      = 16.0;
  static const double xl      = 20.0;
  static const double xxl     = 24.0;
  static const double xxxl    = 32.0;
  static const double huge    = 40.0;
  static const double massive = 48.0;

  // ── Border Radius Values ──────────────────────────────────
  static const double radiusXs   = 6.0;
  static const double radiusSm   = 10.0;
  static const double radiusMd   = 14.0;
  static const double radiusLg   = 18.0;
  static const double radiusXl   = 24.0;
  static const double radiusFull = 999.0;

  // ── BorderRadius Objects ──────────────────────────────────
  static const BorderRadius roundedXs   = BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius roundedSm   = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius roundedMd   = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius roundedLg   = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius roundedXl   = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius roundedFull = BorderRadius.all(Radius.circular(radiusFull));

  // ── Icon Sizes ────────────────────────────────────────────
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 40.0;

  // ── Common Edge Insets ────────────────────────────────────
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0);
  static const EdgeInsets cardPadding   = EdgeInsets.all(16.0);
  static const EdgeInsets dialogPadding = EdgeInsets.all(24.0);
  static const EdgeInsets inputPadding  = EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0);
  static const EdgeInsets chipPadding   = EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0);

  // ── Micro Gaps (SizedBox helpers) ─────────────────────────
  static const Widget vGapXxs  = SizedBox(height: xxs);
  static const Widget vGapXs   = SizedBox(height: xs);
  static const Widget vGapSm   = SizedBox(height: sm);
  static const Widget vGapMd   = SizedBox(height: md);
  static const Widget vGapLg   = SizedBox(height: lg);
  static const Widget vGapXl   = SizedBox(height: xl);
  static const Widget vGapXxl  = SizedBox(height: xxl);
  static const Widget vGapXxxl = SizedBox(height: xxxl);
  static const Widget vGapHuge = SizedBox(height: huge);

  static const Widget hGapXxs  = SizedBox(width: xxs);
  static const Widget hGapXs   = SizedBox(width: xs);
  static const Widget hGapSm   = SizedBox(width: sm);
  static const Widget hGapMd   = SizedBox(width: md);
  static const Widget hGapLg   = SizedBox(width: lg);
  static const Widget hGapXl   = SizedBox(width: xl);
  static const Widget hGapXxl  = SizedBox(width: xxl);
  static const Widget hGapXxxl = SizedBox(width: xxxl);
}
