import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(LucideIcons.user, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text("Pelanggan Laundry3B",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text("ID: ${user?.id.substring(0, 8) ?? '-'}",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
            ),
            const SizedBox(height: 32),
            const Card(
              margin: EdgeInsets.symmetric(horizontal: 20),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(LucideIcons.messageCircle,
                        color: Colors.green, size: 30),
                    SizedBox(height: 10),
                    Text(
                      "Butuh Bantuan?",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Hubungi Admin Laundry3B via WhatsApp:\n0812-3456-7890",
                      textAlign: TextAlign.center,
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            TextButton.icon(
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Berhasil keluar")));
                }
              },
              icon: const Icon(LucideIcons.logOut, color: Colors.red),
              label: const Text("Keluar Aplikasi",
                  style: TextStyle(color: Colors.red)),
            )
          ],
        ),
      ),
    );
  }
}
