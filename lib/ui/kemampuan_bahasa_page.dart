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

  Future<void> _loadKemampuanBahasa() async {
    final data = await dbHelper.getAllKemampuanBahasa();

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

  Future<void> _addKemampuanBahasa() async {
    final bahasa = bahasaController.text.trim();
    final tingkat = tingkatKemampuan ?? "";

    if (bahasa.isEmpty || tingkat.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua field terlebih dahulu.")),
      );
      return;
    }

    final id = await dbHelper.insertKemampuanBahasa({
      'bahasa': bahasa,
      'tingkat': tingkat,
    });

    final newItem = {'id': id, 'bahasa': bahasa, 'tingkat': tingkat};

    setState(() {
      kemampuanBahasaList.insert(0, newItem);
    });

    bahasaController.clear();
    setState(() {
      tingkatKemampuan = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Kemampuan bahasa berhasil ditambahkan.")),
    );

    widget.onUpdate(_convertList());
  }

  Future<void> _deleteKemampuanBahasa(int id) async {
    await dbHelper.deleteKemampuanBahasa(id);

    setState(() {
      kemampuanBahasaList.removeWhere((item) {
        return (item['id'] as int) == id;
      });
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Kemampuan bahasa dihapus.")));

    widget.onUpdate(_convertList());
  }

  // ================================
  //          ✨ FUNGSI EDIT
  // ================================
  void _editKemampuanBahasa(Map<String, dynamic> item) {
    final TextEditingController editBahasaController = TextEditingController(
      text: item['bahasa'],
    );

    String? editTingkat = item['tingkat'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Kemampuan Bahasa"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editBahasaController,
                decoration: const InputDecoration(labelText: "Bahasa"),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: editTingkat,
                decoration: const InputDecoration(labelText: "Tingkat"),
                items: tingkatKemampuanList.map((value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: (value) {
                  editTingkat = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Simpan"),
              onPressed: () async {
                await dbHelper.updateKemampuanBahasa(item['id'], {
                  'bahasa': editBahasaController.text,
                  'tingkat': editTingkat,
                });

                Navigator.pop(context);

                await _loadKemampuanBahasa();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Kemampuan bahasa berhasil diperbarui."),
                  ),
                );

                widget.onUpdate(_convertList());
              },
            ),
          ],
        );
      },
    );
  }

  List<Map<String, String>> _convertList() {
    return kemampuanBahasaList.map((e) {
      return {
        'bahasa': e['bahasa'].toString(),
        'tingkat': e['tingkat'].toString(),
      };
    }).toList();
  }

  void _saveAndReturn() {
    widget.onUpdate(_convertList());
    Navigator.pop(context);
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
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: tingkatKemampuan,
                  hint: const Text("Pilih tingkat kemampuan"),
                  isExpanded: true,
                  items: tingkatKemampuanList.map((value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => tingkatKemampuan = value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
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
                  return Card(
                    child: ListTile(
                      title: Text(item['bahasa']),
                      subtitle: Text(item['tingkat']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editKemampuanBahasa(item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteKemampuanBahasa(item['id']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
