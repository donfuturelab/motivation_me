import 'package:equatable/equatable.dart';

class Collection extends Equatable {
  final int id;
  final String name;
  final int quoteCount;

  const Collection(
      {required this.id, required this.name, required this.quoteCount});

  // Create a Collection from JSON data
  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
      id: map['id'] as int,
      name: map['collection_name'] as String,
      quoteCount: map['quote_count'] as int,
    );
  }

  Collection copyWith({
    int? id,
    String? name,
    int? quoteCount,
  }) {
    return Collection(
      id: id ?? this.id,
      name: name ?? this.name,
      quoteCount: quoteCount ?? this.quoteCount,
    );
  }

  @override
  List<Object?> get props => [id, name, quoteCount];
}
