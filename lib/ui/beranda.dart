import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../widget/sidebar.dart';
import '/ui/detail_pekerjaan.dart';

class Beranda extends StatelessWidget {
  const Beranda({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1D56),
        elevation: 0,
        title: const Text(
          'LokerIn',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              duration: const Duration(seconds: 2),
              child: const Text(
                'Good evening, Rizky 👋',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A1D56),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeInDown(
              duration: const Duration(seconds: 2),
              delay: const Duration(milliseconds: 300),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Start your job search',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFFFF5C8D),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xFFFF5C8D),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeInDown(
              duration: const Duration(seconds: 1),
              delay: const Duration(milliseconds: 600),
              child: Row(
                children: [
                  _buildCategoryChip('Recommended', true),
                  const SizedBox(width: 8),
                  _buildCategoryChip('All', false),
                  const SizedBox(width: 8),
                  Stack(
                    children: [
                      _buildCategoryChip('New to you', false),
                      Positioned(
                        right: 8,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF5C8D),
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '100',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Job Cards dengan GestureDetector
            ...List.generate(_jobs.length, (index) {
              final job = _jobs[index];
              return FadeInUp(
                duration: const Duration(seconds: 2),
                delay: Duration(milliseconds: 900 + (index * 300)),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPekerjaan(job: job),
                      ),
                    );
                  },
                  child: _buildJobCard(
                    logo: job['logo']!,
                    title: job['title']!,
                    company: job['company']!,
                    location: job['location']!,
                    time: job['time']!,
                  ),
                ),
              );
            }),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFFF5C8D) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : const Color(0xFF0A1D56),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildJobCard({
    required String logo,
    required String title,
    required String company,
    required String location,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(logo, height: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A1D56),
                      ),
                    ),
                    Text(
                      company,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.bookmark_border,
                  color: Color(0xFFFF5C8D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE3EC),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'New to you',
              style: TextStyle(fontSize: 12, color: Color(0xFFFF5C8D)),
            ),
          ),
          const SizedBox(height: 6),
          Text('Full time • $location', style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 8),
          Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

// 🔹 Daftar 10 pekerjaan (dengan deskripsi berbeda)
final List<Map<String, String>> _jobs = [
  {
    'logo': 'assets/trafindo.png',
    'title': 'Cybersecurity Specialist',
    'company': 'PT Trafoindo Prima Perkasa',
    'location': 'Central Jakarta, Jakarta',
    'time': '4d ago',
    'description': '''
- Melindungi sistem dan data perusahaan dari serangan siber.
- Melakukan audit keamanan jaringan dan aplikasi.
- Membuat kebijakan keamanan dan protokol mitigasi risiko.
- Bekerja sama dengan tim IT untuk memperkuat sistem keamanan internal.
''',
  },
  {
    'logo': 'assets/mdc.png',
    'title': 'Cloud Engineer',
    'company': 'Masa Depan Cerah',
    'location': 'West Jakarta, Jakarta',
    'time': '2d ago',
    'description': '''
- Membangun dan mengelola infrastruktur cloud (AWS, GCP, Azure).
- Mengotomatisasi proses deployment dengan CI/CD pipelines.
- Mengoptimalkan performa dan biaya server cloud.
- Menangani troubleshooting terkait jaringan cloud.
''',
  },
  {
    'logo': 'assets/gojek.png',
    'title': 'Mobile App Developer',
    'company': 'PT Aplikasi Karya Anak Bangsa',
    'location': 'Depok, Jawa Barat',
    'time': '1d ago',
    'description': '''
- Mengembangkan aplikasi Flutter untuk Android dan iOS.
- Berkolaborasi dengan UI/UX designer untuk implementasi desain.
- Melakukan testing dan debugging aplikasi.
- Menjaga performa dan kompatibilitas lintas platform.
''',
  },
  {
    'logo': 'assets/meta.png',
    'title': 'Software Engineer',
    'company': 'Meta Platforms Inc.',
    'location': 'Jakarta, Indonesia',
    'time': '3d ago',
    'description': '''
- Merancang dan mengembangkan sistem backend berskala besar.
- Meningkatkan performa dan efisiensi sistem.
- Mengembangkan API untuk aplikasi dan integrasi layanan eksternal.
- Menggunakan prinsip clean code dan review kode secara berkala.
''',
  },
  {
    'logo': 'assets/tokopedia.png',
    'title': 'Data Analyst',
    'company': 'Tokopedia',
    'location': 'Jakarta, Indonesia',
    'time': '5d ago',
    'description': '''
- Mengumpulkan dan menganalisis data untuk mendukung pengambilan keputusan bisnis.
- Membuat dashboard interaktif dengan Google Data Studio / Power BI.
- Melakukan visualisasi data dan interpretasi hasil analisis.
- Berkolaborasi dengan tim produk dan marketing.
''',
  },
  {
    'logo': 'assets/shopee.png',
    'title': 'Admin Officer',
    'company': 'Shopee Indonesia',
    'location': 'South Jakarta, Jakarta',
    'time': '6d ago',
    'description': '''
- Mengelola dokumen dan laporan administrasi kantor.
- Membantu proses input data harian dan arsip digital.
- Berkoordinasi dengan departemen lain untuk keperluan operasional.
- Menjaga kerapian dan efisiensi lingkungan kerja.
''',
  },
  {
    'logo': 'assets/grab.png',
    'title': 'Warehouse Staff',
    'company': 'PT Grab Teknologi Indonesia',
    'location': 'Jakarta, Indonesia',
    'time': '1w ago',
    'description': '''
- Mengelola penerimaan dan pengiriman barang di gudang.
- Melakukan pengecekan stok dan laporan inventori.
- Memastikan penyimpanan sesuai standar keamanan.
- Membantu tim logistik dalam proses distribusi.
''',
  },
  {
    'logo': 'assets/oriskin.png',
    'title': 'Customer Support',
    'company': 'Oriskin Indonesia',
    'location': 'Yogyakarta, Indonesia',
    'time': '3h ago',
    'description': '''
- Menangani pertanyaan dan keluhan pelanggan dengan sopan.
- Memberikan solusi cepat dan efektif untuk setiap masalah pelanggan.
- Melakukan follow-up untuk memastikan kepuasan pelanggan.
- Bekerja sama dengan tim produk untuk perbaikan layanan.
''',
  },
  {
    'logo': 'assets/dpi.png',
    'title': 'UI/UX Designer',
    'company': 'PT Dana Purna Investama',
    'location': 'Bandung, Indonesia',
    'time': '7h ago',
    'description': '''
- Mendesain antarmuka aplikasi yang intuitif dan menarik.
- Melakukan riset pengguna untuk meningkatkan pengalaman aplikasi.
- Membuat prototipe interaktif menggunakan Figma/Adobe XD.
- Berkolaborasi dengan tim developer untuk implementasi desain.
''',
  },
  {
    'logo': 'assets/dana.png',
    'title': 'Marketing Intern',
    'company': 'PT Espay Debit Indonesia Koe',
    'location': 'Jakarta, Indonesia',
    'time': '12h ago',
    'description': '''
- Membantu tim marketing dalam perencanaan kampanye digital.
- Mengelola media sosial dan membuat konten promosi.
- Menganalisis hasil kampanye dan membuat laporan.
- Mendukung event promosi dan aktivasi brand.
''',
  },
];
