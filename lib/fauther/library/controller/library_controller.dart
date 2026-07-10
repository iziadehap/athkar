import 'package:get/get.dart';

class LibraryController extends GetxController {
  final selectedCategory = 'Daily'.obs;
  final searchQuery = ''.obs;

  static const categories = ['Daily', 'Morning', 'Evening', 'Travel'];

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }
}
