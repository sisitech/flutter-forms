import 'package:flutter/material.dart';

class SisitechMultiSelectTheme
    extends ThemeExtension<SisitechMultiSelectTheme> {
  final Color? backgroundColor;
  final Color? labelColor;
  final Color? choiceWidgetTextColor;
  final Color? choiceWidgetBackgroundColor;
  final Color? selectedChoiceWidgetTextColor;
  final Color? selectedChoiceWidgetBackgroundColor;

  const SisitechMultiSelectTheme({
    this.backgroundColor,
    this.labelColor,
    this.choiceWidgetTextColor,
    this.choiceWidgetBackgroundColor,
    this.selectedChoiceWidgetTextColor,
    this.selectedChoiceWidgetBackgroundColor,
  });

  @override
  SisitechMultiSelectTheme copyWith({
    Color? backgroundColor,
    Color? labelColor,
    Color? choiceWidgetTextColor,
    Color? choiceWidgetBackgroundColor,
    Color? selectedChoiceWidgetTextColor,
    Color? selectedChoiceWidgetBackgroundColor,
  }) {
    return SisitechMultiSelectTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      labelColor: labelColor ?? this.labelColor,
      choiceWidgetTextColor:
          choiceWidgetTextColor ?? this.choiceWidgetTextColor,
      choiceWidgetBackgroundColor:
          choiceWidgetBackgroundColor ?? this.choiceWidgetBackgroundColor,
      selectedChoiceWidgetTextColor:
          selectedChoiceWidgetTextColor ?? this.selectedChoiceWidgetTextColor,
      selectedChoiceWidgetBackgroundColor:
          selectedChoiceWidgetBackgroundColor ??
              this.selectedChoiceWidgetBackgroundColor,
    );
  }

  @override
  SisitechMultiSelectTheme lerp(
      ThemeExtension<SisitechMultiSelectTheme>? other, double t) {
    if (other is! SisitechMultiSelectTheme) {
      return this;
    }
    return SisitechMultiSelectTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      labelColor: Color.lerp(labelColor, other.labelColor, t),
      choiceWidgetTextColor:
          Color.lerp(choiceWidgetTextColor, other.choiceWidgetTextColor, t),
      choiceWidgetBackgroundColor: Color.lerp(
          choiceWidgetBackgroundColor, other.choiceWidgetBackgroundColor, t),
      selectedChoiceWidgetTextColor: Color.lerp(selectedChoiceWidgetTextColor,
          other.selectedChoiceWidgetTextColor, t),
      selectedChoiceWidgetBackgroundColor: Color.lerp(
          selectedChoiceWidgetBackgroundColor,
          other.selectedChoiceWidgetBackgroundColor,
          t),
    );
  }
}
