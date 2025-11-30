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

  void _showLayananDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Pilih Layanan'),
              titleTextStyle: TextStyle(
                color: Theme.of(context).textTheme.titleLarge?.color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: Theme.of(context).cardColor,
              contentPadding: const EdgeInsets.all(16),
              content: SizedBox(
                width: double.maxFinite,
                child: _services.isEmpty
                    ? const Center(
                        child: Text('Tidak ada layanan tersedia'),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _services.length,
                        itemBuilder: (context, index) {
                          final service = _services[index];
                          final isSelected = _selectedServices.any(
                            (s) => s['service_name'] == service['service_name'],
                          );

                          return CheckboxListTile(
                            title: Text(
                              service['service_name'] ?? 'Unknown',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            ),
                            subtitle: Text(
                              'Rp ${(service['price'] as num).toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            value: isSelected,
                            onChanged: (value) {
                              setDialogState(() {
                                if (value == true) {
                                  _selectedServices.add(service);
                                } else {
                                  _selectedServices.removeWhere(
                                    (s) =>
                                        s['service_name'] ==
                                        service['service_name'],
                                  );
                                }
                              });

                              // Update state halaman utama
                              setState(() {});
                            },
                            activeColor: Colors.teal,
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Batal',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Selesai'),
                ),
              ],
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

      // ✅ TODO: Implementasi save ke Supabase dengan model Order yang sesuai
      // Format data yang dikirim:
      // {
      //   'customer_name': _customerNameController.text,
      //   'phone': _phoneController.text,
      //   'address': _addressController.text,
      //   'service_type': serviceTypeStr,
      //   'total_price': _totalPrice,
      //   'notes': _notesController.text,
      //   'status': 'pending',
      //   'created_at': DateTime.now().toIso8601String(),
      // }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✓ Order berhasil ditambahkan')),
      );

      // Clear form
      _customerNameController.clear();
      _phoneController.clear();
      _addressController.clear();
      _notesController.clear();
      setState(() {
        _selectedServices.clear();
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        Get.back();
      });
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

            // ========== PILIH LAYANAN (CHECKLIST DIALOG) ==========
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
              InkWell(
                onTap: _showLayananDialog,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(
                      color: Colors.teal,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedServices.isEmpty
                            ? 'Klik untuk memilih layanan'
                            : 'Dipilih: ${_selectedServices.length} layanan',
                        style: TextStyle(
                          color: _selectedServices.isEmpty
                              ? Colors.grey[600]
                              : Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 14,
                        ),
                      ),
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.teal,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // ========== TAMPILKAN LAYANAN YANG DIPILIH (CHIPS) ==========
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
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                          onDeleted: () => _removeSelectedService(index),
                          backgroundColor: Colors.teal[100],
                          deleteIconColor: Colors.teal[700],
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
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.teal,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Harga:',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Rp ${_totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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
