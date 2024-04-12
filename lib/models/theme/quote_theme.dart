import 'package:get/get.dart';

import '../enums/theme.dart';

class QuoteTheme {
  final int themeID;
  final String imageCode;
  final String fontFamily;
  final String fontColor;
  final int? fontSize;
  final String? shadowColor;
  final ThemeType themeType;
  final RxBool isSelected;

  QuoteTheme({
    required this.themeID,
    required this.imageCode,
    required this.fontFamily,
    required this.fontColor,
    this.fontSize,
    this.shadowColor,
    required this.themeType,
    bool isSelected =
        false, //cai nay khong can dung this vi no khong phai la isSelected cua class nay
  }) : isSelected = RxBool(
            isSelected); //this is argument so using initializing function to convert to RxBool

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

  factory QuoteTheme.fromMap(Map<String, dynamic> map) {
    return QuoteTheme(
      themeID: map['id'],
      imageCode: map['image_code'],
      fontFamily: map['font_family'],
      fontColor: map['font_color'],
      fontSize: map['font_size'],
      shadowColor: map['shadow_color'],
      themeType: stringToThemeType(map['theme_type'] ?? 'free'),
    );
  }

  //create function for copyWith
  QuoteTheme copyWith({
    int? themeID,
    String? imageCode,
    String? fontFamily,
    String? fontColor,
    int? fontSize,
    String? shadowColor,
    ThemeType? themeType,
    bool? isSelected,
  }) {
    return QuoteTheme(
      themeID: themeID ?? this.themeID,
      imageCode: imageCode ?? this.imageCode,
      fontFamily: fontFamily ?? this.fontFamily,
      fontColor: fontColor ?? this.fontColor,
      fontSize: fontSize ?? this.fontSize,
      shadowColor: shadowColor ?? this.shadowColor,
      themeType: themeType ?? this.themeType,
      isSelected: isSelected ?? this.isSelected.value,
    );
  }
}
