class Letter {
  final String? id;
  final String title;
  final String content;
  final String userId;
  final DateTime? deliveryDate;
  final bool isDelivered;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Letter({
    this.id,
    required this.title,
    required this.content,
    required this.userId,
    this.deliveryDate,
    this.isDelivered = false,
    this.createdAt,
    this.updatedAt,
  });

  factory Letter.fromJson(Map<String, dynamic> json) {
    return Letter(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      userId: json['userId'],
      deliveryDate: json['deliveryDate'] != null
          ? DateTime.parse(json['deliveryDate'])
          : null,
      isDelivered: json['isDelivered'] ?? false,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'title': title,
      'content': content,
      'userId': userId,
    };

    if (deliveryDate != null) {
      data['deliveryDate'] = deliveryDate!.toIso8601String();
    }

    return data;
  }
}
