import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trandtribe/OnBoardScreen.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize your connection using the base Project URL
  await Supabase.initialize(
    url:
        'https://dmzxuhclvtvvnkztvhfb.supabase.co', // <-- Removed the /rest/v1/
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRtenh1aGNsdnR2dm5renR2aGZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQxMjM3NDQsImV4cCI6MjA5OTY5OTc0NH0.xa_D61nb-OIMoxd0Hueo14EVENwCMxnI0kNIEcGaXmE',
  );

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      opaqueRoute: false,
      title: 'TrendTribe Clothing',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: const OnBoardScreen(),
    );
  }
}
