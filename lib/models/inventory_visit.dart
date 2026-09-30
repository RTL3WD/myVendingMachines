import 'package:fleetflow/models/visit_slot_entry.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class InventoryVisit {
  const InventoryVisit({
    required this.id,
    required this.machineId,
    required this.machineName,
    required this.visitDate,
    this.completedAt = '',
    this.totalRevenue = 0,
    this.totalCost = 0,
    this.grossProfit = 0,
    this.totalUnitsSold = 0,
    this.totalAdjustments = 0,
    this.notes = '',
    this.isDraft = false,
    this.slotEntries = const [],
  });

  factory InventoryVisit.fromJson(Map<String, dynamic> json) {
    return InventoryVisit(
      id: json['id'] as String,
      machineId: json['machineId'] as String,
      machineName: json['machineName'] as String,
      visitDate: json['visitDate'] as String,
      completedAt: json['completedAt'] as String? ?? '',
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0,
      totalCost: (json['totalCost'] as num?)?.toDouble() ?? 0,
      grossProfit: (json['grossProfit'] as num?)?.toDouble() ?? 0,
      totalUnitsSold: json['totalUnitsSold'] as int? ?? 0,
      totalAdjustments: json['totalAdjustments'] as int? ?? 0,
      notes: json['notes'] as String? ?? '',
      isDraft: json['isDraft'] as bool? ?? false,
      slotEntries:
          (json['slotEntries'] as List<dynamic>?)
              ?.map((e) => VisitSlotEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  final String id;

  final String machineId;

  final String machineName;

  final String visitDate;

  final String completedAt;

  final double totalRevenue;

  final double totalCost;

  final double grossProfit;

  final int totalUnitsSold;

  final int totalAdjustments;

  final String notes;

  final bool isDraft;

  final List<VisitSlotEntry> slotEntries;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'machineId': machineId,
      'machineName': machineName,
      'visitDate': visitDate,
      'completedAt': completedAt,
      'totalRevenue': totalRevenue,
      'totalCost': totalCost,
      'grossProfit': grossProfit,
      'totalUnitsSold': totalUnitsSold,
      'totalAdjustments': totalAdjustments,
      'notes': notes,
      'isDraft': isDraft,
      'slotEntries': slotEntries.map((e) => e.toJson()).toList(),
    };
  }
}
