import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:download_progress_with_bloc/feature/store_book/downlaod_file.dart';
import 'package:download_progress_with_bloc/feature/store_book/download_event.dart';
import 'package:download_progress_with_bloc/feature/store_book/download_state.dart';
import 'package:download_progress_with_bloc/services/permission_handler.dart';
import 'package:download_progress_with_bloc/feature/store_book/store_book_repo.dart';
import 'package:http/http.dart' as http;

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  DownloadBloc({required this.storeBookRepo}) : super(DownloadInitial());

  http.StreamedResponse? response;
  // StreamController? _controller;
  int received = 0;
  List<int> bytes = [];
  int totalSize = 0;
  final StoreBookRepo storeBookRepo;

  // ignore: unused_element
  @override
  Stream<DownloadState> mapEventToState(DownloadEvent event) async* {
    yield DownloadInProgress(progress: received, totalSize: totalSize);
    try {
      await PermissionHandler.requestStoragePermission();
      response = await downloadFile();
      totalSize = response!.contentLength ?? 0;
      yield DownloadInProgress(progress: received, totalSize: totalSize);
      response?.stream.asBroadcastStream().listen((value) async {
        received += value.length;
        bytes.addAll(value);
        add(DownloadProgressed(progress: received));
        print('received value is $received');
      }).onDone(
        () async* {
          await storeBookRepo.storeEncryptedPdf(
            bytes.toString(),
            bookTitle: 'thisisthefile',
          );
          yield DownloadCompleted();
        },
      );
    } catch (e) {
      print('the error is $e');
      yield DownlaodFailed(errorMessage: '$e');
    }
  }
}
