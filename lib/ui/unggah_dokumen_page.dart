import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../database/database_helper.dart';

class UnggahDokumenPage extends StatefulWidget {
  final List<String> dokumenSebelumnya;

  const UnggahDokumenPage({Key? key, required this.dokumenSebelumnya})
    : super(key: key);

  @override
  State<UnggahDokumenPage> createState() => _UnggahDokumenPageState();
}

class _UnggahDokumenPageState extends State<UnggahDokumenPage> {
  final dbHelper = DatabaseHelper.instance;
  late List<String> dokumenList;
  String? selectedJenis;
  String? filePath;

  final List<String> jenisDokumenOptions = [
    'KTP',
    'Ijazah',
    'Sertifikat',
    'Transkrip Nilai',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    dokumenList = List<String>.from(widget.dokumenSebelumnya);
    _loadDokumenFromDatabase();
  }

  // 🔹 Ambil semua dokumen dari database
  Future<void> _loadDokumenFromDatabase() async {
    final data = await dbHelper.getAllDokumen();
    setState(() {
      dokumenList = data.map((e) => e['path'] as String).toList();
    });
  }

  // 🔹 Pilih file dari penyimpanan
  Future<void> _pilihFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        filePath = result.files.single.path;
      });
    }
  }

  // 🔹 Tambahkan dokumen baru ke database (tombol bawah)
  Future<void> _tambahDokumen() async {
    if (selectedJenis == null || filePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pilih jenis dokumen dan file terlebih dahulu"),
        ),
      );
      return;
    }

    await dbHelper.insertDokumen({'path': filePath!});
    await _loadDokumenFromDatabase();

    setState(() {
      selectedJenis = null;
      filePath = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Dokumen berhasil ditambahkan")),
    );
  }

  // 🔹 Simpan & kembali ke profil (tombol kanan atas)
  Future<void> _simpanDanKembali() async {
    Navigator.pop(context, {'dokumenList': dokumenList});
  }

  // 🔹 Hapus dokumen berdasarkan path
  Future<void> _hapusDokumen(int index) async {
    final path = dokumenList[index];
    await dbHelper.deleteDokumenByPath(path);
    await _loadDokumenFromDatabase();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Dokumen dihapus")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unggah Dokumen"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          // 🔹 Tombol Simpan di pojok kanan atas
          IconButton(
            icon: const Icon(Icons.save, color: Colors.blue),
            tooltip: "Simpan & kembali ke profil",
            onPressed: _simpanDanKembali,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dokumen Kandidat #187357",
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Dropdown Jenis Dokumen
            const Text(
              "Jenis dokumen",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedJenis,
                  hint: const Text("Pilih Jenis Dokumen"),
                  isExpanded: true,
                  onChanged: (val) => setState(() => selectedJenis = val),
                  items: jenisDokumenOptions
                      .map(
                        (jenis) =>
                            DropdownMenuItem(value: jenis, child: Text(jenis)),
                      )
                      .toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Dokumen",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),

            // 🔹 Tombol Pilih File
            GestureDetector(
              onTap: _pilihFile,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "Pilih File",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        filePath != null
                            ? filePath!.split('/').last
                            : "Tidak ada file yang dipilih",
                        style: const TextStyle(color: Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Tombol Tambah Dokumen (masih di halaman ini)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _tambahDokumen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Tambah Dokumen",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "Daftar Dokumen yang Telah Diupload",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            // 🔹 List Dokumen
            Expanded(
              child: dokumenList.isEmpty
                  ? const Center(
                      child: Text(
                        "Belum ada dokumen yang diunggah",
                        style: TextStyle(color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: dokumenList.length,
                      itemBuilder: (context, index) {
                        final namaFile = dokumenList[index].split('/').last;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(
                              namaFile,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _hapusDokumen(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
