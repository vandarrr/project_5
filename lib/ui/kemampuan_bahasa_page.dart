import 'package:flutter/material.dart';

class KemampuanBahasaPage extends StatefulWidget {
  final List<Map<String, String>> bahasaSebelumnya;

  const KemampuanBahasaPage({Key? key, required this.bahasaSebelumnya})
    : super(key: key);

  @override
  State<KemampuanBahasaPage> createState() => _KemampuanBahasaPageState();
}

class _KemampuanBahasaPageState extends State<KemampuanBahasaPage> {
  late List<Map<String, String>> bahasaList;

  @override
  void initState() {
    super.initState();
    bahasaList = List<Map<String, String>>.from(widget.bahasaSebelumnya);
  }

  void _tambahBahasa() {
    TextEditingController bahasaCtrl = TextEditingController();
    TextEditingController tingkatCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Kemampuan Bahasa"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: bahasaCtrl,
              decoration: const InputDecoration(labelText: "Bahasa"),
            ),
            TextField(
              controller: tingkatCtrl,
              decoration: const InputDecoration(
                labelText: "Tingkat (Misal: Fasih, Menengah)",
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
              if (bahasaCtrl.text.isNotEmpty && tingkatCtrl.text.isNotEmpty) {
                setState(() {
                  bahasaList.add({
                    "bahasa": bahasaCtrl.text,
                    "tingkat": tingkatCtrl.text,
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

  void _hapusBahasa(int index) {
    setState(() {
      bahasaList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kemampuan Bahasa"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.blue),
            onPressed: () {
              Navigator.pop(context, {"bahasa": bahasaList});
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: bahasaList.length,
        itemBuilder: (context, index) {
          final b = bahasaList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(b['bahasa'] ?? ""),
              subtitle: Text("Tingkat: ${b['tingkat']}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _hapusBahasa(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahBahasa,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
