import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';

class PengalamanKerjaPage extends StatefulWidget {
  final List<Map<String, String>>? pengalamanSebelumnya;
  final Function(List<Map<String, String>>)? onUpdate;

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

  int? selectedPengalamanId;

  @override
  void initState() {
    super.initState();
    _loadPengalaman();
  }

  Future<void> _loadPengalaman() async {
    final data = await dbHelper.getAllPengalaman();
    setState(() => pengalamanList = data);
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

  // Insert atau Update
  Future<void> _tambahAtauUpdatePengalaman() async {
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

      if (selectedPengalamanId == null) {
        await dbHelper.insertPengalaman(data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pengalaman kerja ditambahkan")),
        );
      } else {
        await dbHelper.updatePengalaman(selectedPengalamanId!, data);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Perubahan disimpan")));
      }

      await _loadPengalaman();
      _callbackToProfil();
      _clearForm();
    }
  }

  Future<void> _hapusPengalaman(int id) async {
    await dbHelper.deletePengalaman(id);
    await _loadPengalaman();
    _callbackToProfil();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Pengalaman kerja dihapus")));

    if (selectedPengalamanId == id) _clearForm();
  }

  void _callbackToProfil() {
    if (widget.onUpdate != null) {
      widget.onUpdate!(
        pengalamanList
            .map((e) => e.map((k, v) => MapEntry(k, v.toString())))
            .toList(),
      );
    }
  }

  // ============================
  //        FUNGSI EDIT
  // ============================
  void _editPengalaman(Map<String, dynamic> data) {
    setState(() {
      posisiController.text = data['posisi'] ?? '';
      perusahaanController.text = data['perusahaan'] ?? '';
      tanggalMasukController.text = data['tanggalMasuk'] ?? '';
      tanggalKeluarController.text = data['tanggalKeluar'] ?? '';
      gajiController.text = data['gaji'] ?? '';
      deskripsiController.text = data['deskripsi'] ?? '';
      masihBekerja = data['tanggalKeluar'] == 'Sekarang';
      selectedPengalamanId = data['id'] is int
          ? data['id']
          : int.tryParse(data['id'].toString());
    });
  }

  void _clearForm() {
    posisiController.clear();
    perusahaanController.clear();
    tanggalMasukController.clear();
    tanggalKeluarController.clear();
    gajiController.clear();
    deskripsiController.clear();

    setState(() {
      masihBekerja = false;
      selectedPengalamanId = null;
    });
  }

  void _simpanSemua() {
    _callbackToProfil();
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
    final isEditing = selectedPengalamanId != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Pengalaman Kerja',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.3,
        actions: [
          TextButton(
            onPressed: _clearForm,
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
            // ========= FORM =========
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _judul("Posisi"),
                  TextFormField(
                    controller: posisiController,
                    decoration: _inputDecoration("Masukkan posisi kerja"),
                    validator: (v) => v!.isEmpty ? "Posisi wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),

                  _judul("Nama Perusahaan"),
                  TextFormField(
                    controller: perusahaanController,
                    decoration: _inputDecoration("Nama Perusahaan"),
                    validator: (v) =>
                        v!.isEmpty ? "Nama perusahaan wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Checkbox(
                        value: masihBekerja,
                        onChanged: (val) => setState(() => masihBekerja = val!),
                      ),
                      const Text("Masih bekerja disini"),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: tanggalMasukController,
                          readOnly: true,
                          onTap: () =>
                              _pilihTanggal(tanggalMasukController, "Masuk"),
                          decoration: _inputDecoration(
                            "Tanggal Masuk",
                            icon: Icons.calendar_today,
                          ),
                          validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
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
                            "Tanggal Keluar",
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
                    decoration: _inputDecoration("Masukkan gaji (opsional)"),
                  ),

                  const SizedBox(height: 16),

                  _judul("Deskripsi Pekerjaan"),
                  TextFormField(
                    controller: deskripsiController,
                    maxLines: 3,
                    decoration: _inputDecoration("Deskripsi pekerjaan"),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _tambahAtauUpdatePengalaman,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        isEditing ? "Simpan Perubahan" : "Tambah Pengalaman",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
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
                ? const Text(
                    "Belum ada pengalaman kerja.",
                    style: TextStyle(color: Colors.grey),
                  )
                : Column(
                    children: pengalamanList.map((p) {
                      final id = int.tryParse(p['id'].toString());

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p['posisi'] ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(p['perusahaan'] ?? ''),
                              Text(
                                "${p['tanggalMasuk']} - ${p['tanggalKeluar']}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              if ((p['gaji'] ?? "").toString().isNotEmpty)
                                Text("Gaji: ${p['gaji']}"),
                              if ((p['deskripsi'] ?? "").toString().isNotEmpty)
                                Text("Deskripsi: ${p['deskripsi']}"),

                              const SizedBox(height: 8),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // EDIT
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => _editPengalaman(p),
                                  ),

                                  // DELETE
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: id != null
                                        ? () => _hapusPengalaman(id)
                                        : null,
                                  ),
                                ],
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
                  "Simpan Semua",
                  style: TextStyle(color: Colors.white, fontSize: 16),
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
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 1.3),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
