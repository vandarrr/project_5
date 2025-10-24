import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helpers/lamaran_provider.dart';
import '../helpers/saved_provider.dart'; // ✅ Tambahkan import ini
import '../model/lamaran.dart';

class LamaranPage extends StatefulWidget {
  final String selectedTab; // ✅ Parameter untuk tab default
  const LamaranPage({Key? key, this.selectedTab = "saved"}) : super(key: key);

  @override
  State<LamaranPage> createState() => _LamaranPageState();
}

class _LamaranPageState extends State<LamaranPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    // ✅ Set tab default berdasarkan parameter
    int initialIndex = widget.selectedTab == "applied" ? 1 : 0;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: initialIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lamaranList = Provider.of<LamaranProvider>(context).lamaranList;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1D56),
        iconTheme: const IconThemeData(
          color: Colors.white, // 🔥 Warna ikon back putih
        ),
        title: const Text(
          'My Activity',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3.0, // 🔥 Indikator lebih tebal & modern
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Saved'),
            Tab(text: 'Applied'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ✅ TAB: Saved
          _buildSavedTab(),

          // ✅ TAB: Applied (Lamaran yang sudah dikirim)
          lamaranList.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada lamaran yang dikirim.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: lamaranList.length,
                  itemBuilder: (context, index) {
                    final lamaran = lamaranList[index];
                    return _buildLamaranCard(lamaran);
                  },
                ),
        ],
      ),
    );
  }

  /// ✅ Tampilan tab "Saved"
  Widget _buildSavedTab() {
    final savedList = Provider.of<SavedProvider>(context).savedList;

    if (savedList.isEmpty) {
      return Center(
        child: Text(
          'Belum ada pekerjaan yang disimpan.',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: savedList.length,
      itemBuilder: (context, index) {
        final lamaran = savedList[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: ListTile(
            title: Text(
              lamaran.posisi,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A1D56),
              ),
            ),
            subtitle: Text(lamaran.perusahaan),
            trailing: const Icon(Icons.bookmark, color: Colors.pink),
          ),
        );
      },
    );
  }

  /// ✅ Kartu lamaran di tab "Applied"
  Widget _buildLamaranCard(Lamaran lamaran) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lamaran.posisi,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF0A1D56),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              lamaran.perusahaan,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              lamaran.lokasi,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Status: Dilamar",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${lamaran.tanggal.day}/${lamaran.tanggal.month}/${lamaran.tanggal.year}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
