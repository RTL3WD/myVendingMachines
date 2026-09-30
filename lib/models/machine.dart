import 'package:fleetflow/models/machine_slot.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class Machine {
  const Machine({
    required this.id,
    required this.name,
    required this.locationName,
    this.address = '',
    this.notes = '',
    this.machineType = 'Combo (Snack & Drink)',
    this.serialNumber = '',
    this.lastVisitDate = '',
    this.scheduleIntervalDays = 7,
    this.nextVisitDate = '',
    this.routeId,
    this.routeName,
    this.isArchived = false,
    this.slots = const [],
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'] as String,
      name: json['name'] as String,
      locationName: json['locationName'] as String,
      address: json['address'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      machineType: json['machineType'] as String? ?? 'Combo',
      serialNumber: json['serialNumber'] as String? ?? '',
      lastVisitDate: json['lastVisitDate'] as String? ?? '',
      scheduleIntervalDays: json['scheduleIntervalDays'] as int? ?? 7,
      nextVisitDate: json['nextVisitDate'] as String? ?? '',
      routeId: json['routeId'] as String?,
      routeName: json['routeName'] as String?,
      isArchived: json['isArchived'] as bool? ?? false,
      slots:
          (json['slots'] as List<dynamic>?)
              ?.map((e) => MachineSlot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  final String id;

  final String name;

  final String locationName;

  final String address;

  final String notes;

  final String machineType;

  final String serialNumber;

  final String lastVisitDate;

  final int scheduleIntervalDays;

  final String nextVisitDate;

  final String? routeId;

  final String? routeName;

  final bool isArchived;

  final List<MachineSlot> slots;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'locationName': locationName,
      'address': address,
      'notes': notes,
      'machineType': machineType,
      'serialNumber': serialNumber,
      'lastVisitDate': lastVisitDate,
      'scheduleIntervalDays': scheduleIntervalDays,
      'nextVisitDate': nextVisitDate,
      'routeId': routeId,
      'routeName': routeName,
      'isArchived': isArchived,
      'slots': slots.map((e) => e.toJson()).toList(),
    };
  }
}
