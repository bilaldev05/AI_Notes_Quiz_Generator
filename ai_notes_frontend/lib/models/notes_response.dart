class NotesResponse {
  final String summary;
  final List<String> bullets;
  final String quiz;

  NotesResponse({
    required this.summary,
    required this.bullets,
    required this.quiz,
  });

  factory NotesResponse.fromJson(Map<String, dynamic> json) {
    return NotesResponse(
      summary: json['summary'],
      bullets: List<String>.from(json['bullets']),
      quiz: json['quiz'],
    );
  }
}
