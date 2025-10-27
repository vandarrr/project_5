import 'package:flutter/material.dart';
import 'edit_data_diri_page.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  // 🔹 Data profil default
  String nama = "madinah ikhtiarti";
  String kode = "#52974";
  String email = "dinatoon06@gmail.com";
  String noHp = "08568205838";
  String gender = "Wanita";
  String tanggalLahir = "06/01/2002";
  String kota = "JAKARTA";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profil Saya',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Foto profil
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 🔹 Nama dan kode
            Text(
              nama,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(kode, style: const TextStyle(color: Colors.blue)),

            const SizedBox(height: 20),

            // 🔹 Kartu data diri
            _buildProfileCard(
              context,
              title: "Data Diri",
              icon: Icons.person_outline,
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(Icons.email_outlined, email),
                  _infoRow(Icons.phone, noHp),
                  _infoRow(Icons.female, gender),
                  _infoRow(Icons.calendar_today, tanggalLahir),
                  _infoRow(Icons.location_on_outlined, kota),
                ],
              ),
              onTapEdit: () async {
                // Buka halaman edit dan tunggu hasilnya
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditDataDiriPage(
                      email: email,
                      lokasi: kota,
                      tentang: "",
                    ),
                  ),
                );

                // Jika user menekan "Simpan" dan kembali
                if (result != null && mounted) {
                  setState(() {
                    nama = result['nama'] ?? nama;
                    email = result['email'] ?? email;
                    noHp = result['noHp'] ?? noHp;
                    gender = result['gender'] ?? gender;
                    tanggalLahir = result['tanggalLahir'] ?? tanggalLahir;
                    kota = result['lokasi'] ?? kota;
                  });
                }
              },
            ),

            _buildMenuItem(
              "Posisi Diinginkan",
              Icons.work_outline,
              children: [
                _buildTag("Admin Staff Hrd"),
                _buildTag("Administrasi"),
                _buildTag("Back Office"),
                _buildTag("Front Liners"),
                _buildTag("Staff Admin"),
                _buildTag("Teller"),
              ],
            ),

            _buildMenuItem("Kota Diinginkan", Icons.location_city),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Text("Keluar", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 8),
            const Text("Versi: 1.3.4", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget subtitle,
    required VoidCallback onTapEdit,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            ListTile(
              leading: Icon(icon, color: const Color(0xFF0A1D56)),
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onTapEdit,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16),
              child: subtitle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 18),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, {List<Widget>? children}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.add, color: Colors.blue),
              ],
            ),
            if (children != null) ...[
              const SizedBox(height: 8),
              Wrap(spacing: 6, runSpacing: 6, children: children),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.blue, fontSize: 13),
      ),
    );
  }
}
