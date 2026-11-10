import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../core/storage/secure_storage_service.dart';
import '../../core/api/ws_endpoints.dart';

class NotificationWebSocketService {
  WebSocketChannel? channel;

  StreamSubscription<dynamic>? _subscription;

  bool get isConnected => channel != null;

  Future<void> connect({
    required Function(Map<String, dynamic>) onNotification,
  }) async {
    await disconnect();

    try {
      final token = await SecureStorageService.getAccessToken();

      if (token == null || token.trim().isEmpty) {
        debugPrint('NOTIFICATION WS ERROR: JWT TOKEN NOT FOUND');
        return;
      }

      final uri = Uri.parse(WsEndpoints.notifications).replace(
        queryParameters: {
          'token': token,
        },
      );

      debugPrint('========== NOTIFICATION WS ==========');
      debugPrint(
        'CONNECTING TO: ${uri.replace(queryParameters: {'token': '***'})}',
      );

      final newChannel = WebSocketChannel.connect(uri);

      channel = newChannel;

      _subscription = newChannel.stream.listen(
        (event) {
          debugPrint('NOTIFICATION WS RAW: $event');

          try {
            final decoded = jsonDecode(event.toString());

            if (decoded is! Map) {
              debugPrint('NOTIFICATION WS: INVALID EVENT FORMAT');
              return;
            }

            final data = Map<String, dynamic>.from(decoded);

            debugPrint('NOTIFICATION WS EVENT: $data');

            onNotification(data);
          } catch (e) {
            debugPrint('NOTIFICATION WS JSON ERROR: $e');
          }
        },
        onError: (error) {
          debugPrint('NOTIFICATION WS ERROR: $error');
        },
        onDone: () {
          debugPrint('NOTIFICATION WS CLOSED');
          debugPrint('CODE: ${newChannel.closeCode}');
          debugPrint('REASON: ${newChannel.closeReason}');

          if (identical(channel, newChannel)) {
            channel = null;
            _subscription = null;
          }
        },
      );

      await newChannel.ready;

      debugPrint('NOTIFICATION WS CONNECTED SUCCESSFULLY');
    } catch (e, stackTrace) {
      debugPrint('NOTIFICATION WS CONNECTION ERROR: $e');
      debugPrint(stackTrace.toString());

      await disconnect();
    }
  }

  Future<void> disconnect() async {
    debugPrint('NOTIFICATION WS DISCONNECTING');

    final subscription = _subscription;
    final currentChannel = channel;

    _subscription = null;
    channel = null;

    await subscription?.cancel();
    await currentChannel?.sink.close();

    debugPrint('NOTIFICATION WS DISCONNECTED');
  }
}