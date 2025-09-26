// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  category: json['category'] as String,
  imageUrl: json['imageUrl'] as String,
  options:
      (json['options'] as List<dynamic>?)
          ?.map((e) => ServiceOption.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'category': instance.category,
  'imageUrl': instance.imageUrl,
  'options': instance.options,
};

ServiceOption _$ServiceOptionFromJson(Map<String, dynamic> json) =>
    ServiceOption(
      id: json['id'] as String,
      name: json['name'] as String,
      additionalPrice: (json['additionalPrice'] as num).toDouble(),
      type: $enumDecode(_$OptionTypeEnumMap, json['type']),
      choices:
          (json['choices'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ServiceOptionToJson(ServiceOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'additionalPrice': instance.additionalPrice,
      'type': _$OptionTypeEnumMap[instance.type]!,
      'choices': instance.choices,
    };

const _$OptionTypeEnumMap = {
  OptionType.text: 'text',
  OptionType.choice: 'choice',
  OptionType.boolean: 'boolean',
};

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
  service: Service.fromJson(json['service'] as Map<String, dynamic>),
  quantity: (json['quantity'] as num).toInt(),
  selectedOptions: json['selectedOptions'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
  'service': instance.service,
  'quantity': instance.quantity,
  'selectedOptions': instance.selectedOptions,
};
