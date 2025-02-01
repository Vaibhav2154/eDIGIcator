import 'package:flutter/material.dart';


class JeeHome extends StatelessWidget {
  const JeeHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JEE Home'),
      ),
      body: const Center(
        child: Text('Welcome to the JEE Home Page!'),
      ),
    );
  }
}
