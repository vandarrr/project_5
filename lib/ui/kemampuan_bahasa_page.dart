import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class KemampuanBahasaPage extends StatefulWidget {
  final List<Map<String, String>> bahasaSebelumnya;
  final Function(List<Map<String, String>>) onUpdate;

  const KemampuanBahasaPage({
    Key? key,
    required this.bahasaSebelumnya,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<KemampuanBahasaPage> createState() => _KemampuanBahasaPageState();
}

class _KemampuanBahasaPageState extends State<KemampuanBahasaPage> {
  final TextEditingController bahasaController = TextEditingController();
  final List<String> tingkatKemampuanList = [
    'Pemula',
    'Menengah',
    'Mahir',
    'Profesional',
  ];
  String? tingkatKemampuan;
  List<Map<String, dynamic>> kemampuanBahasaList = [];
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadKemampuanBahasa();
  }

  // --- Ambil semua data dari database
  Future<void> _loadKemampuanBahasa() async {
    final data = await dbHelper.getAllKemampuanBahasa();

    // Gabungkan dengan data sebelumnya (profil)
    final allData = {
      for (var item in data) item['id']: item,
      for (var e in widget.bahasaSebelumnya)
        e['id']: {
          'id': int.tryParse(e['id'].toString()) ?? 0,
          'bahasa': e['bahasa'],
          'tingkat': e['tingkat'],
        },
    };

    setState(() {
      kemampuanBahasaList = allData.values.toList();
    });
  }

  // --- Tambah kemampuan bahasa baru (langsung tampil)
  Future<void> _addKemampuanBahasa() async {
    final bahasa = bahasaController.text.trim();
    final tingkat = tingkatKemampuan ?? "";

    if (bahasa.isEmpty || tingkat.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua field terlebih dahulu.")),
      );
      return;
    }

    // Simpan ke database
    final id = await dbHelper.insertKemampuanBahasa({
      'bahasa': bahasa,
      'tingkat': tingkat,
    });

    // Tambahkan langsung ke daftar
    final newItem = {'id': id, 'bahasa': bahasa, 'tingkat': tingkat};

    setState(() {
      kemampuanBahasaList.insert(0, newItem); // langsung muncul di atas
    });

    // Bersihkan input
    bahasaController.clear();
    setState(() => tingkatKemampuan = null);

    // Notifikasi
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Kemampuan bahasa berhasil ditambahkan.")),
    );

    // Sinkronkan ke profil
    widget.onUpdate(
      kemampuanBahasaList
          .map(
            (e) => {
              'bahasa': e['bahasa'].toString(),
              'tingkat': e['tingkat'].toString(),
            },
          )
          .toList(),
    );
  }

  // --- Hapus data kemampuan bahasa
  Future<void> _deleteKemampuanBahasa(int id) async {
    await dbHelper.deleteKemampuanBahasa(id);

    setState(() {
      kemampuanBahasaList.removeWhere((item) {
        final itemId = int.tryParse(item['id'].toString()) ?? 0;
        return itemId == id;
      });
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Kemampuan bahasa dihapus.")));

    // Sinkronkan perubahan
    widget.onUpdate(
      kemampuanBahasaList
          .map(
            (e) => {
              'bahasa': e['bahasa'].toString(),
              'tingkat': e['tingkat'].toString(),
            },
          )
          .toList(),
    );
  }

  // --- Simpan semua perubahan dan kembali
  void _saveAndReturn() {
    widget.onUpdate(
      kemampuanBahasaList
          .map(
            (e) => {
              'bahasa': e['bahasa'].toString(),
              'tingkat': e['tingkat'].toString(),
            },
          )
          .toList(),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Perubahan disimpan.")));

    Navigator.pop(context);
  }

  void _clearForm() {
    bahasaController.clear();
    setState(() {
      tingkatKemampuan = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Kemampuan Bahasa"),
        backgroundColor: Colors.blue,
        actions: [
          TextButton(
            onPressed: _saveAndReturn,
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Input Bahasa ---
            const Text("Bahasa", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: bahasaController,
              decoration: InputDecoration(
                hintText: "Masukkan bahasa",
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Dropdown Tingkat Kemampuan ---
            const Text(
              "Tingkat Kemampuan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: tingkatKemampuan,
                  hint: const Text("Pilih tingkat kemampuan"),
                  isExpanded: true,
                  items: tingkatKemampuanList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      tingkatKemampuan = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- Tombol Tambah ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addKemampuanBahasa,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Tambah",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- List Data ---
            if (kemampuanBahasaList.isNotEmpty) ...[
              const Text(
                "Daftar Kemampuan Bahasa",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: kemampuanBahasaList.length,
                itemBuilder: (context, index) {
                  final item = kemampuanBahasaList[index];
                  final id = int.tryParse(item['id'].toString()) ?? 0;
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(item['bahasa'] ?? '-'),
                      subtitle: Text(item['tingkat'] ?? '-'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteKemampuanBahasa(id),
                      ),
                    ),
                  );
                },
              ),
            ] else
              const Text("Belum ada kemampuan bahasa yang ditambahkan."),
          ],
        ),
      ),
    );
  }
}
