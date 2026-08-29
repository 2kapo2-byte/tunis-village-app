import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/review_repository.dart';

class CreateReviewScreen extends StatefulWidget {
  const CreateReviewScreen({
    super.key,
    required this.bookingId,
    required this.propertyId,
    required this.repository,
  });

  final String bookingId;
  final String propertyId;
  final ReviewRepository repository;

  @override
  State<CreateReviewScreen> createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  int _rating = 5;
  final _title = TextEditingController();
  final _body = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving) return;
    setState(() { _saving = true; _error = null; });
    try {
      await widget.repository.create(
        bookingId: widget.bookingId,
        propertyId: widget.propertyId,
        overall: _rating,
        title: _title.text,
        body: _body.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال التقييم للمراجعة.')));
      context.pop();
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('قيّم إقامتك')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('التقييم العام', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final value = index + 1;
                return IconButton(
                  onPressed: _saving ? null : () => setState(() => _rating = value),
                  icon: Icon(value <= _rating ? Icons.star : Icons.star_border, size: 34),
                );
              }),
            ),
            Text('$_rating من 5', textAlign: TextAlign.center),
            const SizedBox(height: 20),
            TextField(controller: _title, enabled: !_saving, decoration: const InputDecoration(labelText: 'عنوان التقييم')),
            const SizedBox(height: 12),
            TextField(controller: _body, enabled: !_saving, maxLines: 6, decoration: const InputDecoration(labelText: 'اكتب تجربتك')),
            if (_error != null)
              Padding(padding: const EdgeInsets.only(top: 12), child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
            const SizedBox(height: 24),
            FilledButton(onPressed: _saving ? null : _submit, child: Text(_saving ? 'جاري الإرسال...' : 'إرسال التقييم')),
            const SizedBox(height: 8),
            const Text('التقييم غير قابل للتعديل أو الحذف بعد الإنشاء. قرار النشر/الإخفاء يخضع لإدارة المنصة.', textAlign: TextAlign.center),
          ],
        ),
      );
}
