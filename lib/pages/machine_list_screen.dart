import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:fleetflow/globals/vending_provider.dart';
import 'package:fleetflow/models/machine.dart';
import 'package:fleetflow/models/machine_slot.dart';
import 'package:fleetflow/components/machine_card.dart';

@NowaGenerated()
class MachineListScreen extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const MachineListScreen({
    super.key,
    required this.onSelectMachine,
    required this.onStartVisit,
  });

  final void Function(String machineId) onSelectMachine;

  final void Function(String machineId) onStartVisit;

  @override
  State<MachineListScreen> createState() {
    return _MachineListScreenState();
  }
}

@NowaGenerated()
class _MachineListScreenState extends State<MachineListScreen> {
  String _selectedRouteId = 'all';

  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddMachineDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final vending = VendingProvider.of(context, listen: false);
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final addressController = TextEditingController();
    final serialController = TextEditingController();
    String machineType = 'Snack Glassfront';
    int intervalDays = 7;
    String? selectedRouteId;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add New Vending Machine',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Machine Name *',
                    hintText: 'e.g. Apex Logistics Snack Center',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Location / Spot *',
                    hintText: 'e.g. 2nd Floor Breakroom',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Street Address',
                    hintText: 'e.g. 100 Innovation Way, Austin TX',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: serialController,
                  decoration: InputDecoration(
                    labelText: 'Serial / Model Number',
                    hintText: 'e.g. AP-113-98234',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: machineType,
                  decoration: InputDecoration(
                    labelText: 'Machine Type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Snack Glassfront',
                      child: Text('Snack Glassfront'),
                    ),
                    DropdownMenuItem(
                      value: 'Cold Beverage Can/Bottle',
                      child: Text('Cold Beverage Can/Bottle'),
                    ),
                    DropdownMenuItem(
                      value: 'Combo Snack & Drink',
                      child: Text('Combo Snack & Drink'),
                    ),
                    DropdownMenuItem(
                      value: 'Fresh Food / Sandwich',
                      child: Text('Fresh Food / Sandwich'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setModalState(() => machineType = val!);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: intervalDays,
                  decoration: InputDecoration(
                    labelText: 'Service Schedule Cadence',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 7,
                      child: Text('Weekly (Every 7 days)'),
                    ),
                    DropdownMenuItem(
                      value: 14,
                      child: Text('Bi-Weekly (Every 14 days)'),
                    ),
                    DropdownMenuItem(
                      value: 30,
                      child: Text('Monthly (Every 30 days)'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setModalState(() => intervalDays = val!);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  initialValue: selectedRouteId,
                  decoration: InputDecoration(
                    labelText: 'Assign to Route (Optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('None (Unassigned)'),
                    ),
                    ...vending.routes.map(
                      (r) => DropdownMenuItem(value: r.id, child: Text(r.name)),
                    ),
                  ],
                  onChanged: (val) =>
                      setModalState(() => selectedRouteId = val),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      if (nameController.text.trim().isEmpty ||
                          locationController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please enter a machine name and location.',
                            ),
                          ),
                        );
                        return;
                      }
                      final selectedRoute = selectedRouteId != null
                          ? vending.routes.firstWhere(
                              (r) => r.id == selectedRouteId,
                            )
                          : null;
                      final now = DateTime.now();
                      final nextDate = now.add(Duration(days: intervalDays));
                      final nextDateStr =
                          '${nextDate.month.toString().padLeft(2, '0')}/${nextDate.day.toString().padLeft(2, '0')}/${nextDate.year}';
                      final newMachine = Machine(
                        id: 'mach_${DateTime.now().millisecondsSinceEpoch}',
                        name: nameController.text.trim(),
                        locationName: locationController.text.trim(),
                        address: addressController.text.trim().isEmpty
                            ? 'Local Address'
                            : addressController.text.trim(),
                        notes:
                            'Installed on ${now.month}/${now.day}/${now.year}',
                        machineType: machineType,
                        serialNumber: serialController.text.trim().isEmpty
                            ? 'SN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}'
                            : serialController.text.trim(),
                        lastVisitDate: 'New (No visits yet)',
                        scheduleIntervalDays: intervalDays,
                        nextVisitDate: nextDateStr,
                        routeId: selectedRoute?.id,
                        routeName: selectedRoute?.name,
                        slots: [
                          MachineSlot(
                            id: 'slot_init_1',
                            machineId:
                                'mach_${DateTime.now().millisecondsSinceEpoch}',
                            slotId: 'A1',
                            productId: 'prod_1',
                            productName: 'Lay\'s Classic Potato Chips',
                            category: 'Snacks',
                            capacity: 12,
                            targetQuantity: 12,
                            currentQuantity: 12,
                            purchasePrice: 0.65,
                            salePrice: 1.75,
                          ),
                          MachineSlot(
                            id: 'slot_init_2',
                            machineId:
                                'mach_${DateTime.now().millisecondsSinceEpoch}',
                            slotId: 'A2',
                            productId: 'prod_2',
                            productName: 'Doritos Nacho Cheese',
                            category: 'Snacks',
                            capacity: 12,
                            targetQuantity: 12,
                            currentQuantity: 12,
                            purchasePrice: 0.7,
                            salePrice: 1.75,
                          ),
                        ],
                      );
                      await vending.addMachine(newMachine);
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Machine "${newMachine.name}" added to fleet!',
                          ),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Add Machine to Fleet',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final vending = VendingProvider.of(context);
    final allMachines = vending.machines;
    final routes = vending.routes;
    final filtered = allMachines.where((m) {
      final matchesRoute =
          _selectedRouteId == 'all' || m.routeId == _selectedRouteId;
      final matchesSearch =
          _searchQuery.isEmpty ||
          m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.locationName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.address.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesRoute && matchesSearch;
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fleet Machines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Machine',
            onPressed: () => _showAddMachineDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search machines or locations...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: colorScheme.surfaceContainerLowest,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('All Routes'),
                    selected: _selectedRouteId == 'all',
                    selectedColor: colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      color: _selectedRouteId == 'all'
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                      fontWeight: _selectedRouteId == 'all'
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    onSelected: (_) => setState(() => _selectedRouteId = 'all'),
                  ),
                ),
                ...routes.map((r) {
                  final isSelected = _selectedRouteId == r.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(r.name),
                      selected: isSelected,
                      selectedColor: colorScheme.primaryContainer,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      onSelected: (_) =>
                          setState(() => _selectedRouteId = r.id),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.storefront_outlined,
                            size: 48,
                            color: colorScheme.outline,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No machines found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'No results matching "${_searchQuery}"'
                                : 'Add your first vending unit to get started.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () => _showAddMachineDialog(context),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Add Machine'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final machine = filtered[index];
                      return MachineCard(
                        machine: machine,
                        onTap: () => widget.onSelectMachine(machine.id),
                        onStartVisit: () => widget.onStartVisit(machine.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
