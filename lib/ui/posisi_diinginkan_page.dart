import 'package:flutter/material.dart';

class PosisiDiinginkanPage extends StatefulWidget {
  const PosisiDiinginkanPage({Key? key}) : super(key: key);

  @override
  State<PosisiDiinginkanPage> createState() => _PosisiDiinginkanPageState();
}

class _PosisiDiinginkanPageState extends State<PosisiDiinginkanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController posisiController = TextEditingController();

  @override
  void dispose() {
    posisiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posisi Diinginkan"),
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
                "Masukkan posisi yang kamu inginkan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: posisiController,
                decoration: InputDecoration(
                  labelText: "Posisi Diinginkan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Posisi tidak boleh kosong";
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
                      Navigator.pop(context, {'posisi': posisiController.text});
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
