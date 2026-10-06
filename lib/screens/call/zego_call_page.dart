import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../../core/constants/zego_config.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../models/contact_model.dart';
import '../../services/user_session.dart';
import '../../services/call_signaling_service.dart';

class ZegoCallPage extends StatelessWidget {
  final ContactModel contact;
  final String? customRoomId;

  const ZegoCallPage({
    super.key,
    required this.contact,
    this.customRoomId,
  });

  @override
  Widget build(BuildContext context) {
    // Nếu chưa cấu hình AppID / AppSign
    if (!ZegoConfig.isConfigured) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Chưa có cấu hình Zego'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.key_rounded,
                  size: 64,
                  color: Color(0xFFF59E0B),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Cần nhập AppID & AppSign',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Để gọi video thật qua ZEGOCLOUD, bạn hãy mở file:\nlib/core/constants/zego_config.dart\nvà dán appID, appSign của bạn vào nhé!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.videoCall,
                      arguments: contact,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(220, 48),
                  ),
                  child: const Text('Xem giao diện Demo giả lập'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentUser = UserSession.currentUser;

    // Tên phòng gọi chung giữa 2 máy (chuẩn 1-1, đồng nhất giữa cả 2 bên)
    final callID = customRoomId ??
        CallSignalingService.get1on1RoomId(currentUser.email, contact.email);

    // User ID và User Name riêng biệt cho từng máy
    final currentUserId =
        currentUser.email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final currentUserName = currentUser.name;

    debugPrint('[ZegoCallPage] Tham gia phòng: $callID với User: $currentUserId ($currentUserName)');

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ZegoUIKitPrebuiltCall(
          appID: ZegoConfig.appID,
          appSign: ZegoConfig.appSign,
          userID: currentUserId,
          userName: currentUserName,
          callID: callID,
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
          events: ZegoUIKitPrebuiltCallEvents(
            onCallEnd: (event, defaultAction) {
              CallSignalingService.instance.endCall(callID);
              defaultAction.call();
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.callEnded,
                arguments: {
                  'contact': contact,
                  'duration': 'Live Call',
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
