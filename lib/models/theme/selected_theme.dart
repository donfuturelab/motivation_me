import 'package:equatable/equatable.dart';

import '../enums/theme.dart';
import 'quote_theme.dart';

class SelectedTheme extends Equatable {
  final int themeID;
  final String imageCode;
  final String fontFamily;
  final String fontColor;
  final int? fontSize;
  final String? shadowColor;
  // final ThemeType themeType;

  const SelectedTheme(
      {required this.themeID,
      // required this.themeType,
      required this.fontFamily,
      required this.fontColor,
      this.fontSize,
      this.shadowColor,
      required this.imageCode});

  SelectedTheme copyWith({
    int? themeID,
    String? imageCode,
    String? fontFamily,
    String? fontColor,
    int? fontSize,
    String? shadowColor,
    ThemeType? themeType,
  }) {
    return SelectedTheme(
      themeID: themeID ?? this.themeID,
      imageCode: imageCode ?? this.imageCode,
      fontFamily: fontFamily ?? this.fontFamily,
      fontColor: fontColor ?? this.fontColor,
      fontSize: fontSize ?? this.fontSize,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': themeID,
      'image_code': imageCode,
      'font_family': fontFamily,
      'font_color': fontColor,
      'font_size': fontSize,
      'shadow_color': shadowColor,
    };
  }

  factory SelectedTheme.fromMap(Map<String, dynamic> map) {
    return SelectedTheme(
      themeID: map['id'],
      imageCode: map['image_code'],
      fontFamily: map['font_family'],
      fontColor: map['font_color'],
      fontSize: map['font_size'],
      shadowColor: map['shadow_color'],
    );
  }

  //convert QuoteThem to SelectedTheme
  factory SelectedTheme.fromQuoteTheme(QuoteTheme quoteTheme) {
    return SelectedTheme(
      themeID: quoteTheme.themeID,
      imageCode: quoteTheme.imageCode,
      fontFamily: quoteTheme.fontFamily,
      fontColor: quoteTheme.fontColor,
      fontSize: quoteTheme.fontSize,
      shadowColor: quoteTheme.shadowColor,
    );
  }

  @override
  List<Object?> get props => [
        themeID,
        fontFamily,
        fontColor,
        fontSize,
        shadowColor,
        imageCode,
      ];
}
