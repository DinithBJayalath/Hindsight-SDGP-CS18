class BreathingSession {
  final String? id;
  final String userId;
  final int duration;
  final String? audioRecording;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BreathingSession({
    this.id,
    required this.userId,
    required this.duration,
    this.audioRecording,
    this.createdAt,
    this.updatedAt,
  });

  factory BreathingSession.fromJson(Map<String, dynamic> json) {
    return BreathingSession(
      id: json['_id'],
      userId: json['userId'],
      duration: json['duration'],
      audioRecording: json['audioRecording'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'userId': userId,
      'duration': duration,
    };

    if (audioRecording != null) {
      data['audioRecording'] = audioRecording;
    }

    return data;
  }
}
