class NotesResponse {
  final String summary;
  final String notes;
  final List<dynamic> quiz;

  NotesResponse({
    required this.summary,
    required this.notes,
    required this.quiz,
  });

  factory NotesResponse.fromJson(Map<String, dynamic> json) {
    return NotesResponse(
      summary: json['summary'] ?? '',
      notes: json['notes'] ?? '',
      quiz: json['quiz'] ?? [],
    );
  }
}
