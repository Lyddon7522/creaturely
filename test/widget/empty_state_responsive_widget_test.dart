import 'package:creaturely/ui/core/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('empty state remains scrollable in a short landscape viewport', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 72,
            child: EmptyState(
              icon: Icons.event_available_outlined,
              title: 'Nothing scheduled today',
              body: 'Add a reminder to begin.',
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.text('Nothing scheduled today'), findsOneWidget);
  });

  testWidgets('empty state still shrink-wraps inside a parent scroll view', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: EmptyState(
              icon: Icons.pets_outlined,
              title: 'No animals',
              body: 'Add an animal to begin.',
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('No animals'), findsOneWidget);
  });
}
