import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contact_model.dart';
import '../core/routes/app_routes.dart';
import 'user_session.dart';

class CallSignalingService {
  static final CallSignalingService instance = CallSignalingService._internal();
  CallSignalingService._internal() {
    // Tự động lắng nghe lại khi đổi danh tính giữa Trí và Minh
    UserSession.currentUserNotifier.addListener(() {
      if (_currentContext != null && _currentContext!.mounted) {
        startListening(_currentContext!);
      }
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _incomingCallSubscription;
  bool _isShowingIncomingDialog = false;
  BuildContext? _currentContext;

  /// Tạo phòng gọi 1-1 cố định duy nhất dựa trên 2 email (sắp xếp a-b để 2 máy luôn cùng room)
  static String get1on1RoomId(String emailA, String emailB) {
    final list = [emailA.trim().toLowerCase(), emailB.trim().toLowerCase()]..sort();
    final cleanA = list[0].split('@')[0].replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final cleanB = list[1].split('@')[0].replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    return 'room_${cleanA}_$cleanB';
  }

  /// Lắng nghe cuộc gọi đến theo tài khoản hiện tại
  void startListening(BuildContext context) {
    _currentContext = context;
    _incomingCallSubscription?.cancel();

    final myEmail = UserSession.currentUser.email.trim().toLowerCase();
    debugPrint('[CallSignaling] Bắt đầu lắng nghe cuộc gọi đến cho: $myEmail');

    _incomingCallSubscription = _firestore
        .collection('active_calls')
        .where('receiverEmail', isEqualTo: myEmail)
        .where('status', isEqualTo: 'calling')
        .snapshots()
        .listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty && !_isShowingIncomingDialog) {
          final callDoc = snapshot.docs.first;
          final data = callDoc.data();

          final callerContact = ContactModel(
            id: data['callerId'] ?? 'unknown',
            name: data['callerName'] ?? 'Người gọi',
            email: data['callerEmail'] ?? '',
            avatarUrl: data['callerAvatar'],
            isOnline: true,
          );

          final roomId = data['roomId'] ?? callDoc.id;

          _isShowingIncomingDialog = true;
          debugPrint('[CallSignaling] Phát hiện cuộc gọi đến từ: ${callerContact.name}, roomId: $roomId');

          if (_currentContext != null && _currentContext!.mounted) {
            Navigator.pushNamed(
              _currentContext!,
              AppRoutes.incomingCall,
              arguments: {
                'caller': callerContact,
                'roomId': roomId,
              },
            ).then((_) {
              _isShowingIncomingDialog = false;
            });
          }
        }
      },
      onError: (err) {
        debugPrint('[CallSignaling] Lỗi lắng nghe cuộc gọi: $err');
      },
    );
  }

  void stopListening() {
    _incomingCallSubscription?.cancel();
    _incomingCallSubscription = null;
  }

  /// Bắt đầu gọi: Gửi tín hiệu sang máy bên kia
  Future<String> initiateCall({
    required ContactModel caller,
    required ContactModel receiver,
  }) async {
    final roomId = get1on1RoomId(caller.email, receiver.email);
    debugPrint('[CallSignaling] Khởi tạo cuộc gọi tới ${receiver.email}, roomId: $roomId');

    await _firestore.collection('active_calls').doc(roomId).set({
      'callerId': caller.id,
      'callerName': caller.name,
      'callerEmail': caller.email.trim().toLowerCase(),
      'callerAvatar': caller.avatarUrl ?? '',
      'receiverId': receiver.id,
      'receiverName': receiver.name,
      'receiverEmail': receiver.email.trim().toLowerCase(),
      'roomId': roomId,
      'status': 'calling',
      'timestamp': FieldValue.serverTimestamp(),
    });

    return roomId;
  }

  /// Chấp nhận cuộc gọi
  Future<void> acceptCall(String roomId) async {
    try {
      await _firestore.collection('active_calls').doc(roomId).update({
        'status': 'accepted',
      });
    } catch (e) {
      debugPrint('[CallSignaling] Lỗi khi acceptCall: $e');
    }
  }

  /// Từ chối cuộc gọi
  Future<void> declineCall(String roomId) async {
    try {
      await _firestore.collection('active_calls').doc(roomId).update({
        'status': 'declined',
      });
    } catch (e) {
      debugPrint('[CallSignaling] Lỗi khi declineCall: $e');
    }
  }

  /// Kết thúc cuộc gọi
  Future<void> endCall(String roomId) async {
    try {
      await _firestore.collection('active_calls').doc(roomId).delete();
    } catch (e) {
      debugPrint('[CallSignaling] Lỗi khi endCall: $e');
    }
  }
}
