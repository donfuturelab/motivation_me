import 'package:get/get.dart';

class UserQuoteMap {
  String quoteContent;

  UserQuoteMap({
    required this.quoteContent,
    // this.authorName,
    // this.categoryName,
  });

  Map<String, dynamic> toMap() {
    return {
      'quote_content': quoteContent,
      'created_at': DateTime.now().toIso8601String(),
    };
  }
}

class UserQuote {
  final int id;
  final String quoteContent;
  // final String? authorName;
  // final String? categoryId;
  final RxBool isLiked;
  final DateTime createdAt;

  UserQuote({
    required this.id,
    required this.quoteContent,
    bool isLiked = false,
    required this.createdAt,
  }) : isLiked = RxBool(isLiked);

  factory UserQuote.fromMap(Map<String, dynamic> map) {
    return UserQuote(
      id: map['id'],
      quoteContent: map['quote_content'],
      isLiked: map['is_liked'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }
  UserQuote copyWith({
    int? id,
    String? quoteContent,
    DateTime? createdAt,
  }) {
    return UserQuote(
      id: id ?? this.id,
      quoteContent: quoteContent ?? this.quoteContent,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
