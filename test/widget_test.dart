import 'package:flutter_test/flutter_test.dart';

import 'package:visionary/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const OculusApp());

    // Verify that the app starts.
    expect(find.byType(OculusApp), findsOneWidget);
  });
}