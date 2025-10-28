import 'package:flutter/material.dart';

class EditDataDiriPage extends StatefulWidget {
  final String? nama;
  final String? email;
  final String? noHp;
  final String? gender;
  final String? tanggalLahir;
  final String? lokasi;

  const EditDataDiriPage({
    Key? key,
    this.nama,
    this.email,
    this.noHp,
    this.gender,
    this.tanggalLahir,
    this.lokasi,
  }) : super(key: key);

  @override
  State<EditDataDiriPage> createState() => _EditDataDiriPageState();
}

class _EditDataDiriPageState extends State<EditDataDiriPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController hpController;
  late TextEditingController tanggalLahirController;
  late TextEditingController lokasiController;
  String? jenisKelamin;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.nama ?? "");
    emailController = TextEditingController(text: widget.email ?? "");
    hpController = TextEditingController(text: widget.noHp ?? "");
    tanggalLahirController = TextEditingController(
      text: widget.tanggalLahir ?? "",
    );
    lokasiController = TextEditingController(text: widget.lokasi ?? "");
    jenisKelamin =
        (widget.gender == "Laki-laki" || widget.gender == "Perempuan")
        ? widget.gender
        : null;
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    hpController.dispose();
    tanggalLahirController.dispose();
    lokasiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Data Diri"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: hpController,
                decoration: const InputDecoration(
                  labelText: "No HP",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value:
                    (jenisKelamin == "Laki-laki" || jenisKelamin == "Perempuan")
                    ? jenisKelamin
                    : null,
                decoration: InputDecoration(
                  labelText: 'Jenis Kelamin',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Laki-laki",
                    child: Text("Laki-laki"),
                  ),
                  DropdownMenuItem(
                    value: "Perempuan",
                    child: Text("Perempuan"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    jenisKelamin = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: tanggalLahirController,
                decoration: const InputDecoration(
                  labelText: "Tanggal Lahir",
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      tanggalLahirController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: lokasiController,
                decoration: const InputDecoration(
                  labelText: "Lokasi",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'nama': namaController.text,
                    'email': emailController.text,
                    'noHp': hpController.text,
                    'gender': jenisKelamin,
                    'tanggalLahir': tanggalLahirController.text,
                    'lokasi': lokasiController.text,
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Simpan Perubahan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
