import 'package:flutter/material.dart';
import '../../core/constants/zego_config.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../models/contact_model.dart';
import '../../services/user_session.dart';
import '../../services/call_signaling_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/user_avatar.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const HomeScreen({super.key, this.onNavigateTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    UserSession.currentUserNotifier.addListener(_onUserSessionChanged);
  }

  void _onUserSessionChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    UserSession.currentUserNotifier.removeListener(_onUserSessionChanged);
    super.dispose();
  }

  Future<void> _makeVideoCall(ContactModel targetContact) async {
    final caller = UserSession.currentUser;

    if (ZegoConfig.isConfigured) {
      final roomId = await CallSignalingService.instance.initiateCall(
        caller: caller,
        receiver: targetContact,
      );

      if (!mounted) return;
      Navigator.pushNamed(
        context,
        AppRoutes.zegoCall,
        arguments: {
          'contact': targetContact,
          'roomId': roomId,
        },
      );
    } else {
      Navigator.pushNamed(
        context,
        AppRoutes.videoCall,
        arguments: targetContact,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = UserSession.currentUser;
    final isTri = currentUser.id == 'user_tri' || currentUser.email.contains('tri');
    final contacts = UserSession.contactsForCurrentUser;
    final primaryTarget = contacts.first; // Minh nếu đang là Trí, hoặc Trí nếu đang là Minh
    final onlineContacts = contacts.take(3).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header: User Greeting & Avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        UserAvatar(
                          imageUrl: currentUser.avatarUrl,
                          name: currentUser.name,
                          radius: 24,
                          showOnlineIndicator: true,
                          isOnline: true,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Xin chào, ${currentUser.name} 👋',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
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
                                  const Text(
                                    'Sẵn sàng nhận cuộc gọi',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Button đổi nhanh danh tính Trí ⇄ Minh
                  FilledButton.tonalIcon(
                    onPressed: () {
                      UserSession.toggleIdentity();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã chuyển sang: ${UserSession.currentUser.name}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                    label: Text(
                      isTri ? 'Đổi Minh' : 'Đổi Trí',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: isTri ? AppColors.primaryLight : Colors.green.shade50,
                      foregroundColor: isTri ? AppColors.primary : Colors.green.shade800,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Banner thông báo thiết bị hiện tại
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isTri ? const Color(0xFFEFF6FF) : const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isTri ? const Color(0xFF93C5FD) : const Color(0xFF86EFAC),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 20,
                      color: isTri ? const Color(0xFF1D4ED8) : const Color(0xFF15803D),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isTri
                            ? 'Máy này là Trí ➔ Bấm gọi bên dưới sẽ gửi chuông sang máy Minh.'
                            : 'Máy này là Minh ➔ Đang chờ cuộc gọi từ Trí (hoặc bấm gọi Trí).',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isTri ? const Color(0xFF1E3A8A) : const Color(0xFF14532D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar
              CustomTextField(
                hintText: 'Tìm kiếm người liên hệ...',
                prefixIcon: Icons.search_rounded,
                onChanged: (val) {},
              ),
              const SizedBox(height: 20),

              // Online Now Section
              const Text(
                'Đang online',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 88,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: onlineContacts.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final contact = onlineContacts[index];
                    return GestureDetector(
                      onTap: () => _makeVideoCall(contact),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UserAvatar(
                            imageUrl: contact.avatarUrl,
                            name: contact.name,
                            radius: 28,
                            showOnlineIndicator: true,
                            isOnline: true,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            contact.name.split(' ').first,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Prominent Action Banner: "Gọi ngay cho [Đối tác 1-1]"
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gọi cho ${primaryTarget.name}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Kết nối tự động 1-1 qua ZEGOCLOUD HD',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            onPressed: () => _makeVideoCall(primaryTarget),
                            icon: const Icon(Icons.videocam_rounded, size: 20),
                            label: Text('Gọi ${primaryTarget.name.split(' ').last}'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              minimumSize: const Size(130, 42),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.video_call_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recent Calls Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cuộc gọi gần đây',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.onNavigateTab != null) {
                        widget.onNavigateTab!(2); // Navigate to Calls tab
                      }
                    },
                    child: const Text(
                      'Xem tất cả',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Recent Calls Item targeting primary partner
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                  leading: UserAvatar(
                    imageUrl: primaryTarget.avatarUrl,
                    name: primaryTarget.name,
                    radius: 22,
                    showOnlineIndicator: true,
                    isOnline: primaryTarget.isOnline,
                  ),
                  title: Text(
                    primaryTarget.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: const Row(
                    children: [
                      Icon(
                        Icons.videocam_outlined,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Hôm nay, 10:30 AM',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.videocam_rounded,
                      color: AppColors.primary,
                    ),
                    onPressed: () => _makeVideoCall(primaryTarget),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
