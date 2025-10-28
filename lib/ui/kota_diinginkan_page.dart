import 'package:flutter/material.dart';

class KotaDiinginkanPage extends StatefulWidget {
  const KotaDiinginkanPage({Key? key}) : super(key: key);

  @override
  State<KotaDiinginkanPage> createState() => _KotaDiinginkanPageState();
}

class _KotaDiinginkanPageState extends State<KotaDiinginkanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController kotaController = TextEditingController();

  @override
  void dispose() {
    kotaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kota Diinginkan"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Masukkan kota yang kamu inginkan untuk bekerja",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: kotaController,
                decoration: InputDecoration(
                  labelText: "Kota Diinginkan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Kota tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context, {'kota': kotaController.text});
                    }
                  },
                  child: const Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
