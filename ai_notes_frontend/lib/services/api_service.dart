import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/notes_response.dart';

class ApiService {
  static const String baseUrl = "http://localhost:8000"; 
  // For Android emulator use: http://10.0.2.2:8000

  static Future<NotesResponse> uploadAndProcess({
    required String fileName,
    Uint8List? bytes,
    File? file,
  }) async {
    final uri = Uri.parse("$baseUrl/process");
    final request = http.MultipartRequest("POST", uri);

    if (kIsWeb) {
      // ✅ Flutter Web
      request.files.add(
        http.MultipartFile.fromBytes(
          "file",
          bytes!,
          filename: fileName,
        ),
      );
    } else {
      // ✅ Mobile / Desktop
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
}
