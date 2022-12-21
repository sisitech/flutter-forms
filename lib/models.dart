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
  file
}

class APIConfig {
  late String apiEndpoint;
  late String version;
  late String clientId;
  late String? tokenUrl;
  late String? profileUrl;
  late String? revokeTokenUrl;
  late String? grantType;

  APIConfig({
    required this.apiEndpoint,
    required this.clientId,
    this.version = "api/v1",
    this.tokenUrl = "auth/token/",
    this.revokeTokenUrl = "auth/revoke-token/",
    this.profileUrl = "api/v1/users/me/",
    this.grantType = "password",
  });

  @override
  String toString() {
    // TODO: implement toString
    return "${apiEndpoint} ${version} ${tokenUrl}";
  }
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
  late String? url;
  late bool? multiple;
  late String display_name;
  late String search_field;
  late String value_field;
  late List<FormChoice>? choices;
  FormUrlChoices(
      {this.url,
      this.display_name = "name",
      this.value_field = "id",
      this.search_field = "",
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

  FormItemField(
      {required this.name,
      required this.type,
      required this.label,
      this.obscure = false,
      this.placeholder,
      this.required = false,
      this.read_only = false,
      this.max_length,
      super.url,
      super.display_name = "name",
      super.search_field = "name",
      super.value_field = "id",
      super.multiple = false});

  // this.url,
  // this.display_name = "name",
  // this.value_field = "id",
  // this.multiple = false
  factory FormItemField.fromJson(Map<String, dynamic> json) =>
      _$FormItemFieldFromJson(json);
  Map<String, dynamic> toJson() => _$FormItemFieldToJson(this);
}
