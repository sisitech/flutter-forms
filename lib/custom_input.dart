import 'package:flutter/material.dart';
import 'package:flutter_form/utils.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CounteField extends StatelessWidget {
  /// The value of the Counter
  final int value;

  /// The callback to notify that the user has pressed the increment button.
  final VoidCallback onDecrementPressed;

  /// The callback to notify that the user has pressed the decrement button.
  final VoidCallback onIncrementPressed;

  /// Creates a [Counter] instance.
  /// The [value] of the counter is required and must not by null.
  const CounteField({
    required this.value,
    required this.onDecrementPressed,
    required this.onIncrementPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: onDecrementPressed, // on pressed decrement value
        ),
        Text(value.toString()), // here we will show the value
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: onIncrementPressed, // on pressed increment value
        ),
      ],
    );
  }
}

class ReactiveCounterField extends ReactiveFormField<int, int> {
  ReactiveCounterField({
    required String formControlName,
  }) : super(
            formControlName: formControlName,
            builder: (ReactiveFormFieldState<int, int> field) {
              // make sure never to pass null value to the Counter widget.
              final fieldValue = field.value ?? 0;

              return CounteField(
                value: fieldValue,
                onDecrementPressed: () => field.didChange(fieldValue - 1),
                onIncrementPressed: () => field.didChange(fieldValue + 1),
              );
            });

  @override
  ReactiveFormFieldState<int, int> createState() =>
      ReactiveFormFieldState<int, int>();
}
