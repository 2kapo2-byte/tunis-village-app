import 'package:flutter/material.dart';
import '../../../core/auth/app_mode.dart';
import '../../../core/auth/app_mode_manager.dart';

class ModeSwitcher extends StatelessWidget {
  const ModeSwitcher({super.key, required this.manager});
  final AppModeManager manager;

  Future<void> _showModes(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => ListenableBuilder(
        listenable: manager,
        builder: (context, _) => SafeArea(
          child: RadioGroup<AppMode>(
            groupValue: manager.mode,
            onChanged: (value) async {
              if (value != null) await manager.switchMode(value);
              if (context.mounted) Navigator.pop(context);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(title: Text('استخدام التطبيق كـ', style: TextStyle(fontWeight: FontWeight.bold))),
                const RadioListTile<AppMode>(
                  value: AppMode.customer,
                  title: Text('العميل'),
                  subtitle: Text('البحث والحجز للاستخدام الشخصي'),
                ),
                if (manager.partnerAvailable)
                  const RadioListTile<AppMode>(
                    value: AppMode.partner,
                    title: Text('المسوق / الشريك'),
                    subtitle: Text('البحث والحجز للعملاء'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: manager,
      builder: (context, _) => InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => _showModes(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(manager.mode == AppMode.partner ? Icons.business_center_outlined : Icons.person_outline),
            const SizedBox(width: 6),
            Text(manager.mode.label),
            const Icon(Icons.keyboard_arrow_down),
          ]),
        ),
      ),
    );
  }
}
