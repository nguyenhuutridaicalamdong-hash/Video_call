import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../models/call_history_model.dart';
import '../../widgets/user_avatar.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calls = MockData.callHistory;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Call History'),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          itemCount: calls.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final call = calls[index];
            final isMissed = call.type == CallType.missed;

            IconData typeIcon;
            Color typeColor;

            switch (call.type) {
              case CallType.incoming:
                typeIcon = Icons.call_received_rounded;
                typeColor = AppColors.online;
                break;
              case CallType.outgoing:
                typeIcon = Icons.call_made_rounded;
                typeColor = AppColors.primary;
                break;
              case CallType.missed:
                typeIcon = Icons.call_missed_rounded;
                typeColor = AppColors.endCall;
                break;
            }

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                leading: UserAvatar(
                  imageUrl: call.contact.avatarUrl,
                  name: call.contact.name,
                  radius: 24,
                  showOnlineIndicator: true,
                  isOnline: call.contact.isOnline,
                ),
                title: Text(
                  call.contact.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isMissed ? AppColors.endCall : AppColors.textPrimary,
                  ),
                ),
                subtitle: Row(
                  children: [
                    Icon(typeIcon, size: 14, color: typeColor),
                    const SizedBox(width: 4),
                    Text(
                      '${call.formattedTime} • ${call.duration}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isMissed
                            ? AppColors.endCall.withValues(alpha: 0.85)
                            : AppColors.textSecondary,
                        fontWeight:
                            isMissed ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.videocam_rounded,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.videoCall,
                      arguments: call.contact,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
