// lib/main.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth/login.dart';
import 'style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://xycevnshuykigyoiawqe.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh5Y2V2bnNodXlraWd5b2lhd3FlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ4MzEwMjAsImV4cCI6MjA4MDQwNzAyMH0.hoWig5wBCfLmtfD4cMPS_8tg0dIZd0GDWRDi70T25lY',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.mainBackground,
        primaryColor: AppColors.mainWidget,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.mainText,
        ),
      ),
      home: LogInScreen(),
    );
  }
}
