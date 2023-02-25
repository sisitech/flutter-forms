library flutter_form;

import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

enum ContentType {
  json,
  form_url_encoded,
}

enum FormStatus { Add, Update }

extension FormStatusDefinti on FormStatus {
  String statusDisplay() {
    return toString().replaceAll("FormStatus.", "");
  }
}

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
  file,
  choice,
  float
}

@JsonSerializable()
class FormChoice {
  late String display_name;
  late dynamic value;

  FormChoice({required this.display_name, this.value});

  factory FormChoice.fromJson(Map<String, dynamic> json) =>
      _$FormChoiceFromJson(json);
  Map<String, dynamic> toJson() => _$FormChoiceToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "$value";
  }
}

class FormUrlChoices {
  String? url;
  String? storage;
  String? from_field_source;
  late String? instance_url;
  late bool? multiple;
  late String display_name;
  late String search_field;
  late String value_field;
  late List<FormChoice>? choices;
  late bool select_first;

  getInstanceUrl() {
    if (instance_url != null) return instance_url;
    return url;
  }

  FormUrlChoices(
      {this.url,
      this.display_name = "name",
      this.value_field = "id",
      this.search_field = "",
      this.instance_url,
      this.from_field_source,
      this.storage,
      this.select_first = false,
      this.multiple = false});
}

@JsonSerializable()
class FormItemField extends FormUrlChoices {
  late String name;
  late String label;
  late String? placeholder;
  late FieldType type;
  late bool required;
  late bool read_only;
  late int? max_length;
  late bool? obscure;
  late String? from_field;
  late dynamic? show_only;
  late String? show_only_field;
  late bool? show_reset_value;
  bool hasController;

  FormItemField(
      {required this.name,
      required this.type,
      required this.label,
      this.obscure = false,
      this.placeholder,
      this.required = false,
      this.read_only = false,
      this.max_length,
      this.show_only,
      this.from_field,
      this.hasController = false,
      this.show_only_field,
      this.show_reset_value,
      super.from_field_source,
      super.storage,
      super.instance_url,
      super.url,
      super.display_name = "name",
      super.search_field = "name",
      super.value_field = "id",
      super.select_first = false,
      super.multiple = false});

  // this.url,
  // this.display_name = "name",
  // this.value_field = "id",
  // this.multiple = false
  factory FormItemField.fromJson(Map<String, dynamic> json) =>
      _$FormItemFieldFromJson(json);
  Map<String, dynamic> toJson() => _$FormItemFieldToJson(this);
}
