// GENERATED CODE - DO NOT MODIFY BY HAND

part of flutter_form;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormChoice _$FormChoiceFromJson(Map<String, dynamic> json) => FormChoice(
      display_name: json['display_name'] as String,
      value: json['value'],
    );

Map<String, dynamic> _$FormChoiceToJson(FormChoice instance) =>
    <String, dynamic>{
      'display_name': instance.display_name,
      'value': instance.value,
    };

FormItemField _$FormItemFieldFromJson(Map<String, dynamic> json) =>
    FormItemField(
      name: json['name'] as String,
      type: $enumDecode(_$FieldTypeEnumMap, json['type']),
      label: json['label'] as String,
      obscure: json['obscure'] as bool? ?? false,
      placeholder: json['placeholder'] as String?,
      required: json['required'] as bool? ?? false,
      read_only: json['read_only'] as bool? ?? false,
      max_length: json['max_length'] as int?,
      url: json['url'] as String?,
      display_name: json['display_name'] as String? ?? "name",
      search_field: json['search_field'] as String? ?? "name",
      value_field: json['value_field'] as String? ?? "id",
      select_first: json['select_first'] as bool? ?? false,
      multiple: json['multiple'] as bool? ?? false,
    )..choices = (json['choices'] as List<dynamic>?)
        ?.map((e) => FormChoice.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$FormItemFieldToJson(FormItemField instance) =>
    <String, dynamic>{
      'url': instance.url,
      'multiple': instance.multiple,
      'display_name': instance.display_name,
      'search_field': instance.search_field,
      'value_field': instance.value_field,
      'choices': instance.choices,
      'select_first': instance.select_first,
      'name': instance.name,
      'label': instance.label,
      'placeholder': instance.placeholder,
      'type': _$FieldTypeEnumMap[instance.type]!,
      'required': instance.required,
      'read_only': instance.read_only,
      'max_length': instance.max_length,
      'obscure': instance.obscure,
    };

const _$FieldTypeEnumMap = {
  FieldType.integer: 'integer',
  FieldType.string: 'string',
  FieldType.text: 'text',
  FieldType.datetime: 'datetime',
  FieldType.date: 'date',
  FieldType.time: 'time',
  FieldType.field: 'field',
  FieldType.multifield: 'multifield',
  FieldType.boolean: 'boolean',
  FieldType.email: 'email',
  FieldType.file: 'file',
};
