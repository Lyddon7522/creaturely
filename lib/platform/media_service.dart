import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as paths;
import 'package:share_plus/share_plus.dart';

export 'package:image_picker/image_picker.dart' show ImageSource;

abstract interface class MediaService {
  Future<File?> pickImage(ImageSource source);
  Future<File?> pickFile(List<String> extensions);
  Future<List<File>> recoverImages();
  void acknowledgeRecoveredImages();
  Future<Directory> temporaryDirectory();
  Future<void> copyText(String text);
  Future<void> share(
    File file, {
    required String mimeType,
    required String title,
    required String subject,
    Rect? origin,
  });
}

class SystemMediaService implements MediaService {
  SystemMediaService({Future<List<File>> Function()? recoverLostImages})
    : _recoverLostImages = recoverLostImages ?? _nativeLostImages;

  final Future<List<File>> Function() _recoverLostImages;
  Future<List<File>>? _recoveredImages;

  @override
  Future<File?> pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source, imageQuality: 90);
    return image == null ? null : File(image.path);
  }

  @override
  Future<File?> pickFile(List<String> extensions) async {
    final file = await FilePicker.pickFile(type: FileType.custom, allowedExtensions: extensions);
    return file?.path == null ? null : File(file!.path!);
  }

  @override
  Future<List<File>> recoverImages() => _recoveredImages ??= _recoverImages();

  Future<List<File>> _recoverImages() async {
    try {
      return List.unmodifiable(await _recoverLostImages());
    } on Object {
      _recoveredImages = null;
      rethrow;
    }
  }

  @override
  void acknowledgeRecoveredImages() {
    _recoveredImages = Future.value(const []);
  }

  static Future<List<File>> _nativeLostImages() async {
    if (!Platform.isAndroid) return const [];
    final result = await ImagePicker().retrieveLostData();
    if (result.exception != null) throw result.exception!;
    return [for (final image in result.files ?? <XFile>[]) File(image.path)];
  }

  @override
  Future<Directory> temporaryDirectory() => paths.getTemporaryDirectory();

  @override
  Future<void> copyText(String text) => Clipboard.setData(ClipboardData(text: text));

  @override
  Future<void> share(
    File file, {
    required String mimeType,
    required String title,
    required String subject,
    Rect? origin,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        sharePositionOrigin: origin,
        title: title,
        subject: subject,
        files: [XFile(file.path, mimeType: mimeType)],
      ),
    );
  }
}
