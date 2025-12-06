import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class ApiService {
  static const String projectId = "tmmtveovwsjbkkdqrmgi";
  static const String publicAnonKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRtbXR2ZW92d3NqYmtrZHFybWdpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM1NTEzMzgsImV4cCI6MjA3OTEyNzMzOH0.8difgTjL3-e_rEEwHTLMXvhrqK-TZBANHEoASAcfEg0";
  static const String baseUrl =
      "https://$projectId.supabase.co/functions/v1/make-server-6ca29526";

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $publicAnonKey',
  };

  static Future<String> getCustomerId() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('laundry3b_id_pelanggan');
    if (id == null) {
      id =
          'pelanggan_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
      await prefs.setString('laundry3b_id_pelanggan', id);
    }
    return id;
  }

  static Future<List<Layanan>> getLayanan() async {
    final response = await http.get(
      Uri.parse('$baseUrl/layanan'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List).map((e) => Layanan.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat layanan');
  }

  static Future<List<Pesanan>> getPesananAktif() async {
    final id = await getCustomerId();
    final response = await http.get(
      Uri.parse('$baseUrl/pesanan/$id/aktif'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List).map((e) => Pesanan.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat pesanan aktif');
  }

  static Future<List<Pesanan>> getRiwayatPesanan() async {
    final id = await getCustomerId();
    final response = await http.get(
      Uri.parse('$baseUrl/pesanan/$id/riwayat'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List).map((e) => Pesanan.fromJson(e)).toList();
    }
    throw Exception('Gagal memuat riwayat');
  }

  static Future<bool> buatPesanan(Map<String, dynamic> data) async {
    final id = await getCustomerId();
    final response = await http.post(
      Uri.parse('$baseUrl/pesanan/$id'),
      headers: headers,
      body: json.encode(data),
    );
    return response.statusCode == 200;
  }

  static Future<ProfilPelanggan> getProfil() async {
    final id = await getCustomerId();
    final response = await http.get(
      Uri.parse('$baseUrl/profil/$id'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ProfilPelanggan.fromJson(data['data']);
    }
    throw Exception('Gagal memuat profil');
  }

  static Future<bool> updateProfil(Map<String, dynamic> data) async {
    final id = await getCustomerId();
    final response = await http.put(
      Uri.parse('$baseUrl/profil/$id'),
      headers: headers,
      body: json.encode(data),
    );
    return response.statusCode == 200;
  }
}
