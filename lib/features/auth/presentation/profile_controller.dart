import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final currentUserProvider = StreamProvider<User?>((ref) async* {
  final client = Supabase.instance.client;
  yield client.auth.currentUser;
  await for (final event in client.auth.onAuthStateChange) {
    yield event.session?.user;
  }
});
