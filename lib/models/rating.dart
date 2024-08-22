import 'dart:convert';

class RatingModel {
  final String userId;
  final double rating;
  final String comment;
  RatingModel({
    required this.userId,
    required this.rating,
    required this.comment,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rating': rating,
      'comment': comment,
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      userId: map['userId'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      comment: map['comment'] ?? '',
    );
  }


  String toJson() => json.encode(toMap());

  factory RatingModel.fromJson(String source) => RatingModel.fromMap(json.decode(source));
}
