import 'package:json_annotation/json_annotation.dart';

part 'service.g.dart';

@JsonSerializable()
class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final List<ServiceOption> options;

  const Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.options = const [],
  });

  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceToJson(this);
}

@JsonSerializable()
class ServiceOption {
  final String id;
  final String name;
  final double additionalPrice;
  final OptionType type;
  final List<String> choices;

  const ServiceOption({
    required this.id,
    required this.name,
    required this.additionalPrice,
    required this.type,
    this.choices = const [],
  });

  factory ServiceOption.fromJson(Map<String, dynamic> json) => _$ServiceOptionFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceOptionToJson(this);
}

enum OptionType {
  @JsonValue('text')
  text,
  @JsonValue('choice')
  choice,
  @JsonValue('boolean')
  boolean,
}

@JsonSerializable()
class CartItem {
  final Service service;
  final int quantity;
  final Map<String, dynamic> selectedOptions;

  const CartItem({
    required this.service,
    required this.quantity,
    this.selectedOptions = const {},
  });

  double get totalPrice {
    double optionsPrice = 0;
    for (final option in service.options) {
      if (selectedOptions.containsKey(option.id)) {
        optionsPrice += option.additionalPrice;
      }
    }
    return (service.price + optionsPrice) * quantity;
  }

  CartItem copyWith({
    Service? service,
    int? quantity,
    Map<String, dynamic>? selectedOptions,
  }) {
    return CartItem(
      service: service ?? this.service,
      quantity: quantity ?? this.quantity,
      selectedOptions: selectedOptions ?? this.selectedOptions,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}