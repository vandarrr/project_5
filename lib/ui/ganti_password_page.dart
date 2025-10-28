import 'package:flutter/material.dart';

class GantiPasswordPage extends StatefulWidget {
  final String? passwordLama;
  final String? passwordBaru;

  const GantiPasswordPage({Key? key, this.passwordLama, this.passwordBaru})
    : super(key: key);

  @override
  State<GantiPasswordPage> createState() => _GantiPasswordPageState();
}

class _GantiPasswordPageState extends State<GantiPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController passwordLamaController;
  late TextEditingController passwordBaruController;
  late TextEditingController konfirmasiPasswordController;

  @override
  void initState() {
    super.initState();
    passwordLamaController = TextEditingController(
      text: widget.passwordLama ?? "",
    );
    passwordBaruController = TextEditingController(
      text: widget.passwordBaru ?? "",
    );
    konfirmasiPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    passwordLamaController.dispose();
    passwordBaruController.dispose();
    konfirmasiPasswordController.dispose();
    super.dispose();
  }

  void _simpanPerubahan() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'passwordLama': passwordLamaController.text,
        'passwordBaru': passwordBaruController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ganti Password"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: passwordLamaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password Lama",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Masukkan password lama";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordBaruController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password Baru",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Masukkan password baru";
                  }
                  if (value.length < 6) {
                    return "Password minimal 6 karakter";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: konfirmasiPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Konfirmasi Password Baru",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != passwordBaruController.text) {
                    return "Password tidak cocok";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _simpanPerubahan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Simpan Perubahan",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
