import '../../core/api/api_client.dart';
import 'dart:io';

import 'package:dio/dio.dart';

class MessagingService {

  Future<List<dynamic>>
  getConversations() async {

    final response =

    await ApiClient.dio.get(
      "/messaging/conversations/",
    );

    return response.data;
  }

  Future<Map<String,dynamic>>
  getConversation(
    String id,
  ) async {

    final response =

    await ApiClient.dio.get(
      "/messaging/conversations/$id/",
    );

    return response.data;
  }


  Future<void> sendMessage({

  required String conversationId,

  required String body,
  File? attachment,

}) async {

  final formData = FormData.fromMap({
    "conversation_id":conversationId,
    "body":body,
  
  if(attachment != null) 
    "attachment":
    await MultipartFile.fromFile(
      attachment.path,
    ),
});
  await ApiClient.dio.post(

    "/messaging/send/",

    data:formData,
  );
}

}