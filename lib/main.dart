import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helpers/lamaran_provider.dart';
import 'helpers/saved_provider.dart'; // ✅ Tambahkan import ini
import 'ui/welcome_page.dart';
import 'ui/beranda.dart';
import 'ui/login.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LamaranProvider()),
        ChangeNotifierProvider(
          create: (_) => SavedProvider(),
        ), // ✅ Tambahkan baris ini
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LokerIn',
      home: const WelcomePage(), // ✅ Halaman pertama
    );
  }
}
