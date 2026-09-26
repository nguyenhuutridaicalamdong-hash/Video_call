import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double radius;
  final bool showOnlineIndicator;
  final bool isOnline;

  const UserAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.radius = 24,
    this.showOnlineIndicator = false,
    this.isOnline = false,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    Widget avatarChild;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatarChild = CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.primaryLight,
        backgroundImage: NetworkImage(imageUrl!),
        onBackgroundImageError: (exception, stackTrace) {},
        child: Text(
          initials,
          style: TextStyle(
            fontSize: radius * 0.7,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      );
    } else {
      avatarChild = CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.primaryLight,
        child: Text(
          initials,
          style: TextStyle(
            fontSize: radius * 0.7,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (!showOnlineIndicator) {
      return avatarChild;
    }

    final indicatorSize = (radius * 0.55).clamp(10.0, 16.0);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatarChild,
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: indicatorSize,
              height: indicatorSize,
              decoration: BoxDecoration(
                color: AppColors.online,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: indicatorSize * 0.2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
