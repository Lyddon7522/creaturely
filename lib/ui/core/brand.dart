import 'package:flutter/material.dart';

abstract final class CreaturelyBrandAssets {
  static const String horizontalPrimary =
      'assets/brand/exports/creaturely-logo-horizontal-primary@2x.png';
  static const String horizontalReversed =
      'assets/brand/exports/creaturely-logo-horizontal-reversed@2x.png';
  static const String primaryMark = 'assets/brand/exports/creaturely-mark-primary-512.png';
}

class CreaturelyLogo extends StatelessWidget {
  const CreaturelyLogo({this.width = 208, this.header = false, super.key});

  final double width;
  final bool header;

  @override
  Widget build(BuildContext context) {
    final asset = Theme.of(context).brightness == Brightness.dark
        ? CreaturelyBrandAssets.horizontalReversed
        : CreaturelyBrandAssets.horizontalPrimary;
    return Semantics(
      image: true,
      header: header,
      label: 'Creaturely. Know their normal.',
      child: ExcludeSemantics(
        child: Image.asset(
          asset,
          width: width,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

class CreaturelyMark extends StatelessWidget {
  const CreaturelyMark({this.size = 48, this.semanticLabel = 'Creaturely', super.key});

  final double size;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      image: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: dark ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(size * 0.24),
          ),
          child: Padding(
            padding: EdgeInsets.all(dark ? size * 0.08 : 0),
            child: Image.asset(
              CreaturelyBrandAssets.primaryMark,
              width: size,
              height: size,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      ),
    );
  }
}
