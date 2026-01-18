import 'package:flutter/material.dart';
import 'ui/redacteur_interface.dart';

void main() {
  runApp(const MonApplication());
}

class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RedacteurInterface(),
    );
  }
}
