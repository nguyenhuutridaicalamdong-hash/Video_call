import 'contact_model.dart';

enum CallType { incoming, outgoing, missed }

class CallHistoryModel {
  final String id;
  final ContactModel contact;
  final DateTime dateTime;
  final String duration;
  final CallType type;
  final bool isVideo;

  const CallHistoryModel({
    required this.id,
    required this.contact,
    required this.dateTime,
    required this.duration,
    required this.type,
    this.isVideo = true,
  });

  String get formattedTime {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return 'Today, $hour:$minute';
  }
}
