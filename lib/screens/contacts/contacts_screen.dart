import 'package:flutter/material.dart';
import '../../core/constants/zego_config.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../models/contact_model.dart';
import '../../services/user_session.dart';
import '../../services/call_signaling_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/user_avatar.dart';

class ContactsScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const ContactsScreen({super.key, this.onNavigateTab});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ContactModel> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _filteredContacts = UserSession.contactsForCurrentUser;
    UserSession.currentUserNotifier.addListener(_onUserSessionChanged);
  }

  void _onUserSessionChanged() {
    if (mounted) {
      setState(() {
        _filterContacts(_searchController.text);
      });
    }
  }

  void _filterContacts(String query) {
    final base = UserSession.contactsForCurrentUser;
    setState(() {
      if (query.trim().isEmpty) {
        _filteredContacts = base;
      } else {
        _filteredContacts = base
            .where((c) =>
                c.name.toLowerCase().contains(query.toLowerCase().trim()))
            .toList();
      }
    });
  }

  Future<void> _makeVideoCall(ContactModel targetContact) async {
    final caller = UserSession.currentUser;

    if (ZegoConfig.isConfigured) {
      // Bắn tín hiệu qua Firestore active_calls
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
  void dispose() {
    UserSession.currentUserNotifier.removeListener(_onUserSessionChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = UserSession.currentUser;
    final isTri = currentUser.id == 'user_tri' || currentUser.email.contains('tri');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Danh bạ liên hệ'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(3); // Navigate to Profile tab
                }
              },
              child: UserAvatar(
                imageUrl: currentUser.avatarUrl,
                name: currentUser.name,
                radius: 18,
                showOnlineIndicator: true,
                isOnline: true,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Banner chọn danh tính thiết bị (Trí ⇄ Minh)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                    Icons.phone_android_rounded,
                    size: 20,
                    color: isTri ? const Color(0xFF1D4ED8) : const Color(0xFF15803D),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Máy này: ${currentUser.name}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isTri ? const Color(0xFF1E3A8A) : const Color(0xFF14532D),
                          ),
                        ),
                        Text(
                          isTri ? 'Bấm nút gọi bên dưới để gọi Minh' : 'Bấm nút gọi bên dưới để gọi Trí',
                          style: TextStyle(
                            fontSize: 11,
                            color: isTri ? const Color(0xFF2563EB) : const Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      backgroundColor: Colors.white,
                      foregroundColor: isTri ? AppColors.primary : Colors.green.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.swap_horiz_rounded, size: 16),
                    label: Text(
                      isTri ? 'Đổi Minh' : 'Đổi Trí',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      UserSession.toggleIdentity();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Đã chuyển sang thiết bị: ${UserSession.currentUser.name}',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: CustomTextField(
                controller: _searchController,
                hintText: 'Tìm kiếm người liên hệ...',
                prefixIcon: Icons.search_rounded,
                onChanged: _filterContacts,
              ),
            ),
            const SizedBox(height: 8),

            // Contacts List
            Expanded(
              child: _filteredContacts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.person_search_rounded,
                            size: 48,
                            color: AppColors.textMuted,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Không tìm thấy liên hệ',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      itemCount: _filteredContacts.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final contact = _filteredContacts[index];
                        final isHighlighted = index == 0; // Trí hoặc Minh ở đầu

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isHighlighted ? AppColors.primary : AppColors.border,
                              width: isHighlighted ? 1.6 : 1,
                            ),
                            boxShadow: isHighlighted
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            leading: UserAvatar(
                              imageUrl: contact.avatarUrl,
                              name: contact.name,
                              radius: 24,
                              showOnlineIndicator: true,
                              isOnline: contact.isOnline,
                            ),
                            title: Row(
                              children: [
                                Text(
                                  contact.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                if (isHighlighted) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryLight,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      'Target 1-1',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: contact.isOnline
                                        ? AppColors.online
                                        : AppColors.textMuted,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  contact.isOnline ? 'Đang hoạt động' : 'Offline',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: contact.isOnline
                                        ? AppColors.online
                                        : AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton.filledTonal(
                              onPressed: () => _makeVideoCall(contact),
                              icon: const Icon(Icons.videocam_rounded),
                              style: IconButton.styleFrom(
                                backgroundColor: isHighlighted
                                    ? AppColors.primary
                                    : AppColors.primaryLight,
                                foregroundColor: isHighlighted
                                    ? Colors.white
                                    : AppColors.primary,
                                padding: const EdgeInsets.all(10),
                              ),
                              tooltip: 'Gọi video cho ${contact.name}',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
