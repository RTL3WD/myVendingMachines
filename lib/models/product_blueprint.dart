import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class ProductBlueprint {
  const ProductBlueprint({
    required this.id,
    required this.name,
    required this.barcode,
    required this.category,
    this.brand = '',
    this.packageSize = '',
    this.defaultPurchasePrice = 0,
    this.defaultSalePrice = 0,
    this.notes = '',
    this.isArchived = false,
  });

  factory ProductBlueprint.fromJson(Map<String, dynamic> json) {
    return ProductBlueprint(
      id: json['id'] as String,
      name: json['name'] as String,
      barcode: json['barcode'] as String,
      category: json['category'] as String,
      brand: json['brand'] as String? ?? '',
      packageSize: json['packageSize'] as String? ?? '',
      defaultPurchasePrice:
          (json['defaultPurchasePrice'] as num?)?.toDouble() ?? 0,
      defaultSalePrice: (json['defaultSalePrice'] as num?)?.toDouble() ?? 0,
      notes: json['notes'] as String? ?? '',
      isArchived: json['isArchived'] as bool? ?? false,
    );
  }

  final String id;

  final String name;

  final String barcode;

  final String category;

  final String brand;

  final String packageSize;

  final double defaultPurchasePrice;

  final double defaultSalePrice;

  final String notes;

  final bool isArchived;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'barcode': barcode,
      'category': category,
      'brand': brand,
      'packageSize': packageSize,
      'defaultPurchasePrice': defaultPurchasePrice,
      'defaultSalePrice': defaultSalePrice,
      'notes': notes,
      'isArchived': isArchived,
    };
  }
}
