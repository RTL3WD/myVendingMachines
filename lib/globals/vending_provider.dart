import 'package:flutter/material.dart';
import 'package:fleetflow/models/machine.dart';
import 'package:fleetflow/models/product_blueprint.dart';
import 'package:fleetflow/models/route_model.dart';
import 'package:fleetflow/models/inventory_visit.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:fleetflow/main.dart';
import 'package:fleetflow/vending_sample_data.dart';
import 'dart:convert';
import 'package:fleetflow/models/machine_slot.dart';
import 'package:provider/provider.dart';

@NowaGenerated()
class VendingProvider extends ChangeNotifier {
  VendingProvider();

  factory VendingProvider.of(BuildContext context, {bool listen = true}) {
    return Provider.of<VendingProvider>(context, listen: listen);
  }

  List<Machine> _machines = [];

  List<ProductBlueprint> _products = [];

  List<RouteModel> _routes = [];

  List<InventoryVisit> _visits = [];

  bool _isInitialized = false;

  List<Machine> get machines {
    return List.unmodifiable(_machines);
  }

  List<ProductBlueprint> get products {
    return List.unmodifiable(_products);
  }

  List<RouteModel> get routes {
    return List.unmodifiable(_routes);
  }

  List<InventoryVisit> get visits {
    return List.unmodifiable(_visits);
  }

  bool get isInitialized {
    return _isInitialized;
  }

  double get totalRevenue {
    return _visits.fold(0, (sum, v) => sum + v.totalRevenue);
  }

  double get totalCost {
    return _visits.fold(0, (sum, v) => sum + v.totalCost);
  }

  double get totalGrossProfit {
    return totalRevenue - totalCost;
  }

  int get totalUnitsSold {
    return _visits.fold(0, (sum, v) => sum + v.totalUnitsSold);
  }

  int get totalAdjustments {
    return _visits.fold(0, (sum, v) => sum + v.totalAdjustments);
  }

  static const String _keySchema = 'vending_schema_version';

  static const String _keyMachines = 'vending_machines';

  static const String _keyProducts = 'vending_products';

  static const String _keyRoutes = 'vending_routes';

  static const String _keyVisits = 'vending_visits';

