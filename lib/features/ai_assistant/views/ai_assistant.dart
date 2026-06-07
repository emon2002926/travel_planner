import 'package:flutter/material.dart';

class AiAssistant extends StatelessWidget {
  const AiAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
      ),
      body: const Center(
        child: Text('Welcome to the AI Assistant!'),
      ),
    );
  }
}
