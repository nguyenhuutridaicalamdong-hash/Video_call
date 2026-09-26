class ContactModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final bool isOnline;

  const ContactModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.isOnline,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name.substring(0, 1).toUpperCase() : '?';
  }
}
