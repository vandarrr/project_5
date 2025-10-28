import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class CVPage extends StatefulWidget {
  final String? cvPath;

  const CVPage({Key? key, this.cvPath}) : super(key: key);

  @override
  State<CVPage> createState() => _CVPageState();
}

class _CVPageState extends State<CVPage> {
  String? selectedCV;

  @override
  void initState() {
    super.initState();
    selectedCV = widget.cvPath;
  }

  Future<void> _pilihCV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedCV = result.files.single.name;
      });
    }
  }

  void _hapusCV() {
    setState(() {
      selectedCV = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Unggah Curriculum Vitae (CV)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (selectedCV != null)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text(selectedCV!),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: _hapusCV,
                  ),
                ),
              )
            else
              const Text(
                "Belum ada file CV diunggah.",
                style: TextStyle(color: Colors.grey),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pilihCV,
              icon: const Icon(Icons.upload_file),
              label: const Text("Pilih File CV"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
