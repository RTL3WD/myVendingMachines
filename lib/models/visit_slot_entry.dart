import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class VisitSlotEntry {
  const VisitSlotEntry({
    required this.id,
    required this.slotId,
    required this.productId,
    required this.productName,
    this.category = 'Snacks',
    this.capacity = 12,
    this.targetQuantity = 10,
    required this.openingQuantity,
    required this.countedQuantity,
    this.additionsRecorded = 0,
    this.rawDepletion = 0,
    this.unitsSold = 0,
    this.unitsDamaged = 0,
    this.unitsMissing = 0,
    this.unitsComplimentary = 0,
    this.unitsOther = 0,
    this.purchasePrice = 0.75,
    this.salePrice = 2,
    this.recommendedRestock = 0,
    this.actualRestock = 0,
  });

  factory VisitSlotEntry.fromJson(Map<String, dynamic> json) {
    return VisitSlotEntry(
      id: json['id'] as String,
      slotId: json['slotId'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      category: json['category'] as String? ?? 'Snacks',
      capacity: json['capacity'] as int? ?? 12,
      targetQuantity: json['targetQuantity'] as int? ?? 10,
      openingQuantity: json['openingQuantity'] as int? ?? 0,
      countedQuantity: json['countedQuantity'] as int? ?? 0,
      additionsRecorded: json['additionsRecorded'] as int? ?? 0,
      rawDepletion: json['rawDepletion'] as int? ?? 0,
      unitsSold: json['unitsSold'] as int? ?? 0,
      unitsDamaged: json['unitsDamaged'] as int? ?? 0,
      unitsMissing: json['unitsMissing'] as int? ?? 0,
      unitsComplimentary: json['unitsComplimentary'] as int? ?? 0,
      unitsOther: json['unitsOther'] as int? ?? 0,
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble() ?? 0.75,
      salePrice: (json['salePrice'] as num?)?.toDouble() ?? 2,
      recommendedRestock: json['recommendedRestock'] as int? ?? 0,
      actualRestock: json['actualRestock'] as int? ?? 0,
    );
  }

  final String id;

  final String slotId;

  final String productId;

  final String productName;

  final String category;

  final int capacity;

  final int targetQuantity;

  final int openingQuantity;

  final int countedQuantity;

  final int additionsRecorded;

  final int rawDepletion;

  final int unitsSold;

  final int unitsDamaged;

  final int unitsMissing;

  final int unitsComplimentary;

  final int unitsOther;

  final double purchasePrice;

  final double salePrice;

  final int recommendedRestock;

  final int actualRestock;

  double get revenue {
    return unitsSold * salePrice;
  }

  double get cogs {
    return unitsSold * purchasePrice;
  }

  double get grossProfit {
    return revenue - cogs;
  }

  double get adjustmentCost {
    return (unitsDamaged + unitsMissing + unitsComplimentary + unitsOther) *
        purchasePrice;
  }

  VisitSlotEntry copyWith({
    String? id,
    String? slotId,
    String? productId,
    String? productName,
    String? category,
    int? capacity,
    int? targetQuantity,
    int? openingQuantity,
    int? countedQuantity,
    int? additionsRecorded,
    int? rawDepletion,
    int? unitsSold,
    int? unitsDamaged,
    int? unitsMissing,
    int? unitsComplimentary,
    int? unitsOther,
    double? purchasePrice,
    double? salePrice,
    int? recommendedRestock,
    int? actualRestock,
  }) {
    return VisitSlotEntry(
      id: id ?? this.id,
      slotId: slotId ?? this.slotId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      category: category ?? this.category,
      capacity: capacity ?? this.capacity,
      targetQuantity: targetQuantity ?? this.targetQuantity,
      openingQuantity: openingQuantity ?? this.openingQuantity,
      countedQuantity: countedQuantity ?? this.countedQuantity,
      additionsRecorded: additionsRecorded ?? this.additionsRecorded,
      rawDepletion: rawDepletion ?? this.rawDepletion,
      unitsSold: unitsSold ?? this.unitsSold,
      unitsDamaged: unitsDamaged ?? this.unitsDamaged,
      unitsMissing: unitsMissing ?? this.unitsMissing,
      unitsComplimentary: unitsComplimentary ?? this.unitsComplimentary,
      unitsOther: unitsOther ?? this.unitsOther,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      salePrice: salePrice ?? this.salePrice,
      recommendedRestock: recommendedRestock ?? this.recommendedRestock,
      actualRestock: actualRestock ?? this.actualRestock,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slotId': slotId,
      'productId': productId,
      'productName': productName,
      'category': category,
      'capacity': capacity,
      'targetQuantity': targetQuantity,
      'openingQuantity': openingQuantity,
      'countedQuantity': countedQuantity,
      'additionsRecorded': additionsRecorded,
      'rawDepletion': rawDepletion,
      'unitsSold': unitsSold,
      'unitsDamaged': unitsDamaged,
      'unitsMissing': unitsMissing,
      'unitsComplimentary': unitsComplimentary,
      'unitsOther': unitsOther,
      'purchasePrice': purchasePrice,
      'salePrice': salePrice,
      'recommendedRestock': recommendedRestock,
      'actualRestock': actualRestock,
    };
  }
}
