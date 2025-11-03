import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';

class PengalamanKerjaPage extends StatefulWidget {
  final List<Map<String, String>>? pengalamanSebelumnya;
  final Function(List<Map<String, String>>)?
  onUpdate; // ✅ Callback untuk ProfilPage

  const PengalamanKerjaPage({
    Key? key,
    this.pengalamanSebelumnya,
    this.onUpdate,
  }) : super(key: key);

  @override
  State<PengalamanKerjaPage> createState() => _PengalamanKerjaPageState();
}

class _PengalamanKerjaPageState extends State<PengalamanKerjaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController posisiController = TextEditingController();
  final TextEditingController perusahaanController = TextEditingController();
  final TextEditingController tanggalMasukController = TextEditingController();
  final TextEditingController tanggalKeluarController = TextEditingController();
  final TextEditingController gajiController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  bool masihBekerja = false;
  List<Map<String, dynamic>> pengalamanList = [];
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadPengalaman();
  }

  Future<void> _loadPengalaman() async {
    final data = await dbHelper.getAllPengalaman();
    setState(() {
      pengalamanList = data;
    });
  }

  Future<void> _pilihTanggal(
    TextEditingController controller,
    String label,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  Future<void> _tambahPengalaman() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'perusahaan': perusahaanController.text,
        'posisi': posisiController.text,
        'tanggalMasuk': tanggalMasukController.text,
        'tanggalKeluar': masihBekerja
            ? 'Sekarang'
            : tanggalKeluarController.text,
        'gaji': gajiController.text,
        'deskripsi': deskripsiController.text,
      };

      await dbHelper.insertPengalaman(data);
      await _loadPengalaman();

      // ✅ Panggil callback agar ProfilPage langsung update
      if (widget.onUpdate != null) {
        widget.onUpdate!(
          pengalamanList
              .map((e) => e.map((k, v) => MapEntry(k, v.toString())))
              .toList(),
        );
      }

      posisiController.clear();
      perusahaanController.clear();
      tanggalMasukController.clear();
      tanggalKeluarController.clear();
      gajiController.clear();
      deskripsiController.clear();
      setState(() {
        masihBekerja = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pengalaman kerja berhasil ditambahkan")),
      );
    }
  }

  Future<void> _hapusPengalaman(int id) async {
    await dbHelper.deletePengalaman(id);
    await _loadPengalaman();

    if (widget.onUpdate != null) {
      widget.onUpdate!(
        pengalamanList
            .map((e) => e.map((k, v) => MapEntry(k, v.toString())))
            .toList(),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pengalaman kerja berhasil dihapus")),
    );
  }

  void _simpanSemua() {
    if (widget.onUpdate != null) {
      widget.onUpdate!(
        pengalamanList
            .map((e) => e.map((k, v) => MapEntry(k, v.toString())))
            .toList(),
      );
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    posisiController.dispose();
    perusahaanController.dispose();
    tanggalMasukController.dispose();
    tanggalKeluarController.dispose();
    gajiController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        title: const Text(
          'Pengalaman Kerja',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        foregroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () {
              posisiController.clear();
              perusahaanController.clear();
              tanggalMasukController.clear();
              tanggalKeluarController.clear();
              gajiController.clear();
              deskripsiController.clear();
              setState(() => masihBekerja = false);
            },
            child: const Text(
              "Bersihkan",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _judul("Posisi"),
                  TextFormField(
                    controller: posisiController,
                    decoration: _inputDecoration("Masukkan posisi kerja"),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Posisi wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),
                  _judul("Nama Perusahaan"),
                  TextFormField(
                    controller: perusahaanController,
                    decoration: _inputDecoration("Nama Perusahaan"),
                    validator: (v) => v == null || v.isEmpty
                        ? "Nama perusahaan wajib diisi"
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: masihBekerja,
                        onChanged: (val) =>
                            setState(() => masihBekerja = val ?? false),
                      ),
                      const Text("Masih bekerja disini"),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: tanggalMasukController,
                          readOnly: true,
                          onTap: () =>
                              _pilihTanggal(tanggalMasukController, "Masuk"),
                          decoration: _inputDecoration(
                            "Tanggal Masuk (dd/mm/yyyy)",
                            icon: Icons.calendar_today,
                          ),
                          validator: (v) => v == null || v.isEmpty
                              ? "Isi tanggal masuk"
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: tanggalKeluarController,
                          readOnly: true,
                          enabled: !masihBekerja,
                          onTap: masihBekerja
                              ? null
                              : () => _pilihTanggal(
                                  tanggalKeluarController,
                                  "Keluar",
                                ),
                          decoration: _inputDecoration(
                            "Tanggal Keluar (dd/mm/yyyy)",
                            icon: Icons.calendar_today,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _judul("Gaji"),
                  TextFormField(
                    controller: gajiController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      "Masukkan nominal gaji (opsional)",
                    ),
                  ),
                  const SizedBox(height: 16),
                  _judul("Deskripsi Pekerjaan"),
                  TextFormField(
                    controller: deskripsiController,
                    maxLines: 3,
                    decoration: _inputDecoration(
                      "Masukkan deskripsi pekerjaan",
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _tambahPengalaman,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Tambah Pengalaman",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Daftar Pengalaman Kerja",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 10),
            pengalamanList.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada pengalaman kerja yang ditambahkan.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : Column(
                    children: pengalamanList.map((pengalaman) {
                      final id = pengalaman['id'] is int
                          ? pengalaman['id']
                          : int.tryParse(pengalaman['id'].toString());
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pengalaman['posisi'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                pengalaman['perusahaan'] ?? '',
                                style: const TextStyle(color: Colors.black87),
                              ),
                              Text(
                                "${pengalaman['tanggalMasuk'] ?? ''} - ${pengalaman['tanggalKeluar'] ?? ''}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              if (pengalaman['gaji'] != null &&
                                  pengalaman['gaji'].toString().isNotEmpty)
                                Text("Gaji: ${pengalaman['gaji']}"),
                              if (pengalaman['deskripsi'] != null &&
                                  pengalaman['deskripsi'].toString().isNotEmpty)
                                Text("Deskripsi: ${pengalaman['deskripsi']}"),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: id != null
                                      ? () => _hapusPengalaman(id)
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _simpanSemua,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Simpan Semua Pengalaman",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _judul(String text) =>
      Text(text, style: const TextStyle(fontWeight: FontWeight.w600));

  InputDecoration _inputDecoration(String hint, {IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: icon != null ? Icon(icon, size: 20) : null,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue, width: 1.3),
      ),
    );
  }
}
