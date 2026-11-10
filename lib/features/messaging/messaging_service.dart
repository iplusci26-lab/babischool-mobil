
import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../messaging/models/attachment_model.dart';

class MessagingService {
  /// Récupérer toutes les conversations de l'utilisateur connecté.
  Future<List<dynamic>> getConversations() async {
    final response = await ApiClient.dio.get(
      "/messaging/conversations/",
    );

    final data = response.data;

    if (data is List) {
      return data;
    }

    // Support d'une réponse paginée DRF.
    if (data is Map && data["results"] is List) {
      return data["results"];
    }

    throw Exception(
      "Format de réponse invalide pour la liste des conversations.",
    );
  }

  /// Récupérer les détails d'une conversation.
  Future<Map<String, dynamic>> getConversation(String id) async {
    final response = await ApiClient.dio.get(
      "/messaging/conversations/$id/",
    );

    return Map<String, dynamic>.from(response.data);
  }

  /// Récupérer les destinataires disponibles.
  Future<List<dynamic>> getRecipients() async {
    final response = await ApiClient.dio.get(
      "/messaging/recipients/",
    );

    final data = response.data;

    if (data is List) {
      return data;
    }

    if (data is Map && data["results"] is List) {
      return data["results"];
    }

    throw Exception(
      "Format de réponse invalide pour les destinataires.",
    );
  }

  /// Démarrer une conversation.
  Future<String> startConversation({
    required String recipientId,
  }) async {
    final response = await ApiClient.dio.post(
      "/messaging/start/",
      data: {
        "recipient_id": recipientId,
      },
    );

    return response.data["conversation_id"].toString();
  }

  /// Envoyer un message.
  Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String body,
    AttachmentModel? attachment,
  }) async {
    final formData = FormData.fromMap({
      "conversation_id": conversationId,
      "body": body,
      if (attachment != null)
        "attachment": await attachment.toMultipart(),
    });

    final response = await ApiClient.dio.post(
      "/messaging/send/",
      data: formData,
    );

    return Map<String, dynamic>.from(response.data);
  }
}
