import 'package:flutter/material.dart';
import '../../core/constants/zego_config.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../models/contact_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/user_avatar.dart';

class ContactsScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const ContactsScreen({super.key, this.onNavigateTab});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();
  List<ContactModel> _filteredContacts = MockData.contacts;

  @override
  void initState() {
    super.initState();
    _filteredContacts = MockData.contacts;
  }

  void _filterContacts(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredContacts = MockData.contacts;
      } else {
        _filteredContacts = MockData.contacts
            .where((c) =>
                c.name.toLowerCase().contains(query.toLowerCase().trim()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(3); // Navigate to Profile tab
                }
              },
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _authService.getUserDocStream(),
                builder: (context, snapshot) {
                  final userData = snapshot.data?.data();
                  final user = _authService.currentUser;
                  final displayName = (userData?['name'] as String?)?.isNotEmpty == true
                      ? userData!['name'] as String
                      : (user?.displayName?.isNotEmpty == true
                          ? user!.displayName!
                          : (user?.email?.split('@').first ?? 'User'));
                  final avatarUrl = (userData?['avatarUrl'] as String?)?.isNotEmpty == true
                      ? userData!['avatarUrl'] as String
                      : MockData.currentUserAvatar;

                  return UserAvatar(
                    imageUrl: avatarUrl,
                    name: displayName,
                    radius: 18,
                    showOnlineIndicator: true,
                    isOnline: true,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: CustomTextField(
                controller: _searchController,
                hintText: 'Search contacts...',
                prefixIcon: Icons.search_rounded,
                onChanged: _filterContacts,
              ),
            ),
            const SizedBox(height: 12),

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
                            'No contacts found',
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
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.border,
                              width: 1,
                            ),
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
                            title: Text(
                              contact.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
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
                                  contact.isOnline ? 'Online' : 'Offline',
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
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  ZegoConfig.isConfigured
                                      ? AppRoutes.zegoCall
                                      : AppRoutes.videoCall,
                                  arguments: contact,
                                );
                              },
                              icon: const Icon(Icons.videocam_rounded),
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.primaryLight,
                                foregroundColor: AppColors.primary,
                                padding: const EdgeInsets.all(10),
                              ),
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
