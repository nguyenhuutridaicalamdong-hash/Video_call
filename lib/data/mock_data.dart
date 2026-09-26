import '../models/contact_model.dart';
import '../models/call_history_model.dart';

class MockData {
  // Current logged in user (Trí)
  static const currentUserName = "Nguyễn Hữu Trí";
  static const currentUserEmail = "tri@example.com";
  static const currentUserAvatar = "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80";

  // 5 Contacts as requested
  static final List<ContactModel> contacts = [
    const ContactModel(
      id: '1',
      name: 'Minh Nguyễn',
      email: 'minh.nguyen@example.com',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
      isOnline: true,
    ),
    const ContactModel(
      id: '2',
      name: 'An Trần',
      email: 'an.tran@example.com',
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
      isOnline: true,
    ),
    const ContactModel(
      id: '3',
      name: 'Nam Phạm',
      email: 'nam.pham@example.com',
      avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80',
      isOnline: false,
    ),
    const ContactModel(
      id: '4',
      name: 'Linh Lê',
      email: 'linh.le@example.com',
      avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80',
      isOnline: true,
    ),
    const ContactModel(
      id: '5',
      name: 'Huy Nguyễn',
      email: 'huy.nguyen@example.com',
      avatarUrl: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?auto=format&fit=crop&w=200&q=80',
      isOnline: false,
    ),
  ];

  // Online contacts
  static List<ContactModel> get onlineContacts =>
      contacts.where((c) => c.isOnline).toList();

  // Call history
  static final List<CallHistoryModel> callHistory = [
    CallHistoryModel(
      id: 'call_1',
      contact: contacts[0], // Minh Nguyễn
      dateTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
      duration: '02:35',
      type: CallType.outgoing,
    ),
    CallHistoryModel(
      id: 'call_2',
      contact: contacts[1], // An Trần
      dateTime: DateTime.now().subtract(const Duration(hours: 4, minutes: 30)),
      duration: 'Missed call',
      type: CallType.missed,
    ),
    CallHistoryModel(
      id: 'call_3',
      contact: contacts[3], // Linh Lê
      dateTime: DateTime.now().subtract(const Duration(hours: 7, minutes: 10)),
      duration: '04:15',
      type: CallType.incoming,
    ),
    CallHistoryModel(
      id: 'call_4',
      contact: contacts[2], // Nam Phạm
      dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      duration: 'Missed call',
      type: CallType.missed,
    ),
  ];
}
