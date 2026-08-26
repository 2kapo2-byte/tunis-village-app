import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'شاشة تسجيل الدخول الأساسية جاهزة للربط بخدمة المصادقة في المرحلة M1.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
