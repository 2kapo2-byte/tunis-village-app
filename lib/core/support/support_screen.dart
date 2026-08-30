import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static final Uri _email = Uri(scheme: 'mailto', path: 'support@tunisvillage.com', queryParameters: {'subject': 'Tunis Village App Support'});

  Future<void> _contact(BuildContext context) async {
    final launched = await launchUrl(_email);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر فتح تطبيق البريد.')));
    }
  }

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text('المساعدة والدعم')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('إزاي نقدر نساعدك؟', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const ExpansionTile(title: Text('مشكلة في الحجز'), children: [Padding(padding: EdgeInsets.all(16), child: Text('افتح تفاصيل الحجز وتأكد من حالته. إذا استمرت المشكلة، تواصل مع الدعم.'))]),
              const ExpansionTile(title: Text('الدفع لم يكتمل'), children: [Padding(padding: EdgeInsets.all(16), child: Text('لا تعيد الدفع بشكل متكرر. تحقق أولًا من حالة الدفع داخل تفاصيل الحجز.'))]),
              const ExpansionTile(title: Text('كيف ألغي الحجز؟'), children: [Padding(padding: EdgeInsets.all(16), child: Text('افتح الحجز ثم اختر الإلغاء إذا كان الحجز يسمح بذلك. سيتم حساب الاسترداد وفق سياسة الإلغاء.'))]),
              const SizedBox(height: 20),
              FilledButton.icon(onPressed: () => _contact(context), icon: const Icon(Icons.email_outlined), label: const Text('تواصل مع الدعم')),
            ],
          ),
        ),
      );
}
