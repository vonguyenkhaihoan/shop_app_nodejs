// import 'dart:convert';

// class Category {
//   /// Tên của danh mục.
//   final String name;

//   /// Mô tả của danh mục.
//   final String description;

//   /// Ngày tạo danh mục.
//   final DateTime createdAt;

//   /// Tạo đối tượng `Category`.
//   ///
//   /// **Lưu ý:** Tất cả các thuộc tính đều bắt buộc.
//   Category({
//     required this.name,
//     required this.description,
//     required this.createdAt,
//   });

//   /// Chuyển đổi đối tượng `Category` sang định dạng map.
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'description': description,
//       'createdAt': createdAt,
//     };
//   }

//   /// Chuyển đổi định dạng map sang đối tượng `Category`.
//   ///
//   /// **Lưu ý:** Phương thức này ghi đè phương thức `fromMap()` của lớp `Object`.
//   factory Category.fromMap(Map<String, dynamic> map) {
//     return Category(
//       name: map['name'],
//       description: map['description'],
//       createdAt: DateTime.parse(map['createdAt']),
//     );
//   }

//   /// Chuyển đổi đối tượng `Category` sang định dạng JSON.
//   String toJson() => json.encode(toMap());

//   /// Chuyển đổi định dạng JSON sang đối tượng `Category`.
//   ///
//   /// **Lưu ý:** Phương thức này ghi đè phương thức `fromJson()` của lớp `Object`.
//   factory Category.fromJson(String source) =>
//       Category.fromMap(json.decode(source));
// }

import 'dart:convert';

class Category {
  /// ID của danh mục.
  final String id;

  /// Tên của danh mục.
  final String name;

  /// Mô tả của danh mục.
  final String description;

  /// Ngày tạo danh mục.
  final DateTime createdAt;

  /// Tạo đối tượng `Category`.
  ///
  /// **Lưu ý:** `id` là tùy chọn và có thể là `null`.
  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  /// Chuyển đổi đối tượng `Category` sang định dạng map.
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Chuyển đổi định dạng map sang đối tượng `Category`.
  ///
  /// **Lưu ý:** Phương thức này ghi đè phương thức `fromMap()` của lớp `Object`.
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['_id'],
      name: map['name'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  /// Chuyển đổi đối tượng `Category` sang định dạng JSON.
  String toJson() => json.encode(toMap());

  /// Chuyển đổi định dạng JSON sang đối tượng `Category`.
  ///
  /// **Lưu ý:** Phương thức này ghi đè phương thức `fromJson()` của lớp `Object`.
  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));
}
