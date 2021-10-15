import 'package:download_progress_with_bloc/feature/store_book/downloadBloc.dart';
import 'package:download_progress_with_bloc/services/encryption_handler.dart';
import 'package:download_progress_with_bloc/feature/fetch_book/fetch_book_bloc.dart';
import 'package:download_progress_with_bloc/feature/fetch_book/fetch_dataprovider.dart';
import 'package:download_progress_with_bloc/feature/fetch_book/fetch_repo.dart';
import 'package:download_progress_with_bloc/feature/store_book/store_book_data_provider.dart';
import 'package:download_progress_with_bloc/feature/store_book/store_book_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home.dart';

void main() {
  StoreBookRepo storeBookRepo = StoreBookRepo(
    storeDataProvider: StoreDataProvider(
      encryptionHandler: EncryptionHandler(),
    ),
  );
  FetchStoredBookFileRepo fetchStoredBookFileRepo = FetchStoredBookFileRepo(
    fetchStoredBookFileDP: FetchStoredBookFileDP(
      encryptionHandler: EncryptionHandler(),
    ),
  );
  runApp(MyApp(
    storeBookRepo: storeBookRepo,
    fetchStoredBookFileRepo: fetchStoredBookFileRepo,
  ));
}

class MyApp extends StatelessWidget {
  final StoreBookRepo storeBookRepo;
  final FetchStoredBookFileRepo fetchStoredBookFileRepo;

  const MyApp(
      {Key? key,
      required this.storeBookRepo,
      required this.fetchStoredBookFileRepo})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DownloadBloc(storeBookRepo: storeBookRepo),
        ),
        BlocProvider(
          create: (context) => FetchBookFileBloc(
              fetchStoredBookFileRepo: fetchStoredBookFileRepo),
        ),
      ],
      child: MaterialApp(
        title: 'Downlaoder',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Homepage(),
      ),
    );
  }
}
