import 'package:flutter/material.dart';
import 'video_detail_page.dart';

class SoftSkillsTab extends StatelessWidget {
  final String searchQuery; //⬅ tambahan
  const SoftSkillsTab({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> videos = [
      {
        'title': 'Cara Komunikasi yang Efektif',
        'thumbnail': 'assets/comunnication.png',
        'views': '41.2K',
        'episodes': '1',
        'duration': '4m 39s',
        'videoUrl': 'assets/videos/comunnication.mp4',
        'level': 'Pemula',
      },
      {
        'title': 'Critical Thinking untuk Dunia Kerja',
        'thumbnail': 'assets/thinking.png',
        'views': '22.7K',
        'episodes': '1',
        'duration': '13m 48s',
        'videoUrl': 'assets/videos/thinking.mp4',
        'level': 'Menengah',
      },
      {
        'title': 'Time Management Agar Lebih Produktif',
        'thumbnail': 'assets/time.png',
        'views': '17.9K',
        'episodes': '1',
        'duration': '7m 57s',
        'videoUrl': 'assets/videos/time.mp4',
        'level': 'Menengah',
      },
      {
        'title': 'Cara Bekerja Sama Dalam Tim',
        'thumbnail': 'assets/teamwork.png',
        'views': '20.5K',
        'episodes': '1',
        'duration': '15m 55s',
        'videoUrl': 'assets/videos/teamwork.mp4',
        'level': 'Pemula',
      },
      {
        'title': 'Public Speaking Tanpa Gugup',
        'thumbnail': 'assets/publicspeaking.png',
        'views': '33.4K',
        'episodes': '1',
        'duration': '13m 13s',
        'videoUrl': 'assets/videos/publicspeaking.mp4',
        'level': 'Menengah',
      },
    ];

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
                  sourceTab: "Soft Skills",
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
