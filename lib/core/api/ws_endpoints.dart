class WsEndpoints {

  static const String wsBase =
      String.fromEnvironment(
        "WS_BASE_URL",
        defaultValue: "wss://iplus-api.onrender.com",
        
        
      );

  static const String notifications =
      "$wsBase/ws/notifications/";

  static const String messages =
      "$wsBase/ws/messages/";
}