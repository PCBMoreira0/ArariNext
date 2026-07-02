import 'dart:io';

import 'package:arari_next/data/services/file/file_storage_service.dart';
import 'package:path_provider/path_provider.dart';

class LocalFileStorageService implements FileStorageService {
  Future<File> _getFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  @override
  Future<String?> read(String fileName) async {
    final file = await _getFile(fileName);

    if (!await file.exists()) {
      return null;
    }

    return await file.readAsString();
  }

  @override
  Future<void> write(String fileName, String content) async {
    final file = await _getFile(fileName);

    await file.parent.create(recursive: true);

    await file.writeAsString(content, flush: true);
  }

  @override
  Future<bool> exists(String fileName) async {
    final file = await _getFile(fileName);
    return file.exists();
  }

  @override
  Future<void> delete(String fileName) async {
    final file = await _getFile(fileName);

    if (await file.exists()) {
      await file.delete();
    }
  }
}
