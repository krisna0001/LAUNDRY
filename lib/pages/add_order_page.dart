import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry3b1titik0/services/supabase_service.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({Key? key}) : super(key: key);

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final SupabaseService _supabaseService = SupabaseService();

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  List<Map<String, dynamic>> _services = [];
  List<Map<String, dynamic>> _selectedServices = [];
  bool _isLoadingServices = true;
  bool _isSubmitting = false;

  // Getter untuk menghitung total harga otomatis
  double get _totalPrice => _selectedServices.fold(
      0, (sum, item) => sum + (item['price'] as num).toDouble());

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      setState(() {
        _isLoadingServices = true;
      });

      print('📥 Loading services from Supabase...');
      final services = await _supabaseService.getPricing();

      if (services.isEmpty) {
        print('⚠️ No services found');
      } else {
        print('✓ Loaded ${services.length} services');
      }

      setState(() {
        _services = services;
      });
    } catch (e) {
      print('❌ Error loading services: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading services: $e')),
      );
    } finally {
      setState(() {
        _isLoadingServices = false;
      });
    }
  }

  void _showLayananBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pilih Layanan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  // List Layanan
                  Expanded(
                    child: _services.isEmpty
                        ? const Center(
                            child: Text('Tidak ada layanan tersedia'),
                          )
                        : ListView.builder(
                            itemCount: _services.length,
                            itemBuilder: (context, index) {
                              final service = _services[index];
                              final isSelected = _selectedServices.any(
                                (s) =>
                                    s['service_name'] ==
                                    service['service_name'],
                              );

                              return CheckboxListTile(
                                title:
                                    Text(service['service_name'] ?? 'Unknown'),
                                subtitle: Text(
                                  'Rp ${(service['price'] as num).toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                value: isSelected,
                                onChanged: (value) {
                                  setModalState(() {
                                    if (value == true) {
                                      // Tambah ke selected
                                      _selectedServices.add(service);
                                    } else {
                                      // Hapus dari selected
                                      _selectedServices.removeWhere(
                                        (s) =>
                                            s['service_name'] ==
                                            service['service_name'],
                                      );
                                    }
                                  });

                                  // Update state halaman utama juga
                                  setState(() {});
                                },
                              );
                            },
                          ),
                  ),
                  // Footer dengan tombol konfirmasi
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dipilih: ${_selectedServices.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Selesai'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _removeSelectedService(int index) {
    setState(() {
      _selectedServices.removeAt(index);
    });
  }

  Future<void> _submitOrder() async {
    // Validasi input
    if (_customerNameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      print('📝 Submitting order...');

      // Gabungkan nama layanan menjadi satu string koma
      final serviceTypeStr =
          _selectedServices.map((e) => e['service_name']).join(', ');

      print('🛎️ Services: $serviceTypeStr');
      print('💰 Total Price: $_totalPrice');

      // TODO: Simpan order ke database dengan serviceTypeStr dan _totalPrice
      // const success = await _supabaseService.addOrder({
      //   'customer_name': _customerNameController.text,
      //   'phone': _phoneController.text,
      //   'address': _addressController.text,
      //   'service_type': serviceTypeStr,
      //   'total_price': _totalPrice,
      //   'notes': _notesController.text,
      //   'status': 'pending',
      // });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order berhasil ditambahkan')),
      );

      // Clear form
      _customerNameController.clear();
      _phoneController.clear();
      _addressController.clear();
      _notesController.clear();
      setState(() {
        _selectedServices.clear();
      });

      Get.back();
    } catch (e) {
      print('❌ Error submitting order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Order Baru'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========== NAMA PELANGGAN ==========
            Text(
              'Nama Pelanggan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _customerNameController,
              decoration: InputDecoration(
                labelText: 'Masukkan nama pelanggan',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ========== NOMOR TELEPON ==========
            Text(
              'Nomor Telepon',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Masukkan nomor telepon',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ========== ALAMAT ==========
            Text(
              'Alamat Pengiriman',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Masukkan alamat lengkap',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ========== PILIH LAYANAN (MULTI-SELECT) ==========
            Text(
              'Pilih Layanan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (_isLoadingServices)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else if (_services.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.red.withOpacity(0.1),
                ),
                child: Text(
                  '❌ Layanan tidak ditemukan\n(Cek Policy Supabase atau koneksi internet)',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            else
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(
                  _selectedServices.isEmpty
                      ? 'Pilih Layanan (+)'
                      : 'Tambah Layanan (+)',
                ),
                onPressed: _showLayananBottomSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            const SizedBox(height: 16),

            // ========== TAMPILKAN LAYANAN YANG DIPILIH ==========
            if (_selectedServices.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Layanan Terpilih:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      _selectedServices.length,
                      (index) {
                        final service = _selectedServices[index];
                        return Chip(
                          label: Text(
                            '${service['service_name']} - Rp ${(service['price'] as num).toStringAsFixed(0)}',
                          ),
                          onDeleted: () => _removeSelectedService(index),
                          backgroundColor: Colors.teal[100],
                          deleteIconColor: Colors.teal,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),

            // ========== TAMPILKAN TOTAL HARGA ==========
            if (_selectedServices.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.teal),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Harga:'),
                    Text(
                      'Rp ${_totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // ========== CATATAN TAMBAHAN ==========
            Text(
              'Catatan Tambahan (Opsional)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Masukkan catatan jika ada',
                prefixIcon: const Icon(Icons.note),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ========== TOMBOL SUBMIT ==========
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.check),
                label: Text(
                  _isSubmitting ? 'Mengirim...' : 'Tambah Order',
                ),
                onPressed: _isSubmitting ? null : _submitOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  disabledBackgroundColor: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
