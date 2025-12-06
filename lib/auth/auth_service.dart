// lib/auth/auth_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<String?> logIn(String email, String password) async {
    try {
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return res.user?.id;
    } on AuthApiException catch (e) {
      print("Login failed: ${e.message}");
      return null; // Return null so login failure can be handled
    } catch (e) {
      print("Unexpected login error: $e");
      return null;
    }
  }

  Future<void> logInWithGoogle() async {
    print("Log in with Google will be available soon");
  }

  Future<String?> register(
      String fullName, String username, String email, String password) async {
    final res = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (res.user != null) {
      await supabase.from('user_info').insert({
        'user_id': res.user!.id,
        'full_name': fullName,
        'username': username,
        'registration_finished': false,
      });

      return await logIn(email, password);
    }

    return null;
  }

  Future<void> registerWithGoogle() async {
    print("Registration with Google will be available soon");
  }

  Future<void> resetPassword() async {
    print("Reset password will be available soon");
  }

  Future<void> logOut() async {
    await supabase.auth.signOut();
  }

  Future<bool> deleteAccount() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return false;

      // 1️⃣ Delete user_info row
      await supabase.from('user_info').delete().eq('user_id', user.id);

      // 2️⃣ Call edge function to delete auth.user
      await supabase.functions.invoke(
        'delete-user',
        body: {'user_id': user.id},
      );

      // 3️⃣ Sign out
      await supabase.auth.signOut();

      return true;
    } catch (e) {
      print('Failed to delete account: $e');
      return false;
    }
  }
}
