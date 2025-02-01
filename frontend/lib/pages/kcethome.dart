import 'package:flutter/material.dart';


class KceHome extends StatelessWidget {
  const KceHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KCET Home'),
      ),
      body: const Center(
        child: Text('Welcome to the KCET Home Page!'),
      ),
    );
  }
}
