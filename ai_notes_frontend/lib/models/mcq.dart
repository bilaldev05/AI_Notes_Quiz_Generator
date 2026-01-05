class MCQ {
  final String question;
  final List<String> options;
  final int correctIndex;

  MCQ({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  factory MCQ.fromJson(Map<String, dynamic> json) {
    return MCQ(
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctIndex: json['correctIndex'] ?? 0,
    );
  }
}
