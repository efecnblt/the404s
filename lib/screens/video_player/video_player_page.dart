import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cyber_security_app/services/api_services.dart';
import 'package:cyber_security_app/screens/quiz_screen/quiz/main_quiz_page.dart';

class VideoPlayerPage extends StatefulWidget {
  final int courseId;
  final int userId;

  const VideoPlayerPage(
      {Key? key, required this.courseId, required this.userId})
      : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  String _currentVideoTitle = "Loading...";
  bool _isLoading = true;
  bool _isOffline = false;
  int? _currentVideoId;
  Timer? _progressUpdateTimer;
  Map<int, double> _videoProgress = {}; // Track progress for each video
  double _currentProgress = 0.0;
  double _watchedDuration = 0.0;
  Map<String, dynamic>? _courseProgress;

  // Updated to store sections with their videos
  List<Map<String, dynamic>> _sections = [];
  Map<int, List<Map<String, dynamic>>> _sectionVideos = {};
  Set<int> _completedVideos = {};
  Set<int> _completedQuizzes = {};

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _fetchCourseData();
    _fetchCourseProgress();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      _handleConnectivityChange(result);
      _connectivitySubscription = Connectivity()
          .onConnectivityChanged
          .listen(_handleConnectivityChange);
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
    }
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    setState(() {
      _isOffline = result == ConnectivityResult.none;
    });
  }

  Future<void> _fetchCourseProgress() async {
    if (_isOffline) return;

    try {
      final progress =
          await ApiService.getCourseProgress(widget.courseId, widget.userId);
      if (mounted) {
        setState(() {
          _courseProgress = progress;
          if (_courseProgress != null &&
              _courseProgress!['completedVideos'] != null) {
            _completedVideos =
                Set<int>.from(_courseProgress!['completedVideos']);

            // Initialize video progress for completed videos
            for (var videoId in _completedVideos) {
              _videoProgress[videoId] = 100.0;
            }
          }
          if (_courseProgress != null &&
              _courseProgress!['completedQuizzes'] != null) {
            _completedQuizzes =
                Set<int>.from(_courseProgress!['completedQuizzes']);
          }
        });
      }
    } catch (e) {
      debugPrint('Error fetching course progress: $e');
    }
  }

  @override
  void dispose() {
    _progressUpdateTimer?.cancel();
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void _startProgressTracking() {
    _progressUpdateTimer?.cancel();
    _progressUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isOffline && _currentVideoId != null) {
        _updateProgress();
      }
    });
  }

  Future<void> _updateProgress() async {
    if (_currentVideoId == null || !mounted) return;

    final Duration currentPosition = _videoPlayerController.value.position;
    final Duration totalDuration = _videoPlayerController.value.duration;

    if (totalDuration.inSeconds == 0) return;

    final double progress =
        (currentPosition.inSeconds / totalDuration.inSeconds) * 100;
    final double watchedDuration = currentPosition.inSeconds.toDouble();

    try {
      await ApiService.updateCourseProgress(
        widget.userId,
        widget.courseId,
        _currentVideoId!,
        progress,
        watchedDuration,
      );

      if (mounted) {
        setState(() {
          if (_currentVideoId != null) {
            // Sadece mevcut video için güncelle
            if (progress >= 90) {
              _completedVideos.add(_currentVideoId!);
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error updating video progress: $e');
    }
  }

  Future<void> _fetchCourseData() async {
    try {
      final sectionsResponse = await ApiService.getRequest(
          '/api/Sections/course/${widget.courseId}');
      final sections = List<Map<String, dynamic>>.from(sectionsResponse);

      Map<int, List<Map<String, dynamic>>> sectionVideos = {};

      for (var section in sections) {
        final sectionId = section['sectionID'];
        try {
          final videosResponse =
              await ApiService.getRequest('/api/Videos/section/$sectionId');
          final videos = List<Map<String, dynamic>>.from(videosResponse);
          sectionVideos[sectionId] = videos;
        } catch (error) {
          debugPrint('Error fetching videos for section $sectionId: $error');
          sectionVideos[sectionId] = [];
        }
      }

      if (mounted) {
        setState(() {
          _sections = sections;
          _sectionVideos = sectionVideos;

          // Initialize player with first video if available
          for (var section in sections) {
            final sectionId = section['sectionID'];
            final videos = sectionVideos[sectionId] ?? [];
            if (videos.isNotEmpty) {
              _currentVideoTitle = videos.first['title'];
              _initializePlayer(
                  videos.first['url'], videos.first['videoId'] ?? -1);
              break;
            }
          }
        });
      }
    } catch (error) {
      debugPrint('Error fetching course data: $error');
      if (mounted) {
        setState(() {
          _currentVideoTitle = 'Failed to load data';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _initializePlayer(String videoUrl, int videoId) async {
    if (_isOffline) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      _videoPlayerController = VideoPlayerController.network(videoUrl);
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );

      _videoPlayerController.addListener(_onVideoPositionChanged);

      setState(() {
        _isLoading = false;
        _currentVideoId = videoId;
        _currentProgress = _videoProgress[videoId] ?? 0.0;
        _watchedDuration = 0.0;
      });

      _startProgressTracking();
    } catch (error) {
      debugPrint('Error initializing video player: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onVideoPositionChanged() async {
    if (!mounted || _currentVideoId == null) return;

    final Duration position = _videoPlayerController.value.position;
    final Duration total = _videoPlayerController.value.duration;

    if (total.inSeconds > 0) {
      final double progress = (position.inSeconds / total.inSeconds) * 100;

      if (mounted) {
        setState(() {
          // Update progress only for the current video
          _videoProgress[_currentVideoId!] = progress;
          _currentProgress = progress;
          _watchedDuration = position.inSeconds.toDouble();

          // Mark as completed if progress is >= 90%
          if (progress >= 90 && !_completedVideos.contains(_currentVideoId)) {
            _completedVideos.add(_currentVideoId!);
            // Update the backend about completion
            _updateProgress();
          }
        });
      }
    }
  }

  Future<void> loadNewVideo(
      String videoUrl, String videoTitle, int videoId) async {
    if (_isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot load video while offline'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _currentVideoTitle = videoTitle;
      _currentProgress = 0.0;
    });

    // Update progress of current video before switching
    if (_currentVideoId != null) {
      await _updateProgress();
    }

    _progressUpdateTimer?.cancel();
    _chewieController?.dispose();
    await _videoPlayerController.dispose();

    await _initializePlayer(videoUrl, videoId);
  }

  bool _isSectionCompleted(int sectionId) {
    final videos = _sectionVideos[sectionId] ?? [];
    if (videos.isEmpty) return false;

    bool allVideosCompleted = videos.every((video) {
      final videoId = video['videoId'];
      return videoId != null && _completedVideos.contains(videoId);
    });

    return allVideosCompleted;
  }

  Widget _buildSection(String sectionTitle, List<Map<String, dynamic>> videos) {
    final int sectionId = _sections.firstWhere(
      (section) => section['title'] == sectionTitle,
      orElse: () => {'sectionID': -1},
    )['sectionID'];

    final bool sectionCompleted = _isSectionCompleted(sectionId);
    final bool quizCompleted = _completedQuizzes.contains(sectionId);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2F31),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    sectionTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (sectionCompleted && quizCompleted)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                  ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: videos.length,
            itemBuilder: (context, index) =>
                _buildVideoListTile(videos[index], index),
          ),
          if (sectionId != -1) ...[
            const Divider(color: Colors.white24),
            ListTile(
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: quizCompleted
                        ? Colors.green
                        : sectionCompleted
                            ? Colors.purple.shade400
                            : Colors.grey,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: quizCompleted
                      ? const Icon(Icons.check, color: Colors.green, size: 20)
                      : Icon(
                          Icons.quiz,
                          color: sectionCompleted
                              ? Colors.purple.shade400
                              : Colors.grey,
                          size: 20,
                        ),
                ),
              ),
              title: Text(
                'Section Quiz',
                style: TextStyle(
                  color: sectionCompleted ? Colors.white : Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                quizCompleted ? 'Completed' : 'Take quiz',
                style: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              enabled: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MainQuizPage(quizId: sectionId.toString()),
                  ),
                ).then((completed) {
                  if (completed == true) {
                    setState(() {
                      _completedQuizzes.add(sectionId);
                    });
                  }
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVideoListTile(Map<String, dynamic> video, int index) {
    final int videoId = video['videoId'] ?? -1;
    final bool isCompleted = _completedVideos.contains(videoId);
    final bool isCurrentVideo = videoId == _currentVideoId;
    final double videoProgress = _videoProgress[videoId] ?? 0.0;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(
            color: isCompleted ? Colors.green : Colors.white38,
          ),
          shape: BoxShape.circle,
          color: isCurrentVideo ? Colors.blue.withOpacity(0.3) : null,
        ),
        child: Center(
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.green, size: 20)
              : Text(
                  "${index + 1}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
      title: Text(
        video['title'],
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: isCurrentVideo ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        isCurrentVideo ? 'Currently playing' : '',
        style: TextStyle(color: Colors.grey[400]),
      ),
      onTap: () {
        if (!_isOffline) {
          loadNewVideo(video['url'], video['title'], videoId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot load video while offline'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1D1F),
      appBar: AppBar(
        title: const Text(
          "Course Player",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2D2F31),
      ),
      body: _isOffline
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 64, color: Colors.white54),
                  const SizedBox(height: 16),
                  const Text(
                    'No Internet Connection',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Connectivity().checkConnectivity();
                      _handleConnectivityChange(result);
                      if (!_isOffline) {
                        _fetchCourseData();
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video Player Area
                  Container(
                    width: double.infinity,
                    height: 400,
                    color: Colors.black54,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _chewieController != null
                            ? Chewie(controller: _chewieController!)
                            : const Center(
                                child: Text(
                                  'Failed to load video',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                  ),

                  // Video Title
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _currentVideoTitle,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Course Progress
                  if (_currentVideoId != null && _currentProgress > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Progress',
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: _currentProgress / 100,
                            backgroundColor: Colors.grey[800],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _currentProgress >= 90
                                  ? Colors.green
                                  : Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

                  // Sections and Videos
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: _sections.map((section) {
                        final sectionId = section['sectionID'];
                        final sectionTitle = section['title'];
                        final videos = _sectionVideos[sectionId] ?? [];

                        return _buildSection(sectionTitle, videos);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
