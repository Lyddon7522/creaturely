import 'package:creaturely/ui/core/brand.dart';
import 'package:creaturely/ui/core/theme.dart';
import 'package:creaturely/ui/core/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('light and dark themes expose the approved Creaturely tokens', () {
    final light = CreaturelyTheme.light.colorScheme;
    expect(light.primary, CreaturelyColors.vitalTeal);
    expect(light.secondary, CreaturelyColors.heartCoral);
    expect(light.surface, CreaturelyColors.cloudCanvas);
    expect(light.onSurface, CreaturelyColors.softInk);
    expect(light.outlineVariant, CreaturelyColors.mistBorder);

    final dark = CreaturelyTheme.dark.colorScheme;
    expect(dark.primary, CreaturelyColors.freshMint);
    expect(dark.onPrimary, CreaturelyColors.darkOnPrimary);
    expect(dark.surface, CreaturelyColors.darkBackground);
    expect(dark.onSurface, CreaturelyColors.darkText);
    expect(dark.outline, CreaturelyColors.darkBorder);
  });

  test('component themes use the Creaturely shape and tactile surface hierarchy', () {
    for (final theme in <ThemeData>[CreaturelyTheme.light, CreaturelyTheme.dark]) {
      expect(theme.appBarTheme.backgroundColor, Colors.transparent);
      expect(theme.appBarTheme.toolbarHeight, isNull);
      expect(theme.cardTheme.elevation, 1);
      expect(theme.cardTheme.surfaceTintColor, Colors.transparent);
      expect(theme.navigationBarTheme.indicatorShape, isA<RoundedRectangleBorder>());
      expect(theme.bottomSheetTheme.shape, isA<RoundedRectangleBorder>());
      expect(theme.floatingActionButtonTheme.shape, isA<RoundedRectangleBorder>());
    }
    expect(CreaturelyRadii.small, 8);
    expect(CreaturelyRadii.standard, 14);
    expect(CreaturelyRadii.feature, 24);
  });

  testWidgets('logo chooses the approved light and dark assets with one semantic label', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        theme: CreaturelyTheme.light,
        home: const Scaffold(body: CreaturelyLogo()),
      ),
    );
    expect(_assetName(tester), CreaturelyBrandAssets.horizontalPrimary);
    expect(find.bySemanticsLabel('Creaturely. Know their normal.'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        darkTheme: CreaturelyTheme.dark,
        themeMode: ThemeMode.dark,
        home: const Scaffold(body: CreaturelyLogo()),
      ),
    );
    await tester.pumpAndSettle();
    expect(_assetName(tester), CreaturelyBrandAssets.horizontalReversed);
    expect(find.bySemanticsLabel('Creaturely. Know their normal.'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('quick actions keep semantics and disable press motion when requested', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: CreaturelyTheme.light,
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: QuickActionRail(
              actions: [
                QuickActionItem(
                  key: const ValueKey<String>('test_quick_action'),
                  icon: Icons.air_rounded,
                  label: 'Count breaths',
                  semanticLabel: 'Count breaths, Moss',
                  tone: QuickActionTone.primary,
                  onTap: () => tapped = true,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Count breaths, Moss'), findsOneWidget);
    expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).duration, Duration.zero);
    await tester.tap(find.byKey(const ValueKey<String>('test_quick_action')));
    expect(tapped, isTrue);
  });
}

String _assetName(WidgetTester tester) {
  final image = tester.widget<Image>(find.byType(Image));
  return (image.image as AssetImage).assetName;
}
