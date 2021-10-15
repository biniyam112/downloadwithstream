import 'package:download_progress_with_bloc/feature/fetch_book/fetch_dataprovider.dart';

class FetchStoredBookFileRepo {
  final FetchStoredBookFileDP fetchStoredBookFileDP;

  FetchStoredBookFileRepo({required this.fetchStoredBookFileDP});

  Future<String> decryptStoredPdf(String filePath) async {
    return await fetchStoredBookFileDP.decryptStoredPdf(filePath);
  }
}
