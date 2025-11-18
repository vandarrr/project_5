import 'package:flutter/material.dart';
import 'video_detail_page.dart';

class SkillsTab extends StatelessWidget {
  final String searchQuery; // ⬅ Tambahan
  const SkillsTab({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> videos = [
      {
        'title': '25 Rumus Excel Paling Penting',
        'thumbnail': 'assets/excel1.png',
        'views': '54.9K',
        'episodes': '1',
        'duration': '41m 46s',
        'videoUrl': 'assets/videos/belajarexcel.mp4',
        'level': 'Intermediate',
      },
      {
        'title': 'Belajar Microsoft Word Dari Nol',
        'thumbnail': 'assets/word.png',
        'views': '23.4K',
        'episodes': '1',
        'duration': '21m 48s',
        'videoUrl': 'assets/videos/word.mp4',
        'level': 'Pemula',
      },
      {
        'title': 'Dasar Microsoft Office PowerPoint',
        'thumbnail': 'assets/powerpoint.png',
        'views': '18.2K',
        'episodes': '1',
        'duration': '15 51s',
        'videoUrl': 'assets/videos/powerpoint.mp4',
        'level': 'Pemula',
      },
      {
        'title': 'Kuasai Microsoft Teams untuk Kolaborasi dan Meeting',
        'thumbnail': 'assets/teams.png',
        'views': '31.6K',
        'episodes': '1',
        'duration': '15m 08s',
        'videoUrl': 'assets/videos/teams.mp4',
        'level': 'Pemula',
      },
      {
        'title': '10 Tips Google Sheets',
        'thumbnail': 'assets/sheets.png',
        'views': '27.8K',
        'episodes': '1',
        'duration': '17m 43s',
        'videoUrl': 'assets/videos/sheets.mp4',
        'level': 'Pemula',
      },
      {
        'title': 'Belajar Canva Dari Nol',
        'thumbnail': 'assets/canva.png',
        'views': '15.9K',
        'episodes': '1',
        'duration': '32m 07s',
        'videoUrl': 'assets/videos/canva.mp4',
        'level': 'Pemula',
      },
      {
        'title': 'Outlook dan Manajemen Email',
        'thumbnail': 'assets/outlook.png',
        'views': '12.4K',
        'episodes': '1',
        'duration': '9m 26s',
        'videoUrl': 'assets/videos/outlook.mp4',
        'level': 'Menengah',
      },
      {
        'title': 'Data Analysis dengan Excel',
        'thumbnail': 'assets/analyst.png',
        'views': '44.7K',
        'episodes': '1',
        'duration': '18m 37s',
        'videoUrl': 'assets/videos/analyst.mp4',
        'level': 'Menengah',
      },
      {
        'title': 'Automasi Tugas dengan Copilot',
        'thumbnail': 'assets/copilot.png',
        'views': '11.5K',
        'episodes': '1',
        'duration': '4m 49s',
        'videoUrl': 'assets/videos/copilot.mp4',
        'level': 'Pemula',
      },
      {
        'title': '15 Rumus Wajib Untuk Admin',
        'thumbnail': 'assets/admin.png',
        'views': '19.7K',
        'episodes': '1',
        'duration': '23m 58s',
        'videoUrl': 'assets/videos/admin.mp4',
        'level': 'Menengah',
      },
    ];

    // ⬇ FILTER VIDEO
    final filtered = videos.where((v) {
      final title = v['title']!.toLowerCase();
      return title.contains(searchQuery.toLowerCase());
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
                  sourceTab: "Skills",
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
