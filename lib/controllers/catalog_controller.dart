import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:laundry3b1titik0/catalog_screen.dart';

class CatalogController extends GetxController {
  final isLoading = true.obs;
  final services = <LaundryService>[].obs;

  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      isLoading.value = true;

      final response = await _supabase
          .from('laundry_services')
          .select()
          .order('id', ascending: true);

      if (response.isNotEmpty) {
        final List<LaundryService> loadedServices = (response as List)
            .map((service) => LaundryService.fromJson(service))
            .toList();

        services.assignAll(loadedServices);
        print('Sukses memuat ${loadedServices.length} layanan dari Supabase');
      } else {
        print('Tidak ada layanan ditemukan di Supabase');
      }
    } catch (e) {
      print('Error memuat layanan: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Gagal memuat layanan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void refreshServices() {
    fetchServices();
  }
}
