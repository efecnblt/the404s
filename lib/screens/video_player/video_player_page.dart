import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../models/course.dart';
import '../../models/video.dart';

class VideoPlayerPage extends StatefulWidget {
  final Course course;
  final String authorId;

  const VideoPlayerPage(
      {super.key, required this.course, required this.authorId});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  Video? _currentVideo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCourseData();
    print("Course Name: ${widget.course.name}");
    print("Number of Sections: ${widget.course.sections.length}");
    if (widget.course.sections.isNotEmpty) {
      print("First Section Title: ${widget.course.sections[0].title}");
      print(
          "Number of Videos in First Section: ${widget.course.sections[0].videos.length}");
      if (widget.course.sections[0].videos.isNotEmpty) {
        _currentVideo = widget.course.sections[0].videos[0];
        print("First Video URL: ${_currentVideo!.url}");
        _initializePlayer(_currentVideo!.url);
      } else {
        print("No videos in the first section.");
      }
    } else {
      print("No sections in this course.");
    }
    // İlk videoyu ayarla
    if (widget.course.sections.isNotEmpty &&
        widget.course.sections[0].videos.isNotEmpty) {
      _currentVideo = widget.course.sections[0].videos[0];
      _initializePlayer(_currentVideo!.url);
    }
  }

  Future<void> loadCourseData() async {
    await widget.course.loadSections(widget.authorId);

    // Bölümler için videoları yükle
    for (var section in widget.course.sections) {
      await section.loadVideos(widget.authorId, widget.course.id);
    }

    // İlk videoyu ayarla
    if (widget.course.sections.isNotEmpty &&
        widget.course.sections[0].videos.isNotEmpty) {
      _currentVideo = widget.course.sections[0].videos[0];
      await _initializePlayer(_currentVideo!.url);
    } else {
      print("No sections or videos in this course.");
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _initializePlayer(String url) async {
    _videoPlayerController = VideoPlayerController.network(url);
    await _videoPlayerController!.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: false,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.course.name),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.name),
      ),
      body: Column(
        children: [
          // Video oynatıcı kodları...
          Expanded(
            child: ListView.builder(
              itemCount: widget.course.sections.length,
              itemBuilder: (context, index) {
                final section = widget.course.sections[index];
                return ExpansionTile(
                  title: Text(
                    section.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  children: section.videos.map((video) {
                    return ListTile(
                      leading: Icon(Icons.play_arrow, color: Colors.blue),
                      title: Text(
                        video.title,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {},
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onVideoSelected(Video video) {
    setState(() {
      _currentVideo = video;
      _chewieController?.dispose();
      _videoPlayerController?.dispose();
      _initializePlayer(video.url);
    });
  }
}
