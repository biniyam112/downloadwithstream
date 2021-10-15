import 'dart:io';

import 'package:download_progress_with_bloc/services/encryption_handler.dart';
import 'package:download_progress_with_bloc/services/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class StoreDataProvider {
  final EncryptionHandler encryptionHandler;

  StoreDataProvider({required this.encryptionHandler});

  Future<void> storeEncryptedPdf(String pdfByteFile,
      {required String bookTitle}) async {
    encryptionHandler.encryptionKeyString = 'theencryptionkey';
    await PermissionHandler.requestStoragePermission();
    try {
      var directory = await getApplicationDocumentsDirectory();
      var bookDirectory = await Directory(path.join(
        '${directory.path}',
        'books',
      )).create(recursive: true);
      final filePath = path.join(bookDirectory.path, '$bookTitle.pdf');
      final file = File(filePath);
      var encryptedData = encryptionHandler.encryptData(pdfByteFile);
      await file.writeAsString(encryptedData);
    } catch (e) {
      throw Exception('File encryption failed');
    }
  }
}
