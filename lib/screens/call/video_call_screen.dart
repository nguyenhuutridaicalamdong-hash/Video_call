import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../models/contact_model.dart';
import '../../widgets/custom_button.dart';

class VideoCallScreen extends StatefulWidget {
  final ContactModel? contact;

  const VideoCallScreen({super.key, this.contact});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMicMuted = false;
  bool _isCameraOff = false;
  bool _isSpeakerOn = true;
  bool _isFrontCamera = true;

  late Timer _durationTimer;
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  @override
  void dispose() {
    _durationTimer.cancel();
    super.dispose();
  }

  String get _formattedDuration {
    final minutes = (_secondsElapsed ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsElapsed % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _endCall(ContactModel activeContact) {
    _durationTimer.cancel();
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.callEnded,
      arguments: {
        'contact': activeContact,
        'duration': _formattedDuration,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeContact = widget.contact ??
        (ModalRoute.of(context)?.settings.arguments as ContactModel?) ??
        MockData.contacts[0];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Full-screen Remote Video Simulation
          if (activeContact.avatarUrl != null)
            Image.network(
              activeContact.avatarUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF1E293B),
                child: Center(
                  child: Text(
                    activeContact.initials,
                    style: const TextStyle(
                      fontSize: 72,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          else
            Container(
              color: const Color(0xFF1E293B),
              child: Center(
                child: Text(
                  activeContact.initials,
                  style: const TextStyle(
                    fontSize: 72,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Gradient overlay on remote video for readable controls
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
                stops: const [0.0, 0.25, 0.65, 1.0],
              ),
            ),
          ),

          // 2. Top Bar: Caller Name & Live Call Duration
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          activeContact.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.online,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formattedDuration,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Small Floating Local Camera Preview (PIP) in top/right corner
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 16),
                child: Container(
                  width: 105,
                  height: 145,
                  decoration: BoxDecoration(
                    color: _isCameraOff ? const Color(0xFF334155) : Colors.black,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (_isCameraOff)
                        const Center(
                          child: Icon(
                            Icons.videocam_off_rounded,
                            color: Colors.white60,
                            size: 30,
                          ),
                        )
                      else
                        Image.network(
                          MockData.currentUserAvatar,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                        ),
                      Positioned(
                        bottom: 6,
                        left: 8,
                        child: Text(
                          'You',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            shadows: const [
                              Shadow(color: Colors.black87, blurRadius: 4),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 4. Bottom Controls: Mic, Cam, Speaker, Switch Cam, End Call
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Secondary controls row
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Mic Button
                          CallCircleButton(
                            icon: _isMicMuted
                                ? Icons.mic_off_rounded
                                : Icons.mic_rounded,
                            backgroundColor: _isMicMuted
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.2),
                            iconColor: _isMicMuted
                                ? Colors.black
                                : Colors.white,
                            size: 50,
                            onPressed: () {
                              setState(() {
                                _isMicMuted = !_isMicMuted;
                              });
                            },
                          ),

                          // Camera Button
                          CallCircleButton(
                            icon: _isCameraOff
                                ? Icons.videocam_off_rounded
                                : Icons.videocam_rounded,
                            backgroundColor: _isCameraOff
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.2),
                            iconColor: _isCameraOff
                                ? Colors.black
                                : Colors.white,
                            size: 50,
                            onPressed: () {
                              setState(() {
                                _isCameraOff = !_isCameraOff;
                              });
                            },
                          ),

                          // Speaker Button
                          CallCircleButton(
                            icon: _isSpeakerOn
                                ? Icons.volume_up_rounded
                                : Icons.volume_off_rounded,
                            backgroundColor: _isSpeakerOn
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.2),
                            iconColor: _isSpeakerOn
                                ? Colors.black
                                : Colors.white,
                            size: 50,
                            onPressed: () {
                              setState(() {
                                _isSpeakerOn = !_isSpeakerOn;
                              });
                            },
                          ),

                          // Switch Camera Button
                          CallCircleButton(
                            icon: Icons.flip_camera_ios_rounded,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            iconColor: Colors.white,
                            size: 50,
                            onPressed: () {
                              setState(() {
                                _isFrontCamera = !_isFrontCamera;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(_isFrontCamera
                                      ? 'Switched to front camera'
                                      : 'Switched to back camera'),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Primary Red End Call Button
                    CallCircleButton(
                      icon: Icons.call_end_rounded,
                      backgroundColor: AppColors.endCall,
                      iconColor: Colors.white,
                      size: 68,
                      onPressed: () => _endCall(activeContact),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
