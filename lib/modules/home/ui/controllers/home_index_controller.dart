import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HomeIndex { generate, scan, history }

// Define a provider for the HomeIndexController
final homeIndexProvider = StateNotifierProvider<HomeIndexController, HomeIndex>((
  ref,
) {
  return HomeIndexController();
});

// Controller class to manage the home index state
class HomeIndexController extends StateNotifier<HomeIndex> {
  HomeIndexController() : super(HomeIndex.scan);

  // Method to update the index
  void setIndex(HomeIndex newIndex) {
    state = newIndex;
  }
}
