class ZegoConfig {
  /// Lấy AppID (số nguyên) từ ZEGOCLOUD Console và dán vào đây
  /// Ví dụ: static const int appID = 1234567890;
  static const int appID = 0; 

  /// Lấy AppSign (chuỗi 64 ký tự) từ ZEGOCLOUD Console và dán vào đây
  /// Ví dụ: static const String appSign = "abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890";
  static const String appSign = "THAY_BANG_APPSIGN_CUA_BAN";

  /// Kiểm tra xem người dùng đã cấu hình key thật hay chưa
  static bool get isConfigured => appID != 0 && appSign != "THAY_BANG_APPSIGN_CUA_BAN";
}
