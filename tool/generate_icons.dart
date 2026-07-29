import 'dart:io';

import 'package:image/image.dart' as image;

void main() {
  final masterFile = File('assets/brand/exports/creaturely-app-icon-1024.png');
  if (!masterFile.existsSync()) {
    throw StateError('Missing approved Creaturely app-icon master: ${masterFile.path}');
  }
  final master = image.decodePng(masterFile.readAsBytesSync());
  if (master == null || master.width != 1024 || master.height != 1024) {
    throw StateError('Creaturely app-icon master must be a valid 1024 × 1024 PNG.');
  }

  final ios = <String, int>{
    'Icon-App-20x20@1x.png': 20,
    'Icon-App-20x20@2x.png': 40,
    'Icon-App-20x20@3x.png': 60,
    'Icon-App-29x29@1x.png': 29,
    'Icon-App-29x29@2x.png': 58,
    'Icon-App-29x29@3x.png': 87,
    'Icon-App-40x40@1x.png': 40,
    'Icon-App-40x40@2x.png': 80,
    'Icon-App-40x40@3x.png': 120,
    'Icon-App-60x60@2x.png': 120,
    'Icon-App-60x60@3x.png': 180,
    'Icon-App-76x76@1x.png': 76,
    'Icon-App-76x76@2x.png': 152,
    'Icon-App-83.5x83.5@2x.png': 167,
    'Icon-App-1024x1024@1x.png': 1024,
  };
  final iosRoot = Directory('ios/Runner/Assets.xcassets/AppIcon.appiconset');
  for (final entry in ios.entries) {
    _writePng(File('${iosRoot.path}/${entry.key}'), master, entry.value);
  }

  final android = <String, int>{
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
  };
  for (final entry in android.entries) {
    _writePng(File('android/app/src/main/res/${entry.key}/ic_launcher.png'), master, entry.value);
  }
}

void _writePng(File file, image.Image source, int size) {
  final output = size == source.width
      ? source
      : image.copyResize(
          source,
          width: size,
          height: size,
          interpolation: image.Interpolation.cubic,
        );
  file.writeAsBytesSync(image.encodePng(output, level: 9), flush: true);
}
