import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoDetailPage extends StatefulWidget {
  final Map<String, String> video;

  const VideoDetailPage({required this.video, super.key});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    final videoPath = widget.video['videoUrl'];
    if (videoPath != null && videoPath.isNotEmpty) {
      _controller = VideoPlayerController.asset(videoPath);
      _controller.initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _controller,
            autoPlay: true,
            looping: false,
          );
        });
      });
    } else {
      debugPrint("⚠️ videoUrl tidak ditemukan di data video!");
    }
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E2F),
        title: Text(video['title'] ?? 'Video Detail'),
      ),
      body: _chewieController != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Chewie(controller: _chewieController!),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${video['views']} views • ${video['episodes']} episodes • Level: ${video['level']}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Dapatkan sertifikat dengan menonton seluruh video dalam seri ini tanpa terlewat!',
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          children: const [
                            Chip(label: Text('Microsoft')),
                            Chip(label: Text('Training')),
                            Chip(label: Text('Productivity')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
