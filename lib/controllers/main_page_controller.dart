import 'package:get/get.dart';

class MainPageController extends GetxController {
  // .obs membuat variabel ini "reaktif" (observable)
  // UI akan otomatis update jika nilainya berubah
  var selectedIndex = 0.obs;

  // Fungsi untuk mengubah halaman
  void changePage(int index) {
    selectedIndex.value = index;
  }
}