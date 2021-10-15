import 'package:equatable/equatable.dart';

class DownloadEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DownloadStarted extends DownloadEvent {}

class DownloadProgressed extends DownloadEvent {
  final int progress;

  DownloadProgressed({required this.progress});
}
