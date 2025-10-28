import 'package:flutter/material.dart';

class RiwayatPendidikanPage extends StatefulWidget {
  final List<Map<String, String>> pendidikanSebelumnya;

  const RiwayatPendidikanPage({Key? key, required this.pendidikanSebelumnya})
    : super(key: key);

  @override
  State<RiwayatPendidikanPage> createState() => _RiwayatPendidikanPageState();
}

class _RiwayatPendidikanPageState extends State<RiwayatPendidikanPage> {
  late List<Map<String, String>> pendidikanList;

  @override
  void initState() {
    super.initState();
    pendidikanList = List<Map<String, String>>.from(
      widget.pendidikanSebelumnya,
    );
  }

  void _tambahPendidikan() {
    TextEditingController institusiCtrl = TextEditingController();
    TextEditingController jurusanCtrl = TextEditingController();
    TextEditingController tahunCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Riwayat Pendidikan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: institusiCtrl,
              decoration: const InputDecoration(labelText: "Nama Institusi"),
            ),
            TextField(
              controller: jurusanCtrl,
              decoration: const InputDecoration(labelText: "Jurusan"),
            ),
            TextField(
              controller: tahunCtrl,
              decoration: const InputDecoration(
                labelText: "Tahun Masuk - Lulus",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (institusiCtrl.text.isNotEmpty &&
                  jurusanCtrl.text.isNotEmpty &&
                  tahunCtrl.text.isNotEmpty) {
                setState(() {
                  pendidikanList.add({
                    "institusi": institusiCtrl.text,
                    "jurusan": jurusanCtrl.text,
                    "tahun": tahunCtrl.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _hapusPendidikan(int index) {
    setState(() {
      pendidikanList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Pendidikan"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.blue),
            onPressed: () {
              Navigator.pop(context, {"pendidikan": pendidikanList});
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: pendidikanList.length,
        itemBuilder: (context, index) {
          final p = pendidikanList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(p['institusi'] ?? ""),
              subtitle: Text("${p['jurusan']} (${p['tahun']})"),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _hapusPendidikan(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahPendidikan,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
