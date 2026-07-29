import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

abstract interface class DocumentSaveService {
  Future<String?> save({
    required String fileName,
    required String dialogTitle,
    required Uint8List bytes,
    required List<String> allowedExtensions,
  });
}

class SystemDocumentSaveService implements DocumentSaveService {
  const SystemDocumentSaveService();

  @override
  Future<String?> save({
    required String fileName,
    required String dialogTitle,
    required Uint8List bytes,
    required List<String> allowedExtensions,
  }) => FilePicker.platform.saveFile(
    dialogTitle: dialogTitle,
    fileName: fileName,
    type: FileType.custom,
    allowedExtensions: allowedExtensions,
    bytes: bytes,
  );
}
