import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../core/storage/secure_storage_service.dart';

import '../../core/api/ws_endpoints.dart';

class MessagingWebSocketService {

  WebSocketChannel? channel;

  Future<void> connect({

    required Function(
      Map<String,dynamic>
    ) onMessage,

  }) async {

    final token =

    await SecureStorageService
    .getAccessToken();

    channel = WebSocketChannel.connect(

      Uri.parse(
        
            "${WsEndpoints.messages}?token=$token"
      ),
    );

    channel!.stream.listen(

      (event) {

        print("========== WS RAW ==========");
        

        final data =

        jsonDecode(event);
        print("========== WS JSON ==========");
        
        onMessage(data);
      },

      onError: (e) {
        print("========== WS ERROR ==========");
       
        print(
          "WS ERROR $e",
        );
      },

      onDone: () {

        print("========== WS CLOSED ==========");
        
      },
    );
  }

  void disconnect() {

    channel?.sink.close();
  }
}