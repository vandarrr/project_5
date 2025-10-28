import 'package:flutter/material.dart';

class PengalamanKerjaPage extends StatefulWidget {
  final List<Map<String, String>>? pengalamanSebelumnya;

  const PengalamanKerjaPage({Key? key, this.pengalamanSebelumnya})
    : super(key: key);

  @override
  State<PengalamanKerjaPage> createState() => _PengalamanKerjaPageState();
}

class _PengalamanKerjaPageState extends State<PengalamanKerjaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaPerusahaanController =
      TextEditingController();
  final TextEditingController posisiController = TextEditingController();
  final TextEditingController tahunController = TextEditingController();

  List<Map<String, String>> pengalamanList = [];

  @override
  void initState() {
    super.initState();
    pengalamanList = widget.pengalamanSebelumnya ?? [];
  }

  void _tambahPengalaman() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        pengalamanList.add({
          'perusahaan': namaPerusahaanController.text,
          'posisi': posisiController.text,
          'tahun': tahunController.text,
        });
        namaPerusahaanController.clear();
        posisiController.clear();
        tahunController.clear();
      });
    }
  }

  void _hapusPengalaman(int index) {
    setState(() {
      pengalamanList.removeAt(index);
    });
  }

  @override
  void dispose() {
    namaPerusahaanController.dispose();
    posisiController.dispose();
    tahunController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengalaman Kerja"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: namaPerusahaanController,
                    decoration: InputDecoration(
                      labelText: "Nama Perusahaan",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Nama perusahaan wajib diisi";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: posisiController,
                    decoration: InputDecoration(
                      labelText: "Posisi / Jabatan",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Posisi wajib diisi";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: tahunController,
                    decoration: InputDecoration(
                      labelText: "Tahun (contoh: 2021 - 2024)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Tahun wajib diisi";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _tambahPengalaman,
                      icon: const Icon(Icons.add),
                      label: const Text("Tambah Pengalaman"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: pengalamanList.isEmpty
                  ? const Center(
                      child: Text(
                        "Belum ada pengalaman kerja yang ditambahkan.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: pengalamanList.length,
                      itemBuilder: (context, index) {
                        final pengalaman = pengalamanList[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(
                              pengalaman['perusahaan'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "${pengalaman['posisi'] ?? ''}\n${pengalaman['tahun'] ?? ''}",
                            ),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _hapusPengalaman(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(context, {'pengalaman': pengalamanList});
                },
                child: const Text("Simpan Semua Pengalaman"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
