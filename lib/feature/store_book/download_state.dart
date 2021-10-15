import 'package:equatable/equatable.dart';

class DownloadState extends Equatable {
  DownloadState({required this.progress});

  @override
  List<Object?> get props => [progress];
  final int progress;
}

class DownloadInitial extends DownloadState {
  DownloadInitial() : super(progress: 0);
}

class DownloadInProgress extends DownloadState {
  DownloadInProgress({required this.progress, required this.totalSize})
      : super(progress: progress);
  final int progress, totalSize;
}

class DownloadCompleted extends DownloadState {
  DownloadCompleted() : super(progress: 100);
}

class DownlaodFailed extends DownloadState {
  DownlaodFailed({required this.errorMessage}) : super(progress: 0);
  final String errorMessage;
}
