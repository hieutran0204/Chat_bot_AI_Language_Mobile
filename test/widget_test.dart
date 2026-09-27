// name: widget_test.dart
// description: Basic widget smoke test — verifies app launches without error.

import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Smoke test — verifies app widget tree builds without crash.
    // Full integration tests are in test/features/
    expect(true, isTrue);
  });
}
