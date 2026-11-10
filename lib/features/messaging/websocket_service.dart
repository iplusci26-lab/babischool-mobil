import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../core/storage/secure_storage_service.dart';
import '../../core/api/ws_endpoints.dart';

class MessagingWebSocketService {
  WebSocketChannel? channel;

  StreamSubscription<dynamic>? _subscription;

  bool get isConnected => channel != null;

  Future<void> connect({
    required Function(Map<String, dynamic>) onMessage,
  }) async {
    // Éviter plusieurs connexions simultanées.
    await disconnect();

    try {
      final token = await SecureStorageService.getAccessToken();

      if (token == null || token.trim().isEmpty) {
        debugPrint('WS ERROR: JWT TOKEN NOT FOUND');
        return;
      }

      final uri = Uri.parse(WsEndpoints.messages).replace(
        queryParameters: {
          'token': token,
        },
      );

      debugPrint('========== MESSAGING WS ==========');
      debugPrint('CONNECTING TO: ${uri.replace(queryParameters: {'token': '***'})}');

      final newChannel = WebSocketChannel.connect(uri);

      channel = newChannel;

      // Écouter immédiatement pour ne pas manquer
      // le premier événement envoyé par le serveur.
      _subscription = newChannel.stream.listen(
        (event) {
          debugPrint('========== WS RAW ==========');
          debugPrint(event.toString());

          try {
            final decoded = jsonDecode(event.toString());

            if (decoded is! Map) {
              debugPrint('WS ERROR: INVALID EVENT FORMAT');
              return;
            }

            final data = Map<String, dynamic>.from(decoded);

            debugPrint('========== WS EVENT ==========');
            debugPrint(data.toString());

            onMessage(data);
          } catch (e) {
            debugPrint('WS MESSAGE ERROR: $e');
          }
        },
        onError: (error) {
          debugPrint('========== WS ERROR ==========');
          debugPrint(error.toString());
        },
        onDone: () {
          debugPrint('========== WS CLOSED ==========');
          debugPrint('CODE: ${newChannel.closeCode}');
          debugPrint('REASON: ${newChannel.closeReason}');

          if (identical(channel, newChannel)) {
            channel = null;
            _subscription = null;
          }
        },
      );

      // Attendre la confirmation de la connexion.
      await newChannel.ready;

      debugPrint('MESSAGING WS CONNECTED SUCCESSFULLY');
    } catch (e, stackTrace) {
      debugPrint('========== WS CONNECTION ERROR ==========');
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());

      await disconnect();
    }
  }

  Future<void> disconnect() async {
    debugPrint('MESSAGING WS DISCONNECTING');

    final subscription = _subscription;
    final currentChannel = channel;

    _subscription = null;
    channel = null;

    await subscription?.cancel();
    await currentChannel?.sink.close();

    debugPrint('MESSAGING WS DISCONNECTED');
  }
}