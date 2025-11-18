import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoDetailPage extends StatefulWidget {
  final Map<String, String> video;
  final List<Map<String, String>> allVideos;
  final int currentIndex;
  final String sourceTab; // <-- DITAMBAHKAN

  const VideoDetailPage({
    required this.video,
    required this.allVideos,
    required this.currentIndex,
    required this.sourceTab, // <-- DITAMBAHKAN
    super.key,
  });

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _loadVideo(widget.video['videoUrl']!);
  }

  void _loadVideo(String path) {
    _controller = VideoPlayerController.asset(path);
    _controller.initialize().then((_) {
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: true,
          looping: false,
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E2F),

        // ========================== DIGANTI KE sourceTab ==========================
        title: Text(
          widget.sourceTab,
          style: const TextStyle(color: Colors.white),
        ),

        // ==========================================================================
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: _chewieController == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Chewie(controller: _chewieController!),
                  ),

                  // ======================= INSTRUKTUR ======================
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.person, size: 40),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Instruktur Video",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Microsoft Office Specialist Expert",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ======================= JUDUL & DESKRIPSI ======================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),

                        const Text(
                          "Pelajari materi ini secara menyeluruh lewat rangkaian video yang dikemas ringkas, jelas, "
                          "dan mudah dipahami. Siap meningkatkan skill kerjamu!",
                          style: TextStyle(fontSize: 15),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _infoItem(
                                Icons.bar_chart,
                                "Level",
                                video['level'] ?? "Basic",
                              ),
                              _infoItem(
                                Icons.visibility,
                                "Views",
                                video['views'] ?? "0",
                              ),
                              _infoItem(
                                Icons.timelapse,
                                "Durasi",
                                video['duration'] ?? "0m",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Wrap(
                          spacing: 8,
                          children: const [
                            Chip(label: Text("Learning")),
                            Chip(label: Text("Skill")),
                            Chip(label: Text("Productivity")),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // ======================= LIST EPISODE ======================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text(
                      "Episode Lainnya",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  ListView.builder(
                    itemCount: widget.allVideos.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = widget.allVideos[index];
                      final isCurrent = index == widget.currentIndex;

                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item['thumbnail']!,
                            width: 80,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          item['title']!,
                          style: TextStyle(
                            fontWeight: isCurrent
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isCurrent ? Colors.blue : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          "${item['duration']} • ${item['views']}",
                        ),
                        onTap: () {
                          if (!isCurrent) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VideoDetailPage(
                                  video: item,
                                  allVideos: widget.allVideos,
                                  currentIndex: index,
                                  sourceTab: widget.sourceTab, // <–– PENTING!!
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 22),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
