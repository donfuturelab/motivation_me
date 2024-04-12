class DefaultQuote {
  final int id;
  final String quoteContent;
  final int? authorId;
  final String? authorName;
  // DateTime createdAt;
  final int categoryId;
  final bool isLiked;

  DefaultQuote(
      {required this.id,
      required this.quoteContent,
      this.authorId,
      this.authorName,
      // required this.createdAt,
      required this.categoryId,
      required this.isLiked});

  factory DefaultQuote.fromMap(Map<String, dynamic> map) {
    return DefaultQuote(
        id: map['id'],
        quoteContent: map['quote_content'],
        authorId: map['author_id'],
        authorName: map['author_name'],
        // createdAt: DateTime.parse(map['created_at']),
        categoryId: map['category_id'],
        isLiked: map['is_liked'] == 1);
  }

  //create copywith to update new quote
  DefaultQuote copyWith({
    int? id,
    String? quoteContent,
    int? authorId,
    String? authorName,
    // DateTime createdAt;
    bool? isCreatedByUser,
    int? categoryId,
    bool? isLiked,
  }) {
    return DefaultQuote(
        id: id ?? this.id,
        quoteContent: quoteContent ?? this.quoteContent,
        categoryId: categoryId ?? this.categoryId,
        isLiked: isLiked ?? this.isLiked);
  }
}
