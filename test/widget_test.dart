import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skipper/main.dart';

void main() {
  testWidgets('Skipper app builds', (WidgetTester tester) async {
    await tester.pumpWidget(const SkipperApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
