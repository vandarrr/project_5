import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/lamaran_provider.dart';
import '../model/lamaran.dart';
import 'beranda.dart';

class PertanyaanRekruter extends StatefulWidget {
  final String posisi;
  final String perusahaan;
  final String lokasi;

  const PertanyaanRekruter({
    Key? key,
    required this.posisi,
    required this.perusahaan,
    required this.lokasi,
  }) : super(key: key);

  @override
  State<PertanyaanRekruter> createState() => _PertanyaanRekruterState();
}

class _PertanyaanRekruterState extends State<PertanyaanRekruter> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<String> _pertanyaan = [
    "Apakah Anda bersedia ditempatkan di luar kota?",
    "Apakah Anda dapat bekerja secara tim maupun individu?",
    "Apakah Anda memiliki pengalaman kerja di bidang yang dilamar?",
    "Apakah Anda bersedia bekerja lembur jika dibutuhkan?",
    "Apakah Anda sedang bekerja di perusahaan lain saat ini?",
  ];

  final Map<int, String> _jawaban = {};

  void _nextQuestion() {
    if (_index < _pertanyaan.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _index++);
    } else {
      final lamaranBaru = Lamaran(
        posisi: widget.posisi,
        perusahaan: widget.perusahaan,
        lokasi: widget.lokasi,
        tanggal: DateTime.now(),
      );

      Provider.of<LamaranProvider>(
        context,
        listen: false,
      ).tambahLamaran(lamaranBaru);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Terima kasih! Jawaban Anda telah disimpan."),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Beranda()),
          (Route<dynamic> route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _pertanyaan.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        title: const Text(
          "Pertanyaan Rekruter",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 2,
      ),
      body: PageView.builder(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: total,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Progress bar kecil di atas
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (i + 1) / total,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 24),

                // 🔹 Header pertanyaan
                Text(
                  "Pertanyaan ${i + 1} dari $total",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 16),

                // 🔹 Isi pertanyaan
                Text(
                  _pertanyaan[i],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // 🔹 Pilihan jawaban
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text("Ya", style: TextStyle(fontSize: 16)),
                        value: "Ya",
                        activeColor: Colors.blueAccent,
                        groupValue: _jawaban[i],
                        onChanged: (value) {
                          setState(() => _jawaban[i] = value!);
                        },
                      ),
                      const Divider(height: 0),
                      RadioListTile<String>(
                        title: const Text(
                          "Tidak",
                          style: TextStyle(fontSize: 16),
                        ),
                        value: "Tidak",
                        activeColor: Colors.redAccent,
                        groupValue: _jawaban[i],
                        onChanged: (value) {
                          setState(() => _jawaban[i] = value!);
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // 🔹 Tombol Selanjutnya / Selesai
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _jawaban[i] != null ? _nextQuestion : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _jawaban[i] != null
                          ? Colors.blueAccent
                          : Colors.grey.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      i == total - 1 ? "Selesai" : "Selanjutnya",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
