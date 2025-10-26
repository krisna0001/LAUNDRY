import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Service'),
        backgroundColor: const Color(0xFF005f9f),
      ),
      body: const Center(
        child: Text(
          'Halaman Chat dengan CS',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}