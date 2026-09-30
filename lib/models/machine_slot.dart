import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class MachineSlot {
  const MachineSlot({
    required this.id,
    required this.machineId,
    required this.slotId,
    required this.productId,
    required this.productName,
    this.category = 'Snacks',
    this.capacity = 12,
    this.targetQuantity = 10,
    this.currentQuantity = 8,
    this.purchasePrice = 0.75,
    this.salePrice = 2,
    this.notes = '',
    this.isActive = true,
  });

  factory MachineSlot.fromJson(Map<String, dynamic> json) {
    return MachineSlot(
      id: json['id'] as String,
      machineId: json['machineId'] as String,
      slotId: json['slotId'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      category: json['category'] as String? ?? 'Snacks',
      capacity: json['capacity'] as int? ?? 12,
      targetQuantity: json['targetQuantity'] as int? ?? 10,
      currentQuantity: json['currentQuantity'] as int? ?? 8,
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble() ?? 0.75,
      salePrice: (json['salePrice'] as num?)?.toDouble() ?? 2,
      notes: json['notes'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  final String id;

  final String machineId;

  final String slotId;

  final String productId;

  final String productName;

  final String category;

  final int capacity;

  final int targetQuantity;

  final int currentQuantity;

  final double purchasePrice;

  final double salePrice;

  final String notes;

  final bool isActive;

  MachineSlot copyWith({
    String? id,
    String? machineId,
    String? slotId,
    String? productId,
    String? productName,
    String? category,
    int? capacity,
    int? targetQuantity,
    int? currentQuantity,
    double? purchasePrice,
    double? salePrice,
    String? notes,
    bool? isActive,
  }) {
    return MachineSlot(
      id: id ?? this.id,
      machineId: machineId ?? this.machineId,
      slotId: slotId ?? this.slotId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      category: category ?? this.category,
      capacity: capacity ?? this.capacity,
      targetQuantity: targetQuantity ?? this.targetQuantity,
      currentQuantity: currentQuantity ?? this.currentQuantity,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      salePrice: salePrice ?? this.salePrice,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'machineId': machineId,
      'slotId': slotId,
      'productId': productId,
      'productName': productName,
      'category': category,
      'capacity': capacity,
      'targetQuantity': targetQuantity,
      'currentQuantity': currentQuantity,
      'purchasePrice': purchasePrice,
      'salePrice': salePrice,
      'notes': notes,
      'isActive': isActive,
    };
  }
}
