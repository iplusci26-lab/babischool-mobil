import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../core/storage/secure_storage_service.dart';

import '../../core/api/ws_endpoints.dart';

class NotificationWebSocketService {

  WebSocketChannel? channel;

  Future<void> connect({

    required Function(
      Map<String,dynamic>
    ) onNotification,

  }) async {

    final token =

    await SecureStorageService
    .getAccessToken();

    channel =

    WebSocketChannel.connect(

      Uri.parse(

        "${WsEndpoints.notifications}?token=$token"
      ),
    );

    channel!.stream.listen(

      (event) {

        final data =

        jsonDecode(event);

        onNotification(data);
      },

      onError: (e) {

        print(
          "NOTIFICATION WS ERROR $e",
        );
      },

      onDone: () {

        print(
          "NOTIFICATION WS CLOSED",
        );
      },
    );
  }

  void disconnect() {

    channel?.sink.close();
  }
}