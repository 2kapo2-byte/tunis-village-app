import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../domain/search_query.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.partnerMode = false});
  final bool partnerMode;
  @override State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _adults = 2;
  final List<int> _childrenAges = [];

  Future<void> _pickDate({required bool checkIn}) async {
    final now = DateTime.now();
    final initial = checkIn ? (_checkIn ?? now) : (_checkOut ?? _checkIn ?? now.add(const Duration(days: 1)));
    final firstDate = checkIn ? now : (_checkIn ?? now);
    final selected = await showDatePicker(context: context, initialDate: initial.isBefore(firstDate) ? firstDate : initial, firstDate: firstDate, lastDate: DateTime(now.year + 2));
    if (selected == null) return;
    setState(() {
      if (checkIn) { _checkIn = selected; if (_checkOut != null && !_checkOut!.isAfter(selected)) _checkOut = null; }
      else { _checkOut = selected; }
    });
  }

  Future<void> _manageGuests() async {
    var adults = _adults;
    final ages = List<int>.from(_childrenAges);
    await showModalBottomSheet<void>(
      context: context, isScrollControlled: true,
      builder: (context) => StatefulBuilder(builder: (context, setSheetState) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('الضيوف', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ListTile(title: const Text('البالغون'), subtitle: const Text('18 سنة فأكثر'), trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(onPressed: adults > 1 ? () => setSheetState(() => adults--) : null, icon: const Icon(Icons.remove_circle_outline)), Text('$adults'), IconButton(onPressed: () => setSheetState(() => adults++), icon: const Icon(Icons.add_circle_outline)),
          ])),
          ...List.generate(ages.length, (index) => ListTile(title: Text('طفل ${index + 1}'), trailing: DropdownButton<int>(value: ages[index], items: List.generate(18, (age) => DropdownMenuItem(value: age, child: Text('$age سنة'))), onChanged: (value) => setSheetState(() => ages[index] = value ?? 0)))),
          Align(alignment: AlignmentDirectional.centerStart, child: TextButton.icon(onPressed: ages.length >= 10 ? null : () => setSheetState(() => ages.add(0)), icon: const Icon(Icons.child_care), label: const Text('إضافة طفل')),
          const SizedBox(height: 8), FilledButton(onPressed: () { setState(() { _adults = adults; _childrenAges..clear()..addAll(ages); }); Navigator.pop(context); }, child: const Text('تم')),
        ]),
      )),
    );
  }

  void _search() {
    if (_checkIn == null || _checkOut == null) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختر تاريخ الوصول والمغادرة أولًا.'))); return; }
    final query = SearchQuery(checkIn: _checkIn!, checkOut: _checkOut!, adults: _adults, childrenAges: List.unmodifiable(_childrenAges));
    context.push('/properties', extra: {'query': query, 'partnerMode': widget.partnerMode});
  }

  String _date(DateTime? value) => value == null ? 'اختيار التاريخ' : '${value.day}/${value.month}/${value.year}';

  @override
  Widget build(BuildContext context) {
    final nights = _checkIn != null && _checkOut != null ? _checkOut!.difference(_checkIn!).inDays : 0;
    return Scaffold(
      appBar: AppBar(title: Text(widget.partnerMode ? 'بحث وحجز للعميل' : 'البحث عن إقامة')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        if (widget.partnerMode) const Card(child: ListTile(leading: Icon(Icons.business_center_outlined), title: Text('وضع المسوق'), subtitle: Text('ابدأ بالبحث أولًا. بيانات العميل تُطلب فقط عند متابعة الحجز.'))),
        Text('خطط لإقامتك في قرية تونس', style: Theme.of(context).textTheme.headlineSmall), const SizedBox(height: 8),
        const Text('اختر التواريخ وعدد الضيوف للعثور على الوحدات المتاحة.'), const SizedBox(height: 24),
        Card(child: Column(children: [ListTile(leading: const Icon(Icons.login), title: const Text('تسجيل الوصول'), subtitle: Text(_date(_checkIn)), onTap: () => _pickDate(checkIn: true)), const Divider(height: 1), ListTile(leading: const Icon(Icons.logout), title: const Text('تسجيل المغادرة'), subtitle: Text(_date(_checkOut)), onTap: _checkIn == null ? null : () => _pickDate(checkIn: false))])),
        const SizedBox(height: 12), Card(child: ListTile(leading: const Icon(Icons.people_outline), title: const Text('الضيوف'), subtitle: Text('$_adults بالغ • ${_childrenAges.length} طفل'), trailing: const Icon(Icons.chevron_right), onTap: _manageGuests)),
        if (nights > 0) Padding(padding: const EdgeInsets.only(top: 12), child: Text('$nights ${nights == 1 ? 'ليلة' : 'ليالٍ'}', textAlign: TextAlign.center)),
        const SizedBox(height: 24), FilledButton.icon(onPressed: _search, icon: const Icon(Icons.search), label: const Text('البحث عن الوحدات المتاحة')),
      ]),
    );
  }
}
