import 'package:flutter/material.dart';

class EditDataDiriPage extends StatefulWidget {
  final String? email;
  final String? lokasi;
  final String? tentang;

  const EditDataDiriPage({Key? key, this.email, this.lokasi, this.tentang})
    : super(key: key);

  @override
  State<EditDataDiriPage> createState() => _EditDataDiriPageState();
}

class _EditDataDiriPageState extends State<EditDataDiriPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController ktpController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController hpController = TextEditingController();
  final TextEditingController kotaTinggalController = TextEditingController();
  final TextEditingController tentangSayaController = TextEditingController();

  String? jenisKelamin;
  String? pendidikan;
  String? cabangIMS;
  bool willingBackup = false;

  @override
  void initState() {
    super.initState();
    kotaTinggalController.text = widget.lokasi ?? "";
    tentangSayaController.text = widget.tentang ?? "";
  }

  @override
  void dispose() {
    namaController.dispose();
    ktpController.dispose();
    tempatLahirController.dispose();
    tanggalLahirController.dispose();
    hpController.dispose();
    kotaTinggalController.dispose();
    tentangSayaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Edit Data Diri',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _resetForm),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Data Profil: #187357",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),

              // 🔹 Nama
              _buildTextField(
                label: "Nama sesuai KTP (*)",
                controller: namaController,
                requiredField: true,
              ),

              // 🔹 No. KTP
              _buildTextField(
                label: "No. KTP (*)",
                controller: ktpController,
                requiredField: true,
                keyboardType: TextInputType.number,
              ),

              // 🔹 Tempat Lahir
              _buildDropdown(
                label: "Tempat Lahir (*)",
                value: tempatLahirController.text.isEmpty
                    ? null
                    : tempatLahirController.text,
                items: ["JAKARTA", "BANDUNG", "SURABAYA", "YOGYAKARTA"],
                onChanged: (val) {
                  setState(() {
                    tempatLahirController.text = val ?? "";
                  });
                },
              ),

              // 🔹 Tanggal Lahir
              _buildDateField("Tanggal Lahir (*)", tanggalLahirController),

              // 🔹 Jenis Kelamin
              _buildDropdown(
                label: "Jenis Kelamin (*)",
                value: jenisKelamin,
                items: ["Laki-laki", "Perempuan"],
                onChanged: (val) => setState(() => jenisKelamin = val),
              ),

              // 🔹 No HP
              _buildTextField(
                label: "No. HP (*)",
                controller: hpController,
                requiredField: true,
                keyboardType: TextInputType.phone,
              ),

              // 🔹 Pendidikan Terakhir
              _buildDropdown(
                label: "Pendidikan Terakhir (*)",
                value: pendidikan,
                items: ["SMA", "D3", "S1", "S2", "S3"],
                onChanged: (val) => setState(() => pendidikan = val),
              ),

              // 🔹 Kota Tinggal
              _buildDropdown(
                label: "Kota Tinggal",
                value: kotaTinggalController.text.isEmpty
                    ? null
                    : kotaTinggalController.text,
                items: ["JAKARTA", "BANDUNG", "SURABAYA", "YOGYAKARTA"],
                onChanged: (val) {
                  setState(() {
                    kotaTinggalController.text = val ?? "";
                  });
                },
              ),

              // 🔹 Cabang IMS
              _buildDropdown(
                label: "Cabang IMS Terdekat (*)",
                value: cabangIMS,
                items: ["JAKARTA", "BANDUNG", "SURABAYA", "YOGYAKARTA"],
                onChanged: (val) => setState(() => cabangIMS = val),
              ),

              const SizedBox(height: 12),
              const Text(
                "Tentang Saya",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: tentangSayaController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Ceritakan sedikit tentang dirimu...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              CheckboxListTile(
                value: willingBackup,
                onChanged: (val) {
                  setState(() => willingBackup = val ?? false);
                },
                title: const Text("Willing to backup"),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: 20),

              // 🔹 Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Simpan Perubahan",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔸 Fungsi untuk reset form
  void _resetForm() {
    _formKey.currentState?.reset();
    namaController.clear();
    ktpController.clear();
    tempatLahirController.clear();
    tanggalLahirController.clear();
    hpController.clear();
    kotaTinggalController.clear();
    tentangSayaController.clear();
    setState(() {
      jenisKelamin = null;
      pendidikan = null;
      cabangIMS = null;
      willingBackup = false;
    });
  }

  // 🔸 Fungsi untuk simpan data dan kembali ke ProfilPage
  void _saveData() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'nama': namaController.text,
        'email': widget.email ?? "rizkymd82@gmail.com",
        'noHp': hpController.text,
        'gender': jenisKelamin ?? "",
        'tanggalLahir': tanggalLahirController.text,
        'lokasi': kotaTinggalController.text,
      });
    }
  }

  // 🔹 Komponen Input
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool requiredField = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: requiredField
            ? (value) => value == null || value.isEmpty ? "Wajib diisi" : null
            : null,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        value: value,
        onChanged: onChanged,
        items: items
            .map(
              (item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)),
            )
            .toList(),
        validator: (val) =>
            (label.contains("*") && (val == null || val.isEmpty))
            ? "Wajib diisi"
            : null,
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime(2000),
            firstDate: DateTime(1960),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            controller.text = "${picked.day}/${picked.month}/${picked.year}";
          }
        },
        validator: (value) =>
            (label.contains("*") && (value == null || value.isEmpty))
            ? "Wajib diisi"
            : null,
      ),
    );
  }
}
