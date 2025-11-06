import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../database/database_helper.dart';

class CVPage extends StatefulWidget {
  final String? cvPath;

  const CVPage({Key? key, this.cvPath}) : super(key: key);

  @override
  State<CVPage> createState() => _CVPageState();
}

class _CVPageState extends State<CVPage> {
  final dbHelper = DatabaseHelper.instance;
  String? selectedCV;

  @override
  void initState() {
    super.initState();
    selectedCV = widget.cvPath;
    _loadCVFromDB();
  }

  // 🔹 Muat CV terakhir dari database
  Future<void> _loadCVFromDB() async {
    final cvList = await dbHelper.getAllCV();
    if (cvList.isNotEmpty) {
      setState(() {
        selectedCV = cvList.last['path'];
      });
    }
  }

  // 🔹 Pilih file CV lalu simpan ke database
  Future<void> _pilihCV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      final fileName = result.files.single.name;
      setState(() => selectedCV = fileName);

      await dbHelper.insertCV({'path': fileName});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("CV berhasil diunggah")));
    }
  }

  // 🔹 Hapus CV dari database
  Future<void> _hapusCV() async {
    final cvList = await dbHelper.getAllCV();
    if (cvList.isNotEmpty) {
      final lastId = cvList.last['id'] as int;
      await dbHelper.deleteCV(lastId);
    }

    setState(() => selectedCV = null);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("CV berhasil dihapus")));
  }

  // 🔹 Tampilan elegan
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Curriculum Vitae"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.blue),
            onPressed: () {
              Navigator.pop(context, {"cv": selectedCV});
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Unggah Curriculum Vitae (CV)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Pastikan file CV Anda berformat PDF, DOC, atau DOCX.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // ======== TAMPILAN FILE ========
            if (selectedCV != null)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.picture_as_pdf,
                    color: Colors.redAccent,
                    size: 32,
                  ),
                  title: Text(
                    selectedCV!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: const Text("File tersimpan di database lokal"),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    onPressed: _hapusCV,
                  ),
                ),
              )
            else
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Center(
                  child: Text(
                    "Belum ada CV diunggah.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // ======== TOMBOL UPLOAD ========
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _pilihCV,
                icon: const Icon(Icons.upload_file_rounded),
                label: const Text("Unggah CV"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
