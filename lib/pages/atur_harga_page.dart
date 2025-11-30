import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:laundry3b1titik0/services/supabase_service.dart';

class AturHargaPage extends StatefulWidget {
  const AturHargaPage({Key? key}) : super(key: key);

  @override
  State<AturHargaPage> createState() => _AturHargaPageState();
}

class _AturHargaPageState extends State<AturHargaPage> {
  final SupabaseService _supabaseService = SupabaseService();
  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController _namaLayananController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  File? _imageFile;
  bool _isUploading = false;
  List<Map<String, dynamic>> _pricingList = [];

  @override
  void initState() {
    super.initState();
    _loadPricingData();
  }

  Future<void> _loadPricingData() async {
    final data = await _supabaseService.getPricing();
    setState(() {
      _pricingList = data;
    });
  }

  // Fungsi pilih gambar dari gallery
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  // Fungsi tambah harga
  Future<void> _addPricing() async {
    if (_namaLayananController.text.isEmpty || _hargaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama layanan dan harga harus diisi')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      String? imageUrl;

      // Jika ada gambar, upload dulu
      if (_imageFile != null) {
        imageUrl = await _supabaseService.uploadServiceImage(_imageFile!);
        if (imageUrl == null) {
          throw Exception('Gagal upload gambar');
        }
      }

      // Simpan ke database
      final success = await _supabaseService.setPricing(
        _namaLayananController.text,
        double.parse(_hargaController.text),
        imageUrl: imageUrl,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harga berhasil ditambahkan')),
        );

        // Reset form
        _namaLayananController.clear();
        _hargaController.clear();
        setState(() {
          _imageFile = null;
        });

        // Reload data
        _loadPricingData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atur Harga Layanan'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ========== AREA UPLOAD FOTO ==========
          Text(
            'Foto Layanan',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: _imageFile == null ? Colors.grey[300] : null,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.teal,
                  width: 2,
                ),
              ),
              child: _imageFile == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 48,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Pilih Foto dari Gallery',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _imageFile = null;
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 24),
          // ========== INPUT NAMA LAYANAN ==========
          TextField(
            controller: _namaLayananController,
            decoration: InputDecoration(
              labelText: 'Nama Layanan',
              prefixIcon: const Icon(Icons.local_laundry_service),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // ========== INPUT HARGA ==========
          TextField(
            controller: _hargaController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Harga (Rp)',
              prefixIcon: const Icon(Icons.attach_money),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // ========== TOMBOL TAMBAH ==========
          ElevatedButton.icon(
            icon: _isUploading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.add),
            label: Text(
              _isUploading ? 'Mengunggah...' : 'Tambah Harga',
            ),
            onPressed: _isUploading ? null : _addPricing,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 14),
              disabledBackgroundColor: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          // ========== DAFTAR HARGA ==========
          Text(
            'Daftar Harga Layanan',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _pricingList.isEmpty
              ? Center(
                  child: Text(
                    'Belum ada data harga',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pricingList.length,
                  itemBuilder: (context, index) {
                    final item = _pricingList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: item['image_url'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item['image_url'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey[300],
                                      child:
                                          const Icon(Icons.image_not_supported),
                                    );
                                  },
                                ),
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image),
                              ),
                        title: Text(item['service_name'] ?? 'N/A'),
                        subtitle: Text(
                          'Rp ${item['price']?.toStringAsFixed(0) ?? '0'}',
                          style: const TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _namaLayananController.dispose();
    _hargaController.dispose();
    super.dispose();
  }
}
