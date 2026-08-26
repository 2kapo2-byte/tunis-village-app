import 'package:flutter/material.dart';

void main() {
  runApp(const TunisVillageApp());
}

class TunisVillageApp extends StatelessWidget {
  const TunisVillageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tunis Village',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0B5D4F),
          brightness: Brightness.light,
        ),
      ),
      home: const MobileFoundationScreen(),
    );
  }
}

class MobileFoundationScreen extends StatelessWidget {
  const MobileFoundationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tunis Village')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.travel_explore, size: 72),
              const SizedBox(height: 20),
              Text(
                'Tunis Village App',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Mobile foundation initialized.\nBooking features will be connected to the production platform in later phases.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
