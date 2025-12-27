import 'package:flutter/material.dart';
import '../models/notes_response.dart';

class ResultScreen extends StatelessWidget {
  final NotesResponse result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Study Notes")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// SUMMARY
            const Text(
              "📌 Summary",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(result.summary),
            const Divider(),

            /// BULLETS
            const Text(
              "📝 Key Points",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...result.bullets.map(
              (e) => ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: Text(e),
              ),
            ),
            const Divider(),

            /// QUIZ
            const Text(
              "❓ Quiz",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(result.quiz),
          ],
        ),
      ),
    );
  }
}
 