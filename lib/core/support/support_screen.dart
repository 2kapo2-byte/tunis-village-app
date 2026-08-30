import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text('المساعدة والدعم')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: const [
              Text('إزاي نقدر نساعدك؟', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              ExpansionTile(title: Text('مشكلة في الحجز'), children: [Padding(padding: EdgeInsets.all(16), child: Text('افتح تفاصيل الحجز وتأكد من حالته. إذا استمرت المشكلة، احتفظ بكود الحجز عند طلب الدعم.'))]),
              ExpansionTile(title: Text('الدفع لم يكتمل'), children: [Padding(padding: EdgeInsets.all(16), child: Text('لا تعيد الدفع بشكل متكرر. تحقق أولًا من حالة الدفع داخل تفاصيل الحجز.'))]),
              ExpansionTile(title: Text('كيف ألغي الحجز؟'), children: [Padding(padding: EdgeInsets.all(16), child: Text('افتح الحجز ثم اختر الإلغاء إذا كان الحجز يسمح بذلك. سيتم حساب الاسترداد وفق سياسة الإلغاء.'))]),
              ExpansionTile(title: Text('الاتصال بالإنترنت'), children: [Padding(padding: EdgeInsets.all(16), child: Text('عند انقطاع الإنترنت ستظهر رسالة واضحة. أعد المحاولة بعد عودة الاتصال ولا تكرر عمليات الدفع أو الحجز قبل التأكد من الحالة.'))]),
            ],
          ),
        ),
      );
}
