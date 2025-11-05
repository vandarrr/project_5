import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class KemampuanTeknisPage extends StatefulWidget {
  final List<Map<String, String>>? kemampuanSebelumnya;
  final Function(List<Map<String, String>>)? onUpdate;

  const KemampuanTeknisPage({Key? key, this.kemampuanSebelumnya, this.onUpdate})
    : super(key: key);

  @override
  State<KemampuanTeknisPage> createState() => _KemampuanTeknisPageState();
}

class _KemampuanTeknisPageState extends State<KemampuanTeknisPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController kategoriController = TextEditingController();
  final TextEditingController tingkatController = TextEditingController();

  List<Map<String, dynamic>> kemampuanList = [];
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadKemampuan();
  }

  // Load semua kemampuan dari database
  Future<void> _loadKemampuan() async {
    final data = await dbHelper.getAllKemampuanTeknis();
    setState(() {
      kemampuanList = data;
    });

    // Update ProfilPage jika callback tersedia
    if (widget.onUpdate != null) {
      widget.onUpdate!(
        kemampuanList
            .map((e) => e.map((k, v) => MapEntry(k, v.toString())))
            .toList(),
      );
    }
  }

  // Tambah kemampuan baru
  Future<void> _tambahKemampuan() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'nama': namaController.text,
        'kategori': kategoriController.text,
        'tingkat': tingkatController.text,
      };

      try {
        await dbHelper.insertKemampuanTeknis(data);

        // Reload list agar sinkron dengan database
        await _loadKemampuan();

        // Clear form
        namaController.clear();
        kategoriController.clear();
        tingkatController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Kemampuan teknis berhasil ditambahkan"),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menambahkan kemampuan: $e")),
        );
      }
    }
  }

  // Hapus kemampuan
  Future<void> _hapusKemampuan(int id) async {
    await dbHelper.deleteKemampuanTeknis(id);
    await _loadKemampuan();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Kemampuan teknis berhasil dihapus")),
    );
  }

  // Simpan semua dan kembali ke ProfilPage
  void _simpanSemua() {
    final updatedList = kemampuanList
        .map((e) => e.map((k, v) => MapEntry(k, v.toString())))
        .toList();

    if (widget.onUpdate != null) {
      widget.onUpdate!(updatedList);
    }

    Navigator.pop(context, {'kemampuan': updatedList});
  }

  @override
  void dispose() {
    namaController.dispose();
    kategoriController.dispose();
    tingkatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Kemampuan Teknis",
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
                    "Tambah Kemampuan Teknis",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  _judul("Nama Kemampuan"),
                  TextFormField(
                    controller: namaController,
                    decoration: _inputDecoration(
                      "Contoh: Photoshop, Flutter, Excel",
                    ),
                    validator: (v) => v == null || v.isEmpty
                        ? "Nama kemampuan wajib diisi"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _judul("Kategori / Bidang"),
                  TextFormField(
                    controller: kategoriController,
                    decoration: _inputDecoration(
                      "Contoh: Desain, Coding, Administrasi",
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Kategori wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),
                  _judul("Tingkat Keahlian"),
                  TextFormField(
                    controller: tingkatController,
                    decoration: _inputDecoration(
                      "Contoh: Pemula, Menengah, Mahir",
                    ),
                    validator: (v) => v == null || v.isEmpty
                        ? "Tingkat keahlian wajib diisi"
                        : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _tambahKemampuan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Tambah Kemampuan",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Daftar Kemampuan Teknis",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 10),
            kemampuanList.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Belum ada kemampuan teknis yang ditambahkan.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : Column(
                    children: kemampuanList.map((k) {
                      final id = k['id'] is int
                          ? k['id']
                          : int.tryParse(k['id'].toString());
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            k['nama'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(k['kategori'] ?? ''),
                              Text(
                                k['tingkat'] ?? '',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: id != null
                                ? () => _hapusKemampuan(id)
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
