import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UnggahDokumenPage extends StatefulWidget {
  final List<String> dokumenSebelumnya;

  const UnggahDokumenPage({Key? key, required this.dokumenSebelumnya})
    : super(key: key);

  @override
  State<UnggahDokumenPage> createState() => _UnggahDokumenPageState();
}

class _UnggahDokumenPageState extends State<UnggahDokumenPage> {
  late List<String> dokumenList;

  @override
  void initState() {
    super.initState();
    dokumenList = List<String>.from(widget.dokumenSebelumnya);
  }

  Future<void> _unggahDokumen() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        dokumenList.addAll(result.files.map((file) => file.name));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Dokumen berhasil diunggah")),
      );
    }
  }

  void _hapusDokumen(int index) {
    setState(() {
      dokumenList.removeAt(index);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Dokumen berhasil dihapus")));
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
          IconButton(
            icon: const Icon(Icons.check, color: Colors.blue),
            onPressed: () {
              Navigator.pop(context, {"dokumenList": dokumenList});
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: dokumenList.isEmpty
                  ? const Center(
                      child: Text(
                        "Belum ada dokumen yang diunggah",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: dokumenList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: const Icon(
                              Icons.insert_drive_file,
                              color: Colors.blue,
                            ),
                            title: Text(dokumenList[index]),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () => _hapusDokumen(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _unggahDokumen,
              icon: const Icon(Icons.upload_file),
              label: const Text("Unggah Dokumen"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
