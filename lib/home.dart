import 'dart:typed_data';

import 'package:download_progress_with_bloc/feature/store_book/downloadBloc.dart';
import 'package:download_progress_with_bloc/feature/store_book/download_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'feature/store_book/download_event.dart';
import 'feature/fetch_book/fetch_book_bloc.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BlocListener<FetchBookFileBloc, FetchBookFileState>(
        listener: (context, state) {
          if (state is BookDataFetchedState) {
            Uint8List bookFile = state.bookFile;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Scaffold(
                    body: SfPdfViewer.memory(bookFile),
                  );
                },
              ),
            );
          }
        },
        child: FloatingActionButton(
          onPressed: () {
            BlocProvider.of<FetchBookFileBloc>(context)
                .add(FetchBookFileEvent());
          },
          child: Center(child: Text('Fetch')),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: TextButton(
          onPressed: () {
            BlocProvider.of<DownloadBloc>(context).add(DownloadStarted());
          },
          child: BlocConsumer<FetchBookFileBloc, FetchBookFileState>(
            builder: (context, fetchstate) {
              if (fetchstate is FetchingBookDataFailedState) {
                return Center(
                  child: Text(
                    'unable to fetch data',
                  ),
                );
              }
              return BlocConsumer<DownloadBloc, DownloadState>(
                listener: (downctx, state) {
                  if (state is DownloadCompleted) {
                    print('==============completed biach===================');
                    BlocProvider.of<FetchBookFileBloc>(context)
                        .add(FetchBookFileEvent());
                  }
                },
                builder: (context, state) {
                  if (state is DownloadStarted) {
                    return Center(
                      child: Text('Download started bitches'),
                    );
                  }
                  if (state is DownloadInProgress) {
                    return Center(
                      child: Text(
                        '${((state.progress / state.totalSize) * 100).toStringAsPrecision(4)} % completed',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    );
                  }
                  if (state is DownloadCompleted) {
                    print('download completed');
                    return TextButton(
                        onPressed: () {
                          var fetchBloc =
                              BlocProvider.of<FetchBookFileBloc>(context);
                          fetchBloc.add(FetchBookFileEvent());
                        },
                        child: Text('open file'));
                  }
                  return Center(
                    child: Text('Start Download'),
                  );
                },
              );
            },
            listener: (contex, fetchstate) {
              print('I am listening');
              if (fetchstate is BookDataFetchedState) {
                Uint8List bookFile = fetchstate.bookFile;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Scaffold(
                        body: SfPdfViewer.memory(bookFile),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
