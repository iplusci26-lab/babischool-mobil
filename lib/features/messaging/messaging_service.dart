import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../messaging/models/attachment_model.dart';


class MessagingService {

  Future<List<dynamic>>
  getConversations() async {

    final response =

    await ApiClient.dio.get(
      "/messaging/conversations/",
    );

    print("donee----------- ${response.data}");

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
    print(response.data);
    return response.data;
  }


  Future<void> sendMessage({

  required String conversationId,

  required String body,

  AttachmentModel? attachment,

}) async {

  final formData = FormData.fromMap({
    "conversation_id":conversationId,
    "body":body,
  
  if(attachment != null) 
    "attachment": await attachment.toMultipart(),
});
  await ApiClient.dio.post(

    "/messaging/send/",

    data:formData,
  );
}

}