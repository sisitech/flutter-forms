// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormItemField _$FormItemFieldFromJson(Map<String, dynamic> json) =>
    FormItemField(
      name: json['name'] as String,
      type: json['type'] as String,
      required: json['required'] as bool? ?? false,
      read_only: json['read_only'] as bool? ?? false,
      max_length: json['max_length'] as int?,
    )
      ..label = json['label'] as String
      ..placeholder = json['placeholder'] as String?
      ..url = json['url'] as String?;

Map<String, dynamic> _$FormItemFieldToJson(FormItemField instance) =>
    <String, dynamic>{
      'name': instance.name,
      'label': instance.label,
      'placeholder': instance.placeholder,
      'type': instance.type,
      'required': instance.required,
      'read_only': instance.read_only,
      'max_length': instance.max_length,
      'url': instance.url,
    };
