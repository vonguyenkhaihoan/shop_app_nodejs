import 'dart:convert';

class Rating {
  final String userId;
  final double rating;
  // final String reviews;

  Rating({
    required this.userId,
    required this.rating,
    // required this.reviews,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rating': rating,
      // 'reviews': reviews,
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      userId: map['userId'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      // reviews: map['reviews'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Rating.fromJson(String source) => Rating.fromMap(json.decode(source));
}



