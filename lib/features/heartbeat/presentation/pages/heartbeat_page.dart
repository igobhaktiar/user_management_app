import 'package:flutter/material.dart';

class HeartbeatPage extends StatefulWidget {
  const HeartbeatPage({super.key});

  @override
  State<HeartbeatPage> createState() => _HeartbeatPageState();
}

class _HeartbeatPageState extends State<HeartbeatPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  int _bpm = 60; // Default BPM
  bool _isBeating = false;
  bool _isDisposed = false; // Track if controller is disposed

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    // Calculate duration based on BPM
    // BPM = beats per minute, so duration = 60000ms / BPM
    final duration = Duration(milliseconds: (60000 / _bpm).round());

    _controller = AnimationController(vsync: this, duration: duration);

    // Heart scale animation (thump effect)
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.3).chain(CurveTween(curve: Curves.easeOut)), weight: 15),
      TweenSequenceItem(tween: Tween<double>(begin: 1.3, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 15),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.2).chain(CurveTween(curve: Curves.easeOut)), weight: 10),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 10),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 50),
    ]).animate(_controller);

    // Pulse animation for background
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _updateBPM(int newBpm) {
    if (_bpm == newBpm || _isDisposed) return; // Avoid unnecessary updates

    _bpm = newBpm;

    // Calculate new duration
    final duration = Duration(milliseconds: (60000 / _bpm).round());

    // Update controller duration
    final wasPlaying = _controller.isAnimating;
    final oldController = _controller;

    setState(() {
      // Create new controller with new duration
      _controller = AnimationController(vsync: this, duration: duration);

      // Recreate animations
      _scaleAnimation = TweenSequence<double>([
        TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.3).chain(CurveTween(curve: Curves.easeOut)), weight: 15),
        TweenSequenceItem(tween: Tween<double>(begin: 1.3, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 15),
        TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.2).chain(CurveTween(curve: Curves.easeOut)), weight: 10),
        TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 10),
        TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 50),
      ]).animate(_controller);

      _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      // Resume if it was playing
      if (wasPlaying) {
        _controller.repeat();
      }
    });

    // Dispose old controller after new one is created
    oldController.dispose();
  }

  void _toggleBeating() {
    setState(() {
      _isBeating = !_isBeating;
      if (_isBeating) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true; // Mark as disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Heart Beat Monitor'), elevation: 0, backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red.shade700, Colors.red.shade400, Colors.pink.shade300],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // BPM Display
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      'BPM',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: Colors.white70, letterSpacing: 2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_bpm',
                      style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const Text('beats per minute', style: TextStyle(fontSize: 14, color: Colors.white70)),
                  ],
                ),
              ),

              // Heart Animation
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Pulse circles
                          ...List.generate(3, (index) {
                            final delay = index * 0.15;
                            final progress = (_pulseAnimation.value - delay).clamp(0.0, 1.0);
                            final opacity = (1.0 - progress) * 0.3;
                            final scale = 1.0 + (progress * 2.0);

                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withOpacity(opacity), width: 2),
                                ),
                              ),
                            );
                          }),

                          // Heart icon
                          Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Icon(Icons.favorite, size: 150, color: Colors.white.withOpacity(0.9)),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // BPM Slider
              Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Adjust BPM',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red.shade700),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            '$_bpm BPM',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('40', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        Expanded(
                          child: Slider(
                            value: _bpm.toDouble(),
                            min: 40,
                            max: 200,
                            divisions: 160,
                            activeColor: Colors.red.shade700,
                            inactiveColor: Colors.red.shade100,
                            onChanged: (value) {
                              _bpm = value.round();

                              _updateBPM(_bpm);
                              setState(() {});
                            },
                          ),
                        ),
                        const Text('200', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getBPMCategory(),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),

              // Control Button
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: ElevatedButton.icon(
                  onPressed: _toggleBeating,
                  icon: Icon(_isBeating ? Icons.pause : Icons.play_arrow),
                  label: Text(_isBeating ? 'Stop' : 'Start'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getBPMCategory() {
    if (_bpm < 60) {
      return 'Bradycardia (Slow heart rate)';
    } else if (_bpm <= 100) {
      return 'Normal resting heart rate';
    } else if (_bpm <= 140) {
      return 'Light to moderate activity';
    } else if (_bpm <= 180) {
      return 'Vigorous activity';
    } else {
      return 'Maximum heart rate';
    }
  }
}
