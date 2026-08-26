import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.authenticated, required this.unauthenticated});

  final Widget authenticated;
  final Widget unauthenticated;

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;
    return StreamBuilder<AuthState>(
      stream: client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = snapshot.data?.session ?? client.auth.currentSession;
        return session == null ? unauthenticated : authenticated;
      },
    );
  }
}
