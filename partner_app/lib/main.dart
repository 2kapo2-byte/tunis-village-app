import 'package:flutter/material.dart';

void main() {
  runApp(const TunisVillagePartnerApp());
}

class TunisVillagePartnerApp extends StatelessWidget {
  const TunisVillagePartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tunis Village Partners',
      debugShowCheckedModeBanner: false,
      home: const PartnerShell(),
    );
  }
}

class PartnerShell extends StatelessWidget {
  const PartnerShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Tunis Village Partners'),
      ),
    );
  }
}
