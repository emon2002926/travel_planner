import 'package:flutter/material.dart';

class SafetyPage extends StatelessWidget {
  const SafetyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety'),
      ),
      body: const Center(
        child: Text('Welcome to the Safety Page!'),
      ),
    );
  }
}
