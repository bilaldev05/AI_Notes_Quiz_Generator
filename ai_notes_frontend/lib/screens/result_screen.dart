import 'package:ai_notes_frontend/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import '../models/notes_response.dart';
import '../models/mcq.dart';

class ResultScreen extends StatelessWidget {
  final NotesResponse result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Study Material")),
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
            const Divider(height: 32),

            /// NOTES
            const Text(
              "📝 Study Notes",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(result.notes),
            const Divider(height: 32),

            /// QUIZ BUTTON
            ElevatedButton(
              onPressed: result.quiz.isEmpty
                  ? null
                  : () {
                      final mcqs = result.quiz
                          .map((e) => MCQ.fromJson(e))
                          .toList();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(mcqs: mcqs),
                        ),
                      );
                    },
              child: const Text("Start Quiz"),
            ),
          ],
        ),
      ),
    );
  }
}
