// lib/app_registration/data_loader.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class DataLoader {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<String>> getAllSports() async {
    // Fetch all sport_id values from sports_choices
    final response = await supabase
        .from('sports_choices')
        .select('sport_id')
        .order('name', ascending: true);

    // Convert results to List<String>
    final List<String> sportIds = response
        .map<String>((row) => row['sport_id'].toString())
        .toList();

    return sportIds;
  }
}
