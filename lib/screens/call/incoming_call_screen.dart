import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../models/contact_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/user_avatar.dart';
import '../../core/constants/zego_config.dart';
import '../../services/call_signaling_service.dart';

class IncomingCallScreen extends StatefulWidget {
  final ContactModel? caller;
  final String? roomId;

  const IncomingCallScreen({super.key, this.caller, this.roomId});

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  Timer? _autoConnectTimer;
  int _countdownSeconds = 3;
  bool _hasAccepted = false;

  @override
  void initState() {
    super.initState();
    // Tự động kết nối sau 3 giây để người dùng trải nghiệm tự động hóa 1-1 mượt mà
    _startCountdown();
  }

  void _startCountdown() {
    _autoConnectTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_countdownSeconds > 1) {
        setState(() {
          _countdownSeconds--;
        });
      } else {
        _autoConnectTimer?.cancel();
        _acceptCall();
      }
    });
  }

  @override
  void dispose() {
    _autoConnectTimer?.cancel();
    super.dispose();
  }

  void _acceptCall() {
    if (_hasAccepted) return;
    _hasAccepted = true;
    _autoConnectTimer?.cancel();

    final rawArgs = ModalRoute.of(context)?.settings.arguments;
    ContactModel activeCaller;
    String? activeRoomId = widget.roomId;

    if (rawArgs is Map<String, dynamic>) {
      activeCaller = rawArgs['caller'] as ContactModel;
      activeRoomId = rawArgs['roomId'] as String?;
    } else if (rawArgs is ContactModel) {
      activeCaller = rawArgs;
    } else {
      activeCaller = widget.caller ?? MockData.contacts[0];
    }

    if (activeRoomId != null) {
      CallSignalingService.instance.acceptCall(activeRoomId);
    }

    Navigator.pushReplacementNamed(
      context,
      ZegoConfig.isConfigured ? AppRoutes.zegoCall : AppRoutes.videoCall,
      arguments: {
        'contact': activeCaller,
        'roomId': activeRoomId,
      },
    );
  }

  void _declineCall() {
    _autoConnectTimer?.cancel();
    final rawArgs = ModalRoute.of(context)?.settings.arguments;
    String? activeRoomId = widget.roomId;
    if (rawArgs is Map<String, dynamic>) {
      activeRoomId = rawArgs['roomId'] as String?;
    }

    if (activeRoomId != null) {
      CallSignalingService.instance.declineCall(activeRoomId);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final rawArgs = ModalRoute.of(context)?.settings.arguments;
    ContactModel activeCaller;

    if (rawArgs is Map<String, dynamic>) {
      activeCaller = rawArgs['caller'] as ContactModel;
    } else if (rawArgs is ContactModel) {
      activeCaller = rawArgs;
    } else {
      activeCaller = widget.caller ?? MockData.contacts[0];
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Blurred background with caller avatar
          if (activeCaller.avatarUrl != null)
            Image.network(
              activeCaller.avatarUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
            ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(
              color: Colors.black.withValues(alpha: 0.65),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // Header Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.videocam_rounded,
                          color: Colors.greenAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Cuộc gọi video 1-1',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Caller Info
                  UserAvatar(
                    imageUrl: activeCaller.avatarUrl,
                    name: activeCaller.name,
                    radius: 64,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    activeCaller.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Đang gọi cho bạn...',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Auto-connect notification pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Tự động kết nối sau $_countdownSeconds giây...',
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Action Buttons: Decline (Red) and Accept (Green)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Decline button
                      CallCircleButton(
                        icon: Icons.call_end_rounded,
                        backgroundColor: AppColors.endCall,
                        iconColor: Colors.white,
                        size: 72,
                        label: 'Từ chối',
                        onPressed: _declineCall,
                      ),

                      // Accept button
                      CallCircleButton(
                        icon: Icons.videocam_rounded,
                        backgroundColor: AppColors.online,
                        iconColor: Colors.white,
                        size: 72,
                        label: 'Trả lời ngay',
                        onPressed: _acceptCall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
