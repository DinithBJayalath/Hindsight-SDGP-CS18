class Drawing {
  final String? id;
  final String title;
  final String imageData;
  final String userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Drawing({
    this.id,
    required this.title,
    required this.imageData,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Drawing.fromJson(Map<String, dynamic> json) {
    return Drawing(
      id: json['_id'],
      title: json['title'],
      imageData: json['imageData'],
      userId: json['userId'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageData': imageData,
      'userId': userId,
    };
  }
}
