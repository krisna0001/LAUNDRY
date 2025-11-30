import 'package:laundry3b1titik0/models/order_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  // ==================== ORDERS ====================
  Future<void> addOrder(Order order) async {
    try {
      await _supabase.from('orders').insert(order.toMap());
    } catch (e) {
      throw Exception('Gagal menambah order: $e');
    }
  }

  Future<List<Order>> getOrders() async {
    try {
      final response = await _supabase
          .from('orders')
          .select()
          .order('order_date', ascending: false);
      return (response as List)
          .map((item) => Order.fromMap(item, item['id'].toString()))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil orders: $e');
    }
  }

  Future<List<Order>> getOrdersByStatus(String status) async {
    try {
      final response = await _supabase
          .from('orders')
          .select()
          .eq('status', status)
          .order('order_date', ascending: false);
      return (response as List)
          .map((item) => Order.fromMap(item, item['id'].toString()))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil orders: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _supabase
          .from('orders')
          .update({'status': status}).eq('id', orderId);
    } catch (e) {
      throw Exception('Gagal update status: $e');
    }
  }

  Future<void> updateOrder(
    String orderId,
    String customerName,
    String serviceType,
    double totalCost,
  ) async {
    try {
      await _supabase.from('orders').update({
        'customer_name': customerName,
        'service_type': serviceType,
        'total_cost': totalCost,
      }).eq('id', orderId);
    } catch (e) {
      throw Exception('Gagal update order: $e');
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _supabase.from('orders').delete().eq('id', orderId);
    } catch (e) {
      throw Exception('Gagal hapus order: $e');
    }
  }

  // ==================== OUTLETS ====================
  Future<void> addOutlet(Map<String, dynamic> outlet) async {
    try {
      await _supabase.from('outlets').insert(outlet);
    } catch (e) {
      throw Exception('Gagal menambah outlet: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getOutlets() async {
    try {
      return await _supabase.from('outlets').select();
    } catch (e) {
      throw Exception('Gagal mengambil outlets: $e');
    }
  }

  // ==================== CUSTOMERS ====================
  Future<void> addCustomer(Map<String, dynamic> customer) async {
    try {
      await _supabase.from('customers').insert(customer);
    } catch (e) {
      throw Exception('Gagal menambah customer: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getCustomers() async {
    try {
      return await _supabase.from('customers').select();
    } catch (e) {
      throw Exception('Gagal mengambil customers: $e');
    }
  }

  // ==================== PRICING ====================
  Future<void> addPricing(Map<String, dynamic> pricing) async {
    try {
      await _supabase.from('pricing').insert(pricing);
    } catch (e) {
      throw Exception('Gagal menetapkan harga: $e');
    }
  }

  /// Upload gambar layanan ke Supabase Storage menggunakan uploadBinary
  Future<String?> uploadServiceImage(File imageFile) async {
    try {
      // Buat nama file unik berdasarkan timestamp
      final fileName =
          'service_${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';

      print('📤 Starting binary upload: $fileName');
      print('📁 Bucket: gambar_layanan');
      print('📏 File size: ${imageFile.lengthSync()} bytes');

      // Baca file sebagai bytes (PERBAIKAN: hindari akses langsung ke path)
      final bytes = await imageFile.readAsBytes();
      print('✓ File read as binary: ${bytes.length} bytes');

      // Upload menggunakan uploadBinary dengan FileOptions
      final response =
          await _supabase.storage.from('gambar_layanan').uploadBinary(
                fileName,
                bytes,
                fileOptions: const FileOptions(
                  upsert: true,
                  contentType: 'image/jpeg',
                ),
              );

      print('✓ Binary upload response: $response');

      // Dapatkan URL publik file
      final publicUrl =
          _supabase.storage.from('gambar_layanan').getPublicUrl(fileName);

      print('✓ Image uploaded successfully: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('❌ Error uploading image: $e');
      print('📍 Error type: ${e.runtimeType}');
      print('📍 Error details: ${e.toString()}');
      print('📍 Stack trace: ${StackTrace.current}');
      return null;
    }
  }

  /// Set pricing dengan support image URL
  Future<bool> setPricing(
    String serviceName,
    double price, {
    String? imageUrl,
  }) async {
    try {
      final data = {
        'service_name': serviceName,
        'price': price,
        'image_url': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('pricing').insert(data);

      print('✓ Pricing added successfully');
      return true;
    } catch (e) {
      print('❌ Error setting pricing: $e');
      return false;
    }
  }

  /// Get pricing dengan gambar
  Future<List<Map<String, dynamic>>> getPricing() async {
    try {
      print('📥 Fetching pricing data from Supabase...');

      final response = await _supabase
          .from('pricing')
          .select()
          .order('created_at', ascending: false);

      print('✓ Fetched ${response.length} pricing items');

      // Debug: print semua items
      for (var item in response) {
        print(
            '  - ${item['service_name']}: Rp ${item['price']} (Image: ${item['image_url'] != null ? '✓' : '✗'})');
      }

      return List<Map<String, dynamic>>.from(response ?? []);
    } catch (e) {
      print('❌ Error fetching pricing: $e');
      print('📍 Error details: ${e.toString()}');
      return [];
    }
  }

  // ==================== PROMOS ====================
  Future<void> addPromo(Map<String, dynamic> promo) async {
    try {
      await _supabase.from('promos').insert(promo);
    } catch (e) {
      throw Exception('Gagal menambah promo: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPromos() async {
    try {
      return await _supabase.from('promos').select();
    } catch (e) {
      throw Exception('Gagal mengambil promos: $e');
    }
  }
}
