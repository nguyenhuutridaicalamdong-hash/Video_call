import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../models/contact_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/user_avatar.dart';

class IncomingCallScreen extends StatelessWidget {
  final ContactModel? caller;

  const IncomingCallScreen({super.key, this.caller});

  @override
  Widget build(BuildContext context) {
    // If passed via arguments or fallback to Minh Nguyễn
    final activeCaller = caller ??
        (ModalRoute.of(context)?.settings.arguments as ContactModel?) ??
        MockData.contacts[0];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Blurred background with caller's avatar or ambient glow
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
                  const SizedBox(height: 40),
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
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.videocam_rounded,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Incoming video call...',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
                        label: 'Decline',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),

                      // Accept button
                      CallCircleButton(
                        icon: Icons.videocam_rounded,
                        backgroundColor: AppColors.online,
                        iconColor: Colors.white,
                        size: 72,
                        label: 'Accept',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.videoCall,
                            arguments: activeCaller,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
