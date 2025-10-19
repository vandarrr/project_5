import 'package:flutter/material.dart';
import '/helpers/user_info.dart';
import '/ui/beranda.dart';
import '/ui/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Kalau ingin selalu mulai dari login, abaikan token
  // var token = await UserInfo().getToken(); // nonaktifkan baris ini

  runApp(
    MaterialApp(
      title: "LokerIn APP", // sekalian ganti nama app
      debugShowCheckedModeBanner: false,
      home: const Login(), // 🔹 langsung ke LoginPage
    ),
  );
}
