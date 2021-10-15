import 'dart:io';

import '../../services/encryption_handler.dart';

class FetchStoredBookFileDP {
  final EncryptionHandler encryptionHandler;

  FetchStoredBookFileDP({required this.encryptionHandler});

  Future<String> decryptStoredPdf(String filePath) async {
    encryptionHandler.encryptionKeyString = 'theencryptionkey';
    final file = File(filePath);
    final byteFile = await file.readAsString();
    return encryptionHandler.decryptData(byteFile);
  }
}
