import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class RiwayatPendidikanPage extends StatefulWidget {
  final List<Map<String, String>>? pendidikanSebelumnya;
  final Function(List<Map<String, String>>)?
  onUpdate; // ✅ Callback ke ProfilPage

  const RiwayatPendidikanPage({
    Key? key,
    this.pendidikanSebelumnya,
    this.onUpdate,
  }) : super(key: key);

  @override
  State<RiwayatPendidikanPage> createState() => _RiwayatPendidikanPageState();
}

class _RiwayatPendidikanPageState extends State<RiwayatPendidikanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController institusiController = TextEditingController();
  final TextEditingController jurusanController = TextEditingController();
  final TextEditingController tahunController = TextEditingController();

  List<Map<String, dynamic>> pendidikanList = [];
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadPendidikan();
  }

  Future<void> _loadPendidikan() async {
    final data = await dbHelper.getAllPendidikan();
    setState(() {
      pendidikanList = data;
    });
  }

  Future<void> _tambahPendidikan() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'institusi': institusiController.text,
        'jurusan': jurusanController.text,
        'tahun': tahunController.text,
      };

      await dbHelper.insertPendidikan(data);
      await _loadPendidikan();

      // ✅ Panggil callback untuk update ProfilPage
      if (widget.onUpdate != null) {
        widget.onUpdate!(
          pendidikanList
              .map((e) => e.map((k, v) => MapEntry(k, v.toString())))
              .toList(),
        );
      }

      institusiController.clear();
      jurusanController.clear();
      tahunController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Riwayat pendidikan berhasil ditambahkan"),
        ),
      );
    }
  }

  Future<void> _hapusPendidikan(int id) async {
    await dbHelper.deletePendidikan(id);
    await _loadPendidikan();

    if (widget.onUpdate != null) {
      widget.onUpdate!(
        pendidikanList
            .map((e) => e.map((k, v) => MapEntry(k, v.toString())))
            .toList(),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Riwayat pendidikan berhasil dihapus")),
    );
  }

  void _simpanSemua() {
    if (widget.onUpdate != null) {
      widget.onUpdate!(
        pendidikanList
            .map((e) => e.map((k, v) => MapEntry(k, v.toString())))
            .toList(),
      );
    }
    Navigator.pop(context); // ✅ Kembali ke ProfilPage
  }

  @override
  void dispose() {
    institusiController.dispose();
    jurusanController.dispose();
    tahunController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Riwayat Pendidikan",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.3,
        actions: [
          TextButton(
            onPressed: _simpanSemua,
            child: const Text("Simpan", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tambah Riwayat Pendidikan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  _judul("Nama Institusi"),
                  TextFormField(
                    controller: institusiController,
                    decoration: _inputDecoration("Masukkan nama institusi"),
                    validator: (v) => v == null || v.isEmpty
                        ? "Nama institusi wajib diisi"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _judul("Jurusan"),
                  TextFormField(
                    controller: jurusanController,
                    decoration: _inputDecoration("Masukkan jurusan"),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Jurusan wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),
                  _judul("Tahun Masuk - Lulus"),
                  TextFormField(
                    controller: tahunController,
                    decoration: _inputDecoration("Contoh: 2018 - 2022"),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Tahun wajib diisi" : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _tambahPendidikan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Tambah Pendidikan",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Daftar Riwayat Pendidikan",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 10),
            pendidikanList.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Belum ada riwayat pendidikan yang ditambahkan.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : Column(
                    children: pendidikanList.map((p) {
                      final id = p['id'] is int
                          ? p['id']
                          : int.tryParse(p['id'].toString());
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            p['institusi'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p['jurusan'] ?? ''),
                              Text(
                                p['tahun'] ?? '',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: id != null
                                ? () => _hapusPendidikan(id)
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _judul(String text) =>
      Text(text, style: const TextStyle(fontWeight: FontWeight.w600));

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue, width: 1.3),
      ),
    );
  }
}
