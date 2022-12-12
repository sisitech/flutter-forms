import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

enum FieldType {
  integer,
  string,
  text,
  datetime,
  date,
  time,
  field,
  multifield,
  boolean,
  email,
  file
}

@JsonSerializable()
class FormItemField {
  late String name;
  late String label;
  late String? placeholder;
  late FieldType type;
  late bool required;
  late bool read_only;
  late int? max_length;
  late String? url;
  late bool? obscure;
  late bool? multiple;

  FormItemField({
    required this.name,
    required this.type,
    this.required = false,
    this.read_only = false,
    this.max_length,
  });

  factory FormItemField.fromJson(Map<String, dynamic> json) =>
      _$FormItemFieldFromJson(json);
  Map<String, dynamic> toJson() => _$FormItemFieldToJson(this);
}
