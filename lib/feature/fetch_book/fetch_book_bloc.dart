import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:download_progress_with_bloc/feature/fetch_book/fetch_repo.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FetchBookFileBloc extends Bloc<FetchBookFileEvent, FetchBookFileState> {
  FetchBookFileBloc({required this.fetchStoredBookFileRepo})
      : super(BookDataFetchingState());
  final FetchStoredBookFileRepo fetchStoredBookFileRepo;

  @override
  Stream<FetchBookFileState> mapEventToState(FetchBookFileEvent event) async* {
    yield BookDataFetchingState();
    try {
      var path = join((await getApplicationDocumentsDirectory()).path, 'books',
          'thisisthefile.pdf');
      final bookFile = await fetchStoredBookFileRepo.decryptStoredPdf(path);
      var newBookFile = Uint8List.fromList(bookFile.codeUnits);
      yield BookDataFetchedState(bookFile: newBookFile);
    } catch (e) {
      yield FetchingBookDataFailedState(errorMessage: e.toString());
    }
  }
}

class FetchBookFileState {}

class BookDataFetchingState extends FetchBookFileState {}

class BookDataFetchedState extends FetchBookFileState {
  late Uint8List bookFile;

  BookDataFetchedState({required this.bookFile});
}

class FetchingBookDataFailedState extends FetchBookFileState {
  final String errorMessage;

  FetchingBookDataFailedState({required this.errorMessage});
}

class FetchDownBooksEvent {}

class FetchBookFileEvent {
  FetchBookFileEvent();
}
