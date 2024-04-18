import 'package:flutter/material.dart';

Text textLarge25(String text,
    {TextAlign textAlign = TextAlign.start, Color color = Colors.white}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      fontSize: 25,
      color: color,
      fontWeight: FontWeight.bold,
    ),
  );
}

Text textLarge20(String text,
    {TextAlign textAlign = TextAlign.start, Color color = Colors.white}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      fontSize: 25,
      color: color,
      fontWeight: FontWeight.bold,
    ),
  );
}

Text textMedium18(String text,
    {TextAlign textAlign = TextAlign.start, Color color = Colors.white}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      fontSize: 18,
      color: color,
      fontWeight: FontWeight.normal,
    ),
  );
}

Text textSmall16(String text,
    {TextAlign textAlign = TextAlign.start, Color color = Colors.white}) {
  return Text(
    text,
    textAlign: textAlign,
    style: TextStyle(
      fontSize: 16,
      color: color,
      fontWeight: FontWeight.normal,
    ),
  );
}
