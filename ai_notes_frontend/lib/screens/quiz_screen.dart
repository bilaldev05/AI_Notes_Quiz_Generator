import 'package:flutter/material.dart';
import '../models/mcq.dart';

class QuizScreen extends StatefulWidget {
  final List<MCQ> mcqs;

  const QuizScreen({super.key, required this.mcqs});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int current = 0;
  int? selected;
  int score = 0;
  bool answered = false;

  void next() {
    if (!answered) return;

    if (selected == widget.mcqs[current].correctIndex) {
      score++;
    }

    setState(() {
      selected = null;
      answered = false;
      current++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mcqs.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No quiz available")),
      );
    }

    if (current >= widget.mcqs.length) {
      return Scaffold(
        appBar: AppBar(title: const Text("Quiz Result")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Your Score",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                "$score / ${widget.mcqs.length}",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final mcq = widget.mcqs[current];

    return Scaffold(
      appBar: AppBar(
        title: Text("Question ${current + 1}/${widget.mcqs.length}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mcq.question,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            ...List.generate(mcq.options.length, (i) {
              final isSelected = selected == i;
              final isCorrect = i == mcq.correctIndex;

              Color color = Colors.grey.shade200;
              if (answered) {
                if (isCorrect) {
                  color = Colors.green.shade300;
                } else if (isSelected) {
                  color = Colors.red.shade300;
                }
              }

              return Card(
                color: color,
                child: ListTile(
                  title: Text(mcq.options[i]),
                  onTap: answered
                      ? null
                      : () {
                          setState(() {
                            selected = i;
                            answered = true;
                          });
                        },
                ),
              );
            }),

            const SizedBox(height: 12),

            if (answered)
              Text(
                selected == mcq.correctIndex
                    ? "✅ Correct!"
                    : "❌ Correct answer: ${mcq.options[mcq.correctIndex]}",
                style: const TextStyle(fontSize: 16),
              ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: answered ? next : null,
                child: Text(
                  current == widget.mcqs.length - 1
                      ? "Finish"
                      : "Next",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
