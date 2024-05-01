import 'package:equatable/equatable.dart';
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

class UserQuote extends Equatable {
  final int id;
  final String quoteContent;
  // final String? authorName;
  // final String? categoryId;
  final bool isLiked;
  final DateTime createdAt;

  const UserQuote({
    required this.id,
    required this.quoteContent,
    required this.isLiked,
    required this.createdAt,
  });

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
    bool? isLiked,
  }) {
    return UserQuote(
      id: id ?? this.id,
      quoteContent: quoteContent ?? this.quoteContent,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [id, quoteContent, isLiked, createdAt];
}
