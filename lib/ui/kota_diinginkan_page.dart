import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class KotaDiinginkanPage extends StatefulWidget {
  const KotaDiinginkanPage({Key? key}) : super(key: key);

  @override
  State<KotaDiinginkanPage> createState() => _KotaDiinginkanPageState();
}

class _KotaDiinginkanPageState extends State<KotaDiinginkanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController kotaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExistingKota();
  }

  Future<void> _loadExistingKota() async {
    final existingKota = await DatabaseHelper.instance.getKotaDiinginkan();
    if (existingKota != null && existingKota.isNotEmpty) {
      setState(() {
        kotaController.text = existingKota;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kota Diinginkan"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: kotaController,
                decoration: const InputDecoration(
                  labelText: "Masukkan kota diinginkan",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Simpan ke database
                    await DatabaseHelper.instance.insertOrUpdateKotaDiinginkan(
                      kotaController.text,
                    );

                    // Kembalikan data ke ProfilPage agar tampil langsung
                    Navigator.pop(context, {'kota': kotaController.text});
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
