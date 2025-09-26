import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'service.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  String toQRCodeData() {
    final qrData = {
      "orderId": id,
      "items": items.map((item) => {
        "service": item.service.name,
        "quantity": item.quantity,
        "price": item.service.price,
        "totalPrice": item.totalPrice,
        "options": item.selectedOptions
      }).toList(),
      "totalAmount": totalAmount,
      "createdAt": createdAt.toIso8601String()
    };
    return jsonEncode(qrData);
  }
}