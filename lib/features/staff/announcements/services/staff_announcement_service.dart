import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../core/api/api_client.dart';
import '../../classrooms/models/staff_classroom_model.dart';
import '../models/staff_announcement_model.dart';

class StaffAnnouncementService {
  static const String endpoint = '/mobile/staff/announcements/';

  static Future<List<StaffAnnouncementModel>> getAnnouncements() async {
    final response = await ApiClient.dio.get(endpoint);
    final data = response.data;

    final List<dynamic> results = data is Map
        ? (data['results'] as List? ?? [])
        : (data as List);

    return results.map((item) {
      return StaffAnnouncementModel.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }

  static Future<List<StaffClassroomModel>> getClassrooms() async {
    final response = await ApiClient.dio.get('/mobile/staff/classrooms/');

    final data = response.data as List;

    return data.map((item) {
      return StaffClassroomModel.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }

  static Future<void> createAnnouncement({
    required String title,
    required String content,
    required String category,
    required String priority,
    required String targetType,
    String? classroomId,
    String? classroomLevelId,
    bool sendNotification = true,
    PlatformFile? attachment,
  }) async {
    final target = <String, dynamic>{'target_type': targetType};

    if (targetType == 'classroom') {
      if (classroomId == null || classroomId.isEmpty) {
        throw Exception('Veuillez sélectionner une classe.');
      }

      target['classroom'] = classroomId;
    } else if (targetType == 'classroom_level') {
      if (classroomLevelId == null || classroomLevelId.isEmpty) {
        throw Exception('Veuillez sélectionner un niveau.');
      }

      target['classroom_level'] = classroomLevelId;
    }

    // Les champs simples du formulaire.
    final fields = <String, dynamic>{
      'title': title.trim(),
      'content': content.trim(),
      'category': category,
      'priority': priority,
      'send_notification': sendNotification.toString(),
    };

    final formData = FormData.fromMap(fields);

    // Envoyer targets comme une chaîne JSON dans un champ multipart.
    // Django devra la convertir en véritable liste avant le serializer.
    formData.fields.add(MapEntry('targets', jsonEncode([target])));

    // Pièce jointe facultative et compatible Web / Android / iOS.
    if (attachment != null) {
      final bytes = attachment.bytes;

      if (bytes == null) {
        throw Exception('Impossible de lire le fichier sélectionné.');
      }

      formData.files.add(
        MapEntry(
          'attachment',
          MultipartFile.fromBytes(bytes, filename: attachment.name),
        ),
      );
    }

    try {
      print('\n========== DEBUG ANNOUNCEMENT ==========');
      print('URL: $endpoint');
      print('TITLE: $title');
      print('CATEGORY: $category');
      print('PRIORITY: $priority');
      print('TARGET: ${jsonEncode([target])}');
      print('ATTACHMENT: ${attachment?.name ?? "Aucune pièce jointe"}');
      print('FIELDS: ${formData.fields.map((e) => e.key).toList()}');

      final response = await ApiClient.dio.post(
        endpoint,
        data: formData,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      print('========== ANNOUNCEMENT SUCCESS ==========');
      print('STATUS: ${response.statusCode}');
      print('RESPONSE: ${response.data}');
      print('==========================================\n');
    } on DioException catch (e) {
      print('\n========== DIO ERROR ==========');
      print('TYPE: ${e.type}');
      print('MESSAGE: ${e.message}');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      print('URL: ${e.requestOptions.uri}');
      print('METHOD: ${e.requestOptions.method}');
      print('================================\n');

      rethrow;
    } catch (e, stackTrace) {
      print('\n========== GENERAL ERROR ==========');
      print('ERROR: $e');
      print('STACKTRACE: $stackTrace');
      print('===================================\n');

      rethrow;
    }
  }
}
