import 'package:easyattend/modules/generate/data/models/lecture.dart';
import 'package:easyattend/modules/history/data/firebase/history_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/// Provider for lectures created by the current user
final createdHistoryProvider = StreamProvider.autoDispose<List<Lecture>>((ref) {
  final historyService = ref.read(historyServiceProvider);
  return historyService.getCreatedLectures();
});

/// Provider for lectures scanned/attended by the current user
final scannedHistoryProvider = StreamProvider.autoDispose<List<Lecture>>((ref) {
  final historyService = ref.read(historyServiceProvider);
  return historyService.getAttendedLectures();
});