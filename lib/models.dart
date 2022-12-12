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
class FormChoice {
  late String display_name;
  late dynamic value;

  FormChoice({required this.display_name, this.value});
  factory FormChoice.fromJson(Map<String, dynamic> json) =>
      _$FormChoiceFromJson(json);
  Map<String, dynamic> toJson() => _$FormChoiceToJson(this);
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
  late List<FormChoice>? choices;

  FormItemField({
    required this.name,
    required this.type,
    required this.label,
    this.obscure,
    this.placeholder,
    this.url,
    this.multiple = false,
    this.required = false,
    this.read_only = false,
    this.max_length,
  });

  factory FormItemField.fromJson(Map<String, dynamic> json) =>
      _$FormItemFieldFromJson(json);
  Map<String, dynamic> toJson() => _$FormItemFieldToJson(this);
}
