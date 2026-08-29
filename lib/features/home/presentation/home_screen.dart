import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تونس فيليج'),
          actions: [
            IconButton(
              onPressed: () => context.push('/notifications'),
              tooltip: 'الإشعارات',
              icon: const Icon(Icons.notifications_none),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('اكتشف إقامتك في قرية تونس', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                const Text('ابحث عن الفيلا أو الوحدة المناسبة لتاريخ إقامتك.'),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('ابدأ البحث'),
                        const SizedBox(height: 14),
                        FilledButton.icon(
                          onPressed: () => context.push('/search'),
                          icon: const Icon(Icons.search),
                          label: const Text('البحث عن وحدات متاحة'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
