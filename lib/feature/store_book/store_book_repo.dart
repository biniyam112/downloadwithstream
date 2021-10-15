import 'package:download_progress_with_bloc/feature/store_book/store_book_data_provider.dart';

class StoreBookRepo {
  final StoreDataProvider storeDataProvider;

  StoreBookRepo({required this.storeDataProvider});

  Future<void> storeEncryptedPdf(String pdfByteFile,
      {required String bookTitle}) async {
    return await storeDataProvider.storeEncryptedPdf(
      pdfByteFile,
      bookTitle: bookTitle,
    );
  }
}
