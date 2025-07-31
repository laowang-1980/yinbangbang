// This is a basic example of a Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic widget test', (WidgetTester tester) async {
    // Build a simple widget and verify it works
    await tester.pumpWidget(
      const CupertinoApp(
        home: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('Test'),
          ),
          child: Center(
            child: Text('Hello World'),
          ),
        ),
      ),
    );

    // Verify that our test widget loads
    expect(find.text('Hello World'), findsOneWidget);
    expect(find.text('Test'), findsOneWidget);
  });
}
