import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

class UserService {
  final _supabase = Supabase.instance.client;

  String? get currentUserId => _supabase.auth.currentUser?.id;

  Future<void> signInAnonymously() async {
    if (_supabase.auth.currentUser == null) {
      await _supabase.auth.signInAnonymously();
    }
  }

  Future<List<ServicePrice>> getServices() async {
    try {
      final response = await _supabase
          .from('pricing')
          .select()
          .order('name', ascending: true);

      return (response as List).map((e) => ServicePrice.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> createOrder(Order order) async {
    if (currentUserId == null) await signInAnonymously();

    try {
      final data = order.toMap();
      data['user_id'] = currentUserId;

      await _supabase.from('orders').insert(data);
    } catch (e) {
      throw Exception('Gagal membuat pesanan: $e');
    }
  }

  Stream<List<Order>> getMyOrdersStream() {
    if (currentUserId == null) return Stream.value([]);

    return _supabase
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('user_id', currentUserId!)
        .order('order_date', ascending: false)
        .map((data) => data.map((e) => Order.fromMap(e)).toList());
  }
}
