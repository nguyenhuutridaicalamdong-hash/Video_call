import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/contact_model.dart';
import '../data/mock_data.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  static bool _isManualOverride = false;

  static const ContactModel triContact = ContactModel(
    id: 'user_tri',
    name: 'Nguyễn Hữu Trí',
    email: 'tri@example.com',
    avatarUrl: MockData.currentUserAvatar,
    isOnline: true,
  );

  static const ContactModel minhContact = ContactModel(
    id: 'user_minh',
    name: 'Minh Nguyễn',
    email: 'minh.nguyen@example.com',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
    isOnline: true,
  );

  static final ValueNotifier<ContactModel> currentUserNotifier =
      ValueNotifier<ContactModel>(triContact);

  static ContactModel get currentUser {
    if (!_isManualOverride) {
      final fbUser = FirebaseAuth.instance.currentUser;
      if (fbUser != null && fbUser.email != null && fbUser.email!.isNotEmpty) {
        final email = fbUser.email!.toLowerCase();
        if (email.contains('minh')) {
          return minhContact;
        } else if (email.contains('tri')) {
          return triContact;
        }
        return ContactModel(
          id: fbUser.uid,
          name: fbUser.displayName?.isNotEmpty == true
              ? fbUser.displayName!
              : fbUser.email!.split('@').first,
          email: fbUser.email!,
          avatarUrl: fbUser.photoURL ?? MockData.currentUserAvatar,
          isOnline: true,
        );
      }
    }
    return currentUserNotifier.value;
  }

  /// Danh sách liên hệ cho người dùng hiện tại
  static List<ContactModel> get contactsForCurrentUser {
    final myEmail = currentUser.email.toLowerCase().trim();

    if (myEmail.contains('minh')) {
      // Máy đang là Minh: Danh bạ có Trí ở đầu
      return [
        triContact,
        MockData.contacts[1], // An Trần
        MockData.contacts[2], // Nam Phạm
        MockData.contacts[3], // Linh Lê
        MockData.contacts[4], // Huy Nguyễn
      ];
    } else {
      // Máy đang là Trí: Danh bạ có Minh ở đầu
      return [
        minhContact,
        MockData.contacts[1], // An Trần
        MockData.contacts[2], // Nam Phạm
        MockData.contacts[3], // Linh Lê
        MockData.contacts[4], // Huy Nguyễn
      ];
    }
  }

  /// Đổi danh tính nhanh giữa Trí và Minh
  static void switchIdentity(String targetUserId) {
    _isManualOverride = true;
    if (targetUserId == 'user_minh') {
      currentUserNotifier.value = minhContact;
    } else {
      currentUserNotifier.value = triContact;
    }
  }

  /// Toggle giữa Trí và Minh
  static void toggleIdentity() {
    if (currentUser.id == 'user_tri' || currentUser.email.contains('tri')) {
      switchIdentity('user_minh');
    } else {
      switchIdentity('user_tri');
    }
  }
}
