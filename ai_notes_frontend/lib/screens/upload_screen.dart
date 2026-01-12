import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import 'result_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? selectedFile;
  Uint8List? selectedBytes;
  String? fileName;
  bool loading = false;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'pptx'],
      withData: true, 
    );

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
        selectedBytes = result.files.single.bytes;

        if (!kIsWeb) {
          selectedFile = File(result.files.single.path!);
        }
      });
    }
  }

  Future<void> processFile() async {
    if (fileName == null) return;

    setState(() => loading = true);

    try {
      final result = await ApiService.uploadAndProcess(
        fileName: fileName!,
        bytes: selectedBytes,
        file: selectedFile,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(result: result),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Notes Generator")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: pickFile,
              icon: const Icon(Icons.upload_file),
              label: const Text("Select PDF / PPT"),
            ),
            const SizedBox(height: 20),
            if (fileName != null)
              Text(
                fileName!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            const Spacer(),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: processFile,
                    child: const Text("Generate Notes"),
                  ),
          ],
        ),
      ),
    );
  }
}
