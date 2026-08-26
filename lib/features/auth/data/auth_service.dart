import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  const AuthService(this._client);

  final SupabaseClient _client;

  Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;

  Session? get currentSession => _client.auth.currentSession;

  User? get currentUser => _client.auth.currentUser;

  Future<void> signOut() => _client.auth.signOut();
}
