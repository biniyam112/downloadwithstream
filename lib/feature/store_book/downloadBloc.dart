import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:download_progress_with_bloc/feature/store_book/downlaod_file.dart';
import 'package:download_progress_with_bloc/feature/store_book/download_event.dart';
import 'package:download_progress_with_bloc/feature/store_book/download_state.dart';
import 'package:download_progress_with_bloc/services/permission_handler.dart';
import 'package:download_progress_with_bloc/feature/store_book/store_book_repo.dart';
import 'package:http/http.dart' as http;

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  DownloadBloc({required this.storeBookRepo}) : super(DownloadInitial()) {
    on<DownloadStarted>(onStarted);
    on<DownloadProgressed>(onProgressed);
  }
  final StoreBookRepo storeBookRepo;

  @override
  Future<void> close() {
    return super.close();
  }

  Future<void> onStarted(
      DownloadStarted event, Emitter<DownloadState> emit) async {
    print('here bitch');
    try {
      await PermissionHandler.requestStoragePermission();
      streamedResponse = await downloadFile();
      totalSize = streamedResponse!.contentLength ?? 0;
      emit(DownloadInProgress(progress: received, totalSize: totalSize));
      streamedResponse?.stream.listen((value) async {
        received += value.length;
        bytes.addAll(value);
        add(DownloadProgressed(progress: received));
        print('received value is $received');
      }).onDone(
        () async {
          await storeBookRepo.storeEncryptedPdf(
            bytes.toString(),
            bookTitle: 'thisisthefile',
          );
          if (!emit.isDone) emit(DownloadCompleted());
        },
      );
    } catch (e) {
      print('the error is $e');
      emit(DownlaodFailed(errorMessage: '$e'));
    }
  }

  void onProgressed(DownloadProgressed event, Emitter<DownloadState> emit) {
    emit(DownloadInProgress(progress: event.progress, totalSize: totalSize));
  }

  http.StreamedResponse? streamedResponse;
  // StreamController? _controller;
  int received = 0;
  List<int> bytes = [];
  int totalSize = 0;
}
