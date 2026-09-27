// name: responsive_test.dart
// description: Unit and widget tests for AppResponsive, AppTypography, and AppColors.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_ai_mobile/core/theme/theme.dart';

void main() {
  group('AppResponsive Device Detection', () {
    test('identifies mobile width (< 600)', () {
      expect(AppResponsive.getDeviceType(375), equals(DeviceType.mobile));
      expect(AppResponsive.getDeviceType(599), equals(DeviceType.mobile));
    });

    test('identifies tablet width (600 - 1023)', () {
      expect(AppResponsive.getDeviceType(600), equals(DeviceType.tablet));
      expect(AppResponsive.getDeviceType(800), equals(DeviceType.tablet));
      expect(AppResponsive.getDeviceType(1023), equals(DeviceType.tablet));
    });

    test('identifies desktop width (>= 1024)', () {
      expect(AppResponsive.getDeviceType(1024), equals(DeviceType.desktop));
      expect(AppResponsive.getDeviceType(1920), equals(DeviceType.desktop));
    });
  });

  group('AppResponsive BuildContext Extensions', () {
    testWidgets('provides correct responsive values and scaling', (tester) async {
      tester.view.physicalSize = const Size(375 * 2, 812 * 2);
      tester.view.devicePixelRatio = 2.0;

      late DeviceType detectedDevice;
      late bool isMobileDetected;
      late double scaledWidth;
      late double scaledFont;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              detectedDevice = context.deviceType;
              isMobileDetected = context.isMobile;
              scaledWidth = context.w(100);
              scaledFont = context.sp(16);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(detectedDevice, equals(DeviceType.mobile));
      expect(isMobileDetected, isTrue);
      expect(scaledWidth, closeTo(100.0, 1.0));
      expect(scaledFont, closeTo(16.0, 1.0));

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    });

    testWidgets('ResponsiveContainer constrains maxWidth on large screens', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveContainer(
              maxWidth: 400,
              child: SizedBox(key: Key('child_box'), width: double.infinity, height: 100),
            ),
          ),
        ),
      );

      final boxFinder = find.byKey(const Key('child_box'));
      final size = tester.getSize(boxFinder);
      expect(size.width, equals(400.0));

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    });
  });

  group('AppTypography & AppColors', () {
    test('AppColors tokens are valid', () {
      expect(AppColors.primary, isNotNull);
      expect(AppColors.bgDark, isNotNull);
      expect(AppColors.textPrimary, isNotNull);
      expect(AppColors.success, isNotNull);
    });

    test('AppTypography provides text theme and font family', () {
      expect(AppTypography.fontFamily, equals('Inter'));
      expect(AppTypography.textTheme.displayLarge, isNotNull);
      expect(AppTypography.textTheme.bodyMedium, isNotNull);
    });
  });
}
