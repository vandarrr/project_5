import 'package:flutter/material.dart';
import 'video_detail_page.dart';

class TipsCareerTab extends StatelessWidget {
  final String searchQuery; //⬅ tambahan
  const TipsCareerTab({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> videos = [
      {
        'title': 'Cara Membuat CV yang Menarik di Mata HRD',
        'thumbnail': 'assets/cv.png',
        'views': '32.1K',
        'episodes': '1',
        'duration': '11m 23s',
        'videoUrl': 'assets/videos/cv.mp4',
        'level': 'Pemula',
      },
      {
        'title': 'Tips Lolos Interview Pertama Kali',
        'thumbnail': 'assets/interview.png',
        'views': '28.3K',
        'episodes': '1',
        'duration': '16m 46s',
        'videoUrl': 'assets/videos/interview.mp4',
        'level': 'Menengah',
      },
      {
        'title': 'Etika Profesional di Dunia Kerja',
        'thumbnail': 'assets/etika.png',
        'views': '19.8K',
        'episodes': '1',
        'duration': '5m 41s',
        'videoUrl': 'assets/videos/etika.mp4',
        'level': 'Profesional',
      },
      {
        'title': 'Cara Menulis Surat Lamaran Kerja',
        'thumbnail': 'assets/surat.png',
        'views': '14.2K',
        'episodes': '1',
        'duration': '3m 15s',
        'videoUrl': 'assets/videos/surat.mp4',
        'level': 'Pemula',
      },
      {
        'title': 'Cara Menghadapi HR Saat Negosiasi Gaji',
        'thumbnail': 'assets/nego.png',
        'views': '26.7K',
        'episodes': '1',
        'duration': '5m 33s',
        'videoUrl': 'assets/videos/nego.mp4',
        'level': 'Menengah',
      },
    ];

    // ⬇ FILTER
    final filtered = videos.where((v) {
      return v['title']!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final video = filtered[index];
        final originalIndex = videos.indexOf(video);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VideoDetailPage(
                  video: video,
                  allVideos: videos,
                  currentIndex: originalIndex,
                  sourceTab: "Tips Career",
                ),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    video['thumbnail']!,
                    fit: BoxFit.cover,
                    height: 180,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video['title']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${video['views']} views • ${video['episodes']} episodes • Level: ${video['level']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Learning 🎓',
                        style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
