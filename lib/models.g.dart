// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

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
      max_length: (json['max_length'] as num?)?.toInt(),
      fetch_first: json['fetch_first'] as bool? ?? false,
      show_only: json['show_only'],
      from_field: json['from_field'] as String?,
      hasController: json['hasController'] as bool? ?? false,
      show_only_field: json['show_only_field'] as String?,
      show_reset_value: json['show_reset_value'] as bool?,
      start_value: json['start_value'] as String?,
      end_value: json['end_value'] as String?,
      from_field_source: json['from_field_source'] as String?,
      storage: json['storage'] as String?,
      instance_url: json['instance_url'] as String?,
      url: json['url'] as String?,
      from_field_value_field: json['from_field_value_field'] as String?,
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
      'storage': instance.storage,
      'from_field_source': instance.from_field_source,
      'instance_url': instance.instance_url,
      'multiple': instance.multiple,
      'display_name': instance.display_name,
      'search_field': instance.search_field,
      'value_field': instance.value_field,
      'from_field_value_field': instance.from_field_value_field,
      'choices': instance.choices,
      'select_first': instance.select_first,
      'name': instance.name,
      'label': instance.label,
      'placeholder': instance.placeholder,
      'type': _$FieldTypeEnumMap[instance.type]!,
      'required': instance.required,
      'read_only': instance.read_only,
      'max_length': instance.max_length,
      'fetch_first': instance.fetch_first,
      'obscure': instance.obscure,
      'from_field': instance.from_field,
      'show_only': instance.show_only,
      'show_only_field': instance.show_only_field,
      'start_value': instance.start_value,
      'end_value': instance.end_value,
      'show_reset_value': instance.show_reset_value,
      'hasController': instance.hasController,
    };

const _$FieldTypeEnumMap = {
  FieldType.integer: 'integer',
  FieldType.alphabets: 'alphabets',
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
  FieldType.choice: 'choice',
  FieldType.float: 'float',
};
