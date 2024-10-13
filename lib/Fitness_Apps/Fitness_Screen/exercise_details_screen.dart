import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_3/Fitness_Apps/Model_Class/fitness_model.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercises exercise;

  ExerciseDetailScreen({required this.exercise});

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  int _remainingSeconds = 10 * 60; // 30 minutes in seconds
  bool _isRunning = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: _remainingSeconds),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _controller.forward();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _controller.stop();
    setState(() => _isRunning = false);
  }

  void _cancelTimer() {
    _stopTimer();
    setState(() {
      _remainingSeconds = 10 * 60;
      _controller.reset();
    });
  }

  String _formatTime(int seconds) =>
      "${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}";

  double get _progress => (_remainingSeconds / (10 * 60));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.exercise.title ?? 'Exercise Detail',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent]),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.blue[300]!, Colors.purple[300]!]),
        ),
        padding: const EdgeInsets.all(3.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Enlarging Animation for Exercise GIF
            Expanded(
              flex: 1, // Makes the GIF view larger
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: widget.exercise.gif != null
                    ? Image.network(
                        widget.exercise.gif!,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Icon(Icons.fitness_center,
                        size: 100, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),

            // Remaining Time
            Text(
              'Remaining Time: ${_formatTime(_remainingSeconds)}',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.tealAccent),
            ),
            SizedBox(height: 15),

            // Progress Bar
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.white,
              color: Colors.tealAccent,
              minHeight: 10,
            ),
            SizedBox(height: 20),

            // Button row for Start, Stop, Cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.play_arrow, 'Start', Colors.green,
                    _isRunning ? null : _startTimer),
                _buildActionButton(Icons.pause, 'Stop', Colors.orange,
                    _isRunning ? _stopTimer : null),
                _buildActionButton(
                    Icons.cancel, 'Cancel', Colors.pink, _cancelTimer),
              ],
            ),
            SizedBox(height: 20),

            // Music Playlist Section
            Expanded(
              flex: 1, // Expands the music playlist space
              child: _buildMusicPlaylist(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color color, VoidCallback? onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.symmetric(vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 30,
          ),
          icon: Icon(icon, size: 20),
          label: Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildMusicPlaylist() {
    // Placeholder for Music Playlist with scrolling
    List<Map<String, String>> musicList = [
      {'title': 'Relaxing Beats', 'duration': '3:45'},
      {'title': 'Power Workout', 'duration': '4:20'},
      {'title': 'Chill Vibes', 'duration': '5:30'},
      {'title': 'Upbeat Energies', 'duration': '6:10'},
      {'title': 'Zen Mode', 'duration': '3:50'},
      {'title': 'Strength Builder', 'duration': '4:45'},
      {'title': 'Focus Mode', 'duration': '5:15'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(5.0),
      itemCount: musicList.length,
      itemBuilder: (context, index) {
        return _buildMusicItem(
            musicList[index]['title']!, musicList[index]['duration']!);
      },
    );
  }

  Widget _buildMusicItem(String title, String duration) {
    return ListTile(
      leading: Icon(Icons.music_note, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      trailing: Text(duration, style: TextStyle(color: Colors.white)),
      onTap: () {
        // Implement music selection logic here
      },
    );
  }
}
