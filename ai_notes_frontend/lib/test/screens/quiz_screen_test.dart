import 'package:ai_notes_frontend/models/mcq.dart';
import 'package:ai_notes_frontend/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  final mockMcqs = [
    MCQ(
      question: "Capital of Pakistan?",
      options: ["Lahore", "Islamabad", "Karachi", "Peshawar"],
      correctIndex: 1,
    ),
    MCQ(
      question: "2 + 2 = ?",
      options: ["3", "4", "5", "6"],
      correctIndex: 1,
    ),
  ];

  Widget createWidget(List<MCQ> mcqs) {
    return MaterialApp(
      home: QuizScreen(mcqs: mcqs),
    );
  }

  testWidgets("Shows message when quiz is empty", (tester) async {
    await tester.pumpWidget(createWidget([]));
    expect(find.text("No quiz available"), findsOneWidget);
  });

  testWidgets("Displays first question and options", (tester) async {
    await tester.pumpWidget(createWidget(mockMcqs));
    expect(find.text("Capital of Pakistan?"), findsOneWidget);
    expect(find.text("Islamabad"), findsOneWidget);
  });

  testWidgets("Shows Correct when right option is tapped", (tester) async {
    await tester.pumpWidget(createWidget(mockMcqs));
    await tester.tap(find.text("Islamabad"));
    await tester.pump();
    expect(find.text("✅ Correct!"), findsOneWidget);
  });

  testWidgets("Moves to next question", (tester) async {
    await tester.pumpWidget(createWidget(mockMcqs));
    await tester.tap(find.text("Islamabad"));
    await tester.pump();
    await tester.tap(find.text("Next"));
    await tester.pump();
    expect(find.text("2 + 2 = ?"), findsOneWidget);
  });

  testWidgets("Completes quiz and shows result", (tester) async {
    await tester.pumpWidget(createWidget(mockMcqs));

    await tester.tap(find.text("Islamabad"));
    await tester.pump();
    await tester.tap(find.text("Next"));
    await tester.pump();

    await tester.tap(find.text("4"));
    await tester.pump();
    await tester.tap(find.text("Finish"));
    await tester.pumpAndSettle();

    expect(find.text("Quiz Result"), findsOneWidget);
    expect(find.text("2 / 2"), findsOneWidget);
  });
}
