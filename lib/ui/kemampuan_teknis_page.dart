import 'package:flutter/material.dart';

class KemampuanTeknisPage extends StatefulWidget {
  final List<String> kemampuanSebelumnya;

  const KemampuanTeknisPage({Key? key, required this.kemampuanSebelumnya})
    : super(key: key);

  @override
  State<KemampuanTeknisPage> createState() => _KemampuanTeknisPageState();
}

class _KemampuanTeknisPageState extends State<KemampuanTeknisPage> {
  late List<String> kemampuanList;

  @override
  void initState() {
    super.initState();
    kemampuanList = List<String>.from(widget.kemampuanSebelumnya);
  }

  void _tambahKemampuan() {
    TextEditingController kemampuanCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Kemampuan Teknis"),
        content: TextField(
          controller: kemampuanCtrl,
          decoration: const InputDecoration(labelText: "Masukkan kemampuan"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (kemampuanCtrl.text.isNotEmpty) {
                setState(() {
                  kemampuanList.add(kemampuanCtrl.text);
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

  void _hapusKemampuan(int index) {
    setState(() {
      kemampuanList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kemampuan Teknis"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.blue),
            onPressed: () {
              Navigator.pop(context, {"kemampuan": kemampuanList});
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: kemampuanList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(kemampuanList[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _hapusKemampuan(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambahKemampuan,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
