import 'package:equatable/equatable.dart';

import 'enums/category.dart';

class QuoteCategory extends Equatable {
  final int id;
  final String name;

  final CategoryType type;
  final bool isSelected;

  const QuoteCategory(
      {required this.id,
      required this.name,
      required this.type,
      this.isSelected = false});

  factory QuoteCategory.fromMap(Map<String, dynamic> json) {
    return QuoteCategory(
      id: json['id'],
      name: (json['category_name'] as String)[0].toUpperCase() +
          (json['category_name'] as String).substring(1),
      // tag: json['category_tag'],
      type: categoryTypeFromString(json['category_type']),
    );
  }

  factory QuoteCategory.fromMapWithSelected(
      Map<String, dynamic> json, int selectedCategoryId) {
    return QuoteCategory(
      id: json['id'],
      name: (json['category_name'] as String)[0].toUpperCase() +
          (json['category_name'] as String).substring(1),
      // tag: json['category_tag'],
      type: categoryTypeFromString(json['category_type']),
      isSelected: json['id'] == selectedCategoryId ? true : false,
    );
  }

  //create function for copyWith
  QuoteCategory copyWith({
    int? id,
    String? name,
    String? tag,
    CategoryType? type,
    bool? isSelected,
  }) {
    return QuoteCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [id, name, type, isSelected];
}
