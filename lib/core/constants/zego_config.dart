class ZegoConfig {
  /// AppID từ ZEGOCLOUD Console
  static const int appID = 1296665015; 

  /// AppSign từ ZEGOCLOUD Console
  static const String appSign = "2df4ed32eb830fbc9355cf5db562dc825cb06f43be83953fb4c88b6357cf0ccf";

  /// Kiểm tra xem người dùng đã cấu hình key thật hay chưa
  static bool get isConfigured => appID != 0 && appSign != "THAY_BANG_APPSIGN_CUA_BAN";
}
