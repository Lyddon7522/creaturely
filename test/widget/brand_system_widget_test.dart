import 'package:creaturely/ui/core/brand.dart';
import 'package:creaturely/ui/core/theme.dart';
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
}

String _assetName(WidgetTester tester) {
  final image = tester.widget<Image>(find.byType(Image));
  return (image.image as AssetImage).assetName;
}
