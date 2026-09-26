import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../models/contact_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/user_avatar.dart';

class CallEndedScreen extends StatelessWidget {
  const CallEndedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final ContactModel contact = args?['contact'] as ContactModel? ?? MockData.contacts[0];
    final String duration = args?['duration'] as String? ?? '02:35';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Caller Avatar
                  UserAvatar(
                    imageUrl: contact.avatarUrl,
                    name: contact.name,
                    radius: 54,
                  ),
                  const SizedBox(height: 20),

                  // Caller Name
                  Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Call ended text
                  const Text(
                    'Call ended',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.endCall,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Duration chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          duration,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Buttons: "Call Again" & "Back to Home"
                  CustomButton(
                    text: 'Call Again',
                    icon: Icons.videocam_rounded,
                    backgroundColor: AppColors.primary,
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.videoCall,
                        arguments: contact,
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  CustomButton(
                    text: 'Back to Home',
                    isOutlined: true,
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.main,
                        (route) => false,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