  void init() {
    if (_isInitialized) {
      return;
    }
    try {
      final machinesJson = sharedPrefs.getString(_keyMachines);
      final productsJson = sharedPrefs.getString(_keyProducts);
      final routesJson = sharedPrefs.getString(_keyRoutes);
      final visitsJson = sharedPrefs.getString(_keyVisits);
      if (machinesJson == null || productsJson == null) {
        _machines = List.from(VendingSampleData.machines);
        _products = List.from(VendingSampleData.products);
        _routes = List.from(VendingSampleData.routes);
        _visits = List.from(VendingSampleData.visits);
        _saveAll();
      } else {
        final List<dynamic> machList =
            jsonDecode(machinesJson) as List<dynamic>;
        _machines = machList
            .map((e) => Machine.fromJson(e as Map<String, dynamic>))
            .toList();
        final List<dynamic> prodList =
            jsonDecode(productsJson) as List<dynamic>;
        _products = prodList
            .map((e) => ProductBlueprint.fromJson(e as Map<String, dynamic>))
            .toList();
        final List<dynamic> routeList =
            jsonDecode(routesJson ?? '[]') as List<dynamic>;
        _routes = routeList
            .map((e) => RouteModel.fromJson(e as Map<String, dynamic>))
            .toList();
        final List<dynamic> visitList =
            jsonDecode(visitsJson ?? '[]') as List<dynamic>;
        _visits = visitList
            .map((e) => InventoryVisit.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      _machines = List.from(VendingSampleData.machines);
      _products = List.from(VendingSampleData.products);
      _routes = List.from(VendingSampleData.routes);
      _visits = List.from(VendingSampleData.visits);
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _saveAll() async {
    await sharedPrefs.setInt(_keySchema, 1);
    await sharedPrefs.setString(
      _keyMachines,
      jsonEncode(_machines.map((e) => e.toJson()).toList()),
    );
    await sharedPrefs.setString(
      _keyProducts,
      jsonEncode(_products.map((e) => e.toJson()).toList()),
    );
    await sharedPrefs.setString(
      _keyRoutes,
      jsonEncode(_routes.map((e) => e.toJson()).toList()),
    );
    await sharedPrefs.setString(
      _keyVisits,
      jsonEncode(_visits.map((e) => e.toJson()).toList()),
    );
  }

  Machine? getMachineById(String id) {
    try {
      return _machines.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  List<InventoryVisit> getVisitsForMachine(String machineId) {
    return _visits.where((v) => v.machineId == machineId).toList();
  }

  String getScheduleStatus(Machine machine) {
    if (machine.id == 'mach_1') {
      return 'Overdue';
    }
    if (machine.id == 'mach_2') {
      return 'Due Today';
    }
    return 'On Schedule';
  }

  Future<void> addProduct(ProductBlueprint product) async {
    _products = [..._products, product];
    await _saveAll();
    notifyListeners();
  }

  Future<void> updateProduct(ProductBlueprint product) async {
    _products = _products.map((p) => p.id == product.id ? product : p).toList();
    await _saveAll();
    notifyListeners();
  }

  Future<void> addMachine(Machine machine) async {
    _machines = [..._machines, machine];
    await _saveAll();
    notifyListeners();
  }

  Future<void> updateMachine(Machine machine) async {
    _machines = _machines.map((m) => m.id == machine.id ? machine : m).toList();
    await _saveAll();
    notifyListeners();
  }

  Future<void> addSlot(String machineId, MachineSlot slot) async {
    final machine = getMachineById(machineId);
    if (machine == null) {
      return;
    }
    final updatedSlots = [...machine.slots, slot];
    final updatedMachine = Machine(
      id: machine.id,
      name: machine.name,
      locationName: machine.locationName,
      address: machine.address,
      notes: machine.notes,
      machineType: machine.machineType,
      serialNumber: machine.serialNumber,
      lastVisitDate: machine.lastVisitDate,
      scheduleIntervalDays: machine.scheduleIntervalDays,
      nextVisitDate: machine.nextVisitDate,
      routeId: machine.routeId,
      routeName: machine.routeName,
      isArchived: machine.isArchived,
      slots: updatedSlots,
    );
    await updateMachine(updatedMachine);
  }

  Future<void> addRoute(RouteModel route) async {
    _routes = [..._routes, route];
    await _saveAll();
    notifyListeners();
  }

  Future<void> updateRoute(RouteModel route) async {
    _routes = _routes.map((r) => r.id == route.id ? route : r).toList();
    await _saveAll();
    notifyListeners();
  }

  Future<void> setMachineRoute(
    String machineId,
    String? routeId,
    String? routeName,
  ) async {
    final m = getMachineById(machineId);
    if (m == null) {
      return;
    }
    final updated = Machine(
      id: m.id,
      name: m.name,
      locationName: m.locationName,
      address: m.address,
      notes: m.notes,
      machineType: m.machineType,
      serialNumber: m.serialNumber,
      lastVisitDate: m.lastVisitDate,
      scheduleIntervalDays: m.scheduleIntervalDays,
      nextVisitDate: m.nextVisitDate,
      routeId: routeId,
      routeName: routeName,
      isArchived: m.isArchived,
      slots: m.slots,
    );
    await updateMachine(updated);
  }

  Future<void> completeVisit({
    required InventoryVisit visit,
    required Map<String, int> finalSlotQuantities,
  }) async {
    _visits = [visit, ..._visits];
    final machine = getMachineById(visit.machineId);
    if (machine != null) {
      final updatedSlots = machine.slots.map((s) {
        final newQty = finalSlotQuantities[s.slotId] ?? s.currentQuantity;
        return s.copyWith(currentQuantity: newQty);
      }).toList();
      final now = DateTime.now();
      final nextDate = now.add(Duration(days: machine.scheduleIntervalDays));
      final nextDateStr =
          '${nextDate.month.toString().padLeft(2, '0')}/${nextDate.day.toString().padLeft(2, '0')}/${nextDate.year}';
      final todayStr =
          '${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year}';
      final updatedMachine = Machine(
        id: machine.id,
        name: machine.name,
        locationName: machine.locationName,
        address: machine.address,
        notes: machine.notes,
        machineType: machine.machineType,
        serialNumber: machine.serialNumber,
        lastVisitDate: todayStr,
        scheduleIntervalDays: machine.scheduleIntervalDays,
        nextVisitDate: nextDateStr,
        routeId: machine.routeId,
        routeName: machine.routeName,
        isArchived: machine.isArchived,
        slots: updatedSlots,
      );
      _machines = _machines
          .map((m) => m.id == machine.id ? updatedMachine : m)
          .toList();
    }
    await _saveAll();
    notifyListeners();
  }

  String exportCsv() {
    final buffer = StringBuffer();
    buffer.writeln(
      '# VENDING_FLEET_MANAGER_BACKUP,SCHEMA_VERSION=1.0,TIMESTAMP=${DateTime.now().toIso8601String()}',
    );
    buffer.writeln(
      'record_type,id,name,location_or_category,val1,val2,val3,val4,val5,json_payload',
    );
    for (final p in _products) {
      buffer.writeln(
        'PRODUCT,${p.id},"${p.name}","${p.category}",${p.defaultPurchasePrice},${p.defaultSalePrice},"${p.barcode}","${p.brand}","${p.packageSize}","${jsonEncode(p.toJson()).replaceAll('"', '""')}"',
      );
    }
    for (final r in _routes) {
      buffer.writeln(
        'ROUTE,${r.id},"${r.name}","${r.description}","${r.colorHex}",,,,,"${jsonEncode(r.toJson()).replaceAll('"', '""')}"',
      );
    }
    for (final m in _machines) {
      buffer.writeln(
        'MACHINE,${m.id},"${m.name}","${m.locationName}","${m.machineType}","${m.scheduleIntervalDays}","${m.lastVisitDate}","${m.nextVisitDate}","${m.routeId ?? ''}","${jsonEncode(m.toJson()).replaceAll('"', '""')}"',
      );
    }
    for (final v in _visits) {
      buffer.writeln(
        'VISIT,${v.id},"${v.machineName}","${v.visitDate}",${v.totalRevenue},${v.totalCost},${v.grossProfit},${v.totalUnitsSold},${v.totalAdjustments},"${jsonEncode(v.toJson()).replaceAll('"', '""')}"',
      );
    }
    return buffer.toString();
  }

  Future<bool> importCsv(String csvContent, {required bool replace}) async {
    try {
      final lines = csvContent.split('\n');
      if (lines.isEmpty) {
        return false;
      }
      final List<ProductBlueprint> importedProducts = [];
      final List<RouteModel> importedRoutes = [];
      final List<Machine> importedMachines = [];
      final List<InventoryVisit> importedVisits = [];
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty ||
            trimmed.startsWith('#') ||
            trimmed.startsWith('record_type')) {
          continue;
        }
        final firstComma = trimmed.indexOf(',');
        if (firstComma == -1) {
          continue;
        }
        final type = trimmed.substring(0, firstComma).toUpperCase();
        final lastQuoteStart = trimmed.lastIndexOf(',"');
        if (lastQuoteStart != -1 && trimmed.endsWith('"')) {
          final rawJson = trimmed
              .substring(lastQuoteStart + 2, trimmed.length - 1)
              .replaceAll('""', '"');
          final map = jsonDecode(rawJson) as Map<String, dynamic>;
          if (type == 'PRODUCT') {
            importedProducts.add(ProductBlueprint.fromJson(map));
          } else if (type == 'ROUTE') {
            importedRoutes.add(RouteModel.fromJson(map));
          } else if (type == 'MACHINE') {
            importedMachines.add(Machine.fromJson(map));
          } else if (type == 'VISIT') {
            importedVisits.add(InventoryVisit.fromJson(map));
          }
        }
      }
      if (replace) {
        if (importedProducts.isNotEmpty) {
          _products = importedProducts;
        }
        if (importedRoutes.isNotEmpty) {
          _routes = importedRoutes;
        }
        if (importedMachines.isNotEmpty) {
          _machines = importedMachines;
        }
        if (importedVisits.isNotEmpty) {
          _visits = importedVisits;
        }
      } else {
        for (final p in importedProducts) {
          final idx = _products.indexWhere((x) => x.id == p.id);
          if (idx != -1) {
            _products[idx] = p;
          } else {
            _products.add(p);
          }
        }
        for (final r in importedRoutes) {
          final idx = _routes.indexWhere((x) => x.id == r.id);
          if (idx != -1) {
            _routes[idx] = r;
          } else {
            _routes.add(r);
          }
        }
        for (final m in importedMachines) {
          final idx = _machines.indexWhere((x) => x.id == m.id);
          if (idx != -1) {
            _machines[idx] = m;
          } else {
            _machines.add(m);
          }
        }
        for (final v in importedVisits) {
          final idx = _visits.indexWhere((x) => x.id == v.id);
          if (idx != -1) {
            _visits[idx] = v;
          } else {
            _visits.add(v);
          }
        }
      }
      await _saveAll();
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }
}
