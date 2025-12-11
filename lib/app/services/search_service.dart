import 'package:supabase_flutter/supabase_flutter.dart';

class SearchService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<String>> searchByUsernameAndFullName(String search) async {
    search = search.trim();

    final response = await supabase
        .from('user_info')
        .select('user_id')
        .or('username.ilike.%$search%,full_name.ilike.%$search%');

    return (response as List)
        .map((row) => row['user_id'] as String)
        .toList();
  }
}
