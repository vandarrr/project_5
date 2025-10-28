import 'package:flutter/material.dart';
import 'edit_data_diri_page.dart';
import 'posisi_diinginkan_page.dart';
import 'kota_diinginkan_page.dart';
import 'pengalaman_kerja_page.dart';
import 'riwayat_pendidikan_page.dart';
import 'kemampuan_teknis_page.dart';
import 'kemampuan_bahasa_page.dart';
import 'cv_page.dart';
import 'unggah_dokumen_page.dart';
import 'ganti_password_page.dart'; // ✅ Tambahan import baru

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  // ===================== DATA PROFIL =====================
  String nama = "Rizky Maulana Dzuhry";
  String email = "rizkymd82@gmail.com";
  String noHp = "081234567890";
  String gender = "Laki-laki";
  String tanggalLahir = "12 Juni 2002";
  String lokasi = "Jakarta";
  String posisi = "Belum diatur";
  String kota = "Belum diatur";
  String userId = "#187357";

  String? cvPath;
  List<String> dokumenList = []; // ✅ Tambahan untuk dokumen

  List<Map<String, String>> pengalamanKerja = [];
  List<Map<String, String>> riwayatPendidikan = [];
  List<String> kemampuanTeknis = [];
  List<Map<String, String>> kemampuanBahasa = [];

  // ===================== UPDATE DATA =====================
  void _updateData(Map<String, dynamic> newData) {
    setState(() {
      nama = newData['nama'] ?? nama;
      email = newData['email'] ?? email;
      noHp = newData['noHp'] ?? noHp;
      gender = newData['gender'] ?? gender;
      tanggalLahir = newData['tanggalLahir'] ?? tanggalLahir;
      lokasi = newData['lokasi'] ?? lokasi;
    });
  }

  void _updatePosisi(String newPosisi) => setState(() => posisi = newPosisi);
  void _updateKota(String newKota) => setState(() => kota = newKota);
  void _updatePengalaman(List<Map<String, String>> newList) =>
      setState(() => pengalamanKerja = newList);
  void _updatePendidikan(List<Map<String, String>> newList) =>
      setState(() => riwayatPendidikan = newList);
  void _updateKemampuanTeknis(List<String> newList) =>
      setState(() => kemampuanTeknis = newList);
  void _updateKemampuanBahasa(List<Map<String, String>> newList) =>
      setState(() => kemampuanBahasa = newList);
  void _updateCV(String? newCV) => setState(() => cvPath = newCV);
  void _updateDokumen(List<String> newList) =>
      setState(() => dokumenList = newList);

  // ===================== BUILD CARD MENU =====================
  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isEdit = false,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[800]),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        trailing: Icon(
          isEdit ? Icons.edit : Icons.add,
          color: Colors.blue[700],
        ),
        onTap: onTap,
      ),
    );
  }

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Profil Saya"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // FOTO PROFIL
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue[100],
                  backgroundImage: const AssetImage('assets/profile.png'),
                ),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 14,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              nama,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(userId, style: const TextStyle(color: Colors.blue)),
            const SizedBox(height: 16),

            // ===================== DATA DIRI =====================
            _buildDataDiriCard(context),
            const SizedBox(height: 16),

            // ===================== POSISI & KOTA =====================
            _buildCard(
              icon: Icons.work_outline,
              title: "Posisi Diinginkan",
              subtitle: posisi,
              isEdit: true,
              onTap: () async {
                final updatedData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PosisiDiinginkanPage(),
                  ),
                );
                if (updatedData != null && updatedData['posisi'] != null) {
                  _updatePosisi(updatedData['posisi']);
                }
              },
            ),
            _buildCard(
              icon: Icons.location_city_outlined,
              title: "Kota Diinginkan",
              subtitle: kota,
              isEdit: true,
              onTap: () async {
                final updatedData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const KotaDiinginkanPage(),
                  ),
                );
                if (updatedData != null && updatedData['kota'] != null) {
                  _updateKota(updatedData['kota']);
                }
              },
            ),

            const SizedBox(height: 16),

            // ===================== PENGALAMAN KERJA =====================
            _buildPengalamanCard(context),
            const SizedBox(height: 16),

            // ===================== RIWAYAT PENDIDIKAN =====================
            _buildPendidikanCard(context),
            const SizedBox(height: 16),

            // ===================== KEMAMPUAN TEKNIS =====================
            _buildCard(
              icon: Icons.engineering_outlined,
              title: "Kemampuan Teknis",
              subtitle: kemampuanTeknis.isEmpty
                  ? "Belum ditambahkan"
                  : kemampuanTeknis.join(", "),
              isEdit: true,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KemampuanTeknisPage(
                      kemampuanSebelumnya: kemampuanTeknis,
                    ),
                  ),
                );
                if (result != null && result['kemampuan'] != null) {
                  _updateKemampuanTeknis(
                    List<String>.from(result['kemampuan']),
                  );
                }
              },
            ),

            // ===================== KEMAMPUAN BAHASA =====================
            _buildCard(
              icon: Icons.language_outlined,
              title: "Kemampuan Bahasa",
              subtitle: kemampuanBahasa.isEmpty
                  ? "Belum ditambahkan"
                  : kemampuanBahasa
                        .map((b) => "${b['bahasa']} (${b['tingkat']})")
                        .join(", "),
              isEdit: true,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        KemampuanBahasaPage(bahasaSebelumnya: kemampuanBahasa),
                  ),
                );
                if (result != null && result['bahasa'] != null) {
                  _updateKemampuanBahasa(
                    List<Map<String, String>>.from(result['bahasa']),
                  );
                }
              },
            ),

            const SizedBox(height: 16),

            // ===================== CURRICULUM VITAE (CV) =====================
            _buildCard(
              icon: Icons.attach_file_outlined,
              title: "Curriculum Vitae (CV)",
              subtitle: cvPath ?? "Belum diunggah",
              isEdit: true,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CVPage(cvPath: cvPath),
                  ),
                );
                if (result != null && result['cv'] != null) {
                  _updateCV(result['cv']);
                }
              },
            ),

            // ===================== UNGGAH DOKUMEN =====================
            ListTile(
              leading: const Icon(Icons.folder_open, color: Colors.blue),
              title: const Text("Unggah Dokumen"),
              subtitle: Text(
                dokumenList.isEmpty
                    ? "Belum ada dokumen diunggah"
                    : "${dokumenList.length} dokumen diunggah",
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UnggahDokumenPage(dokumenSebelumnya: dokumenList),
                  ),
                );
                if (result != null && result['dokumenList'] != null) {
                  _updateDokumen(List<String>.from(result['dokumenList']));
                }
              },
            ),

            // ===================== GANTI PASSWORD =====================
            ListTile(
              leading: const Icon(Icons.lock_outline, color: Colors.blue),
              title: const Text("Ganti Password"),
              subtitle: const Text("********"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GantiPasswordPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 8),
            const Text("Versi: 1.3.4", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            _buildLogoutButton(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // ===================== WIDGET PEMBANTU =====================
  Widget _buildDataDiriCard(BuildContext context) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Data Diri",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Divider(),
          _buildInfoRow("Nama", nama),
          _buildInfoRow("Email", email),
          _buildInfoRow("No HP", noHp),
          _buildInfoRow("Jenis Kelamin", gender),
          _buildInfoRow("Tanggal Lahir", tanggalLahir),
          _buildInfoRow("Lokasi", lokasi),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit, size: 16),
              label: const Text("Edit"),
              onPressed: () async {
                final updatedData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditDataDiriPage(
                      nama: nama,
                      email: email,
                      noHp: noHp,
                      gender: gender,
                      tanggalLahir: tanggalLahir,
                      lokasi: lokasi,
                    ),
                  ),
                );
                if (updatedData != null &&
                    updatedData is Map<String, dynamic>) {
                  _updateData(updatedData);
                }
              },
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildPengalamanCard(BuildContext context) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    child: ListTile(
      leading: const Icon(Icons.business_center_outlined, color: Colors.blue),
      title: const Text("Pengalaman Kerja"),
      subtitle: pengalamanKerja.isEmpty
          ? const Text("Belum ada pengalaman kerja")
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: pengalamanKerja
                  .map(
                    (p) => Text(
                      "${p['perusahaan']} - ${p['posisi']} (${p['tahun']})",
                    ),
                  )
                  .toList(),
            ),
      trailing: const Icon(Icons.edit, color: Colors.blue),
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PengalamanKerjaPage(pengalamanSebelumnya: pengalamanKerja),
          ),
        );
        if (result != null && result['pengalaman'] != null) {
          _updatePengalaman(
            List<Map<String, String>>.from(result['pengalaman']),
          );
        }
      },
    ),
  );

  Widget _buildPendidikanCard(BuildContext context) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 2,
    child: ListTile(
      leading: const Icon(Icons.school_outlined, color: Colors.blue),
      title: const Text("Riwayat Pendidikan"),
      subtitle: riwayatPendidikan.isEmpty
          ? const Text("Belum ada riwayat pendidikan")
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: riwayatPendidikan
                  .map(
                    (p) => Text(
                      "${p['institusi']} - ${p['jurusan']} (${p['tahun']})",
                    ),
                  )
                  .toList(),
            ),
      trailing: const Icon(Icons.edit, color: Colors.blue),
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RiwayatPendidikanPage(pendidikanSebelumnya: riwayatPendidikan),
          ),
        );
        if (result != null && result['pendidikan'] != null) {
          _updatePendidikan(
            List<Map<String, String>>.from(result['pendidikan']),
          );
        }
      },
    ),
  );

  Widget _buildInfoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    ),
  );

  Widget _buildLogoutButton(BuildContext context) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () => ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Berhasil keluar'))),
      child: const Text("Keluar", style: TextStyle(color: Colors.white)),
    ),
  );

  BottomNavigationBar _buildBottomNav(BuildContext context) =>
      BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: "Lowongan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            label: "Riwayat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_2_outlined),
            label: "Walk In",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profil",
          ),
        ],
        onTap: (index) {
          if (index != 3) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Navigasi belum diatur")),
            );
          }
        },
      );
}
