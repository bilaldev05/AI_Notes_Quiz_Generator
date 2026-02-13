import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:ai_notes_frontend/models/mcq.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/notes_response.dart';

class ApiService {
  static const String baseUrl = "http://localhost:8000"; 
  
  static Future<NotesResponse> uploadAndProcess({
    required String fileName,
    Uint8List? bytes,
    File? file,
  }) async {
    final uri = Uri.parse("$baseUrl/process");
    final request = http.MultipartRequest("POST", uri);

    if (kIsWeb) {
      
      request.files.add(
        http.MultipartFile.fromBytes(
          "file",
          bytes!,
          filename: fileName,
        ),
      );
    } else {
      
      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          file!.path,
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return NotesResponse.fromJson(json.decode(responseBody));
    } else {
      throw Exception("Failed to process file");
    }
  }
  Future<List<MCQ>> fetchQuiz(File file) async {
  final request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/process'),
  );

  request.files.add(
    await http.MultipartFile.fromPath('file', file.path),
  );

  final response = await request.send();
  final responseBody = await response.stream.bytesToString();
  final data = jsonDecode(responseBody);

  
  final List quizList = data['quiz'] as List;

  return quizList
      .map((q) => MCQ.fromJson(q as Map<String, dynamic>))
      .toList();
}

}
