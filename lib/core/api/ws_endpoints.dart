class WsEndpoints {

  static const String wsBase =
      String.fromEnvironment(
        "WS_BASE_URL",
        defaultValue: "wss://iplus-api.onrender.com",
        //"ws://127.0.0.1:8000",
      );

  static const String notifications =
      "$wsBase/ws/notifications/";

  static const String messages =
      "$wsBase/ws/messages/";
}