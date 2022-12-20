import 'package:flutter/material.dart';
import 'package:flutter_form/custom_input.dart';
import 'package:flutter_form/utils.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomFieldForm extends StatefulWidget {
  const CustomFieldForm({super.key});

  @override
  State<CustomFieldForm> createState() => _CustomFieldFormState();
}

class _CustomFieldFormState extends State<CustomFieldForm> {
  final form = FormGroup({
    'counter': FormControl<int>(value: 2),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ReactiveForm(
        formGroup: this.form,
        child: Column(
          children: [
            ReactiveValueListenableBuilder<int>(
                formControlName: 'counter',
                builder: (context, control, child) {
                  return Text(
                      control.isNotNull ? control.value.toString() : '0');
                }),
            ReactiveCounterField(
              formControlName: "counter",
            ),
          ],
        ),
      ),
    );
  }
}
