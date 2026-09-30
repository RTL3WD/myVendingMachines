import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:fleetflow/models/route_model.dart';
import 'package:fleetflow/globals/vending_provider.dart';
import 'package:fleetflow/models/machine.dart';
import 'package:fleetflow/components/route_card.dart';

@NowaGenerated()
class RouteManagementScreen extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const RouteManagementScreen({super.key, this.onBack});

  final void Function()? onBack;

  @override
  State<RouteManagementScreen> createState() {
    return _RouteManagementScreenState();
  }
}

@NowaGenerated()
class _RouteManagementScreenState extends State<RouteManagementScreen> {
  void _showCreateRouteDialog([RouteModel? existingRoute]) {
    final vending = VendingProvider.of(context, listen: false);
    final nameController = TextEditingController(
      text: existingRoute?.name ?? '',
    );
    final descController = TextEditingController(
      text: existingRoute?.description ?? '',
    );
    String selectedColor = existingRoute?.colorHex ?? '0xFF0F8A5F';
    final colorOptions = const [
      '0xFF0F8A5F',
      '0xFF4A5D6E',
      '0xFFBA6900',
      '0xFF1976D2',
      '0xFF7B1FA2',
    ];
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;
          return AlertDialog(
            title: Text(
              existingRoute == null ? 'Create New Route' : 'Edit Route',
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Route Name',
                      hintText: 'e.g. North Austin Commercial',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Description / Area Notes',
                      hintText: 'e.g. Office towers along Mopac corridor',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Route Color Tag',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: colorOptions.map((hex) {
                      final isSelected = selectedColor == hex;
                      final c = Color(int.parse(hex));
                      return GestureDetector(
                        onTap: () => setDialogState(() => selectedColor = hex),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? colorScheme.onSurface
                                  : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  if (nameController.text.trim().isNotEmpty) {
                    if (existingRoute == null) {
                      final newRoute = RouteModel(
                        id: 'route_${DateTime.now().millisecondsSinceEpoch}',
                        name: nameController.text.trim(),
                        description: descController.text.trim(),
                        colorHex: selectedColor,
                      );
                      await vending.addRoute(newRoute);
                    } else {
                      final updated = RouteModel(
                        id: existingRoute.id,
                        name: nameController.text.trim(),
                        description: descController.text.trim(),
                        colorHex: selectedColor,
                        isArchived: existingRoute.isArchived,
                      );
                      await vending.updateRoute(updated);
                    }
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          existingRoute == null
                              ? 'Route created successfully'
                              : 'Route updated',
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  existingRoute == null ? 'Create Route' : 'Save Changes',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAssignMachineDialog(RouteModel route) {
    final vending = VendingProvider.of(context, listen: false);
    final machines = vending.machines;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final colorScheme = theme.colorScheme;
        return StatefulBuilder(
          builder: (context, setSheetState) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Assign to ${route.name}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  Text(
                    'Select machines to group into this route schedule:',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...machines.map((machine) {
                    final isAssigned = machine.routeId == route.id;
                    return CheckboxListTile(
                      value: isAssigned,
                      title: Text(machine.name),
                      subtitle: Text(
                        machine.locationName,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                      activeColor: colorScheme.primary,
                      onChanged: (val) async {
                        final updated = Machine(
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
                          routeId: (val == true) ? route.id : null,
                          routeName: (val == true) ? route.name : null,
                          isArchived: machine.isArchived,
                          slots: machine.slots,
                        );
                        await vending.updateMachine(updated);
                        setSheetState(() {});
                      },
                    );
                  }),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final vending = VendingProvider.of(context);
    final routes = vending.routes;
    final machines = vending.machines;
    final unassignedMachines = machines
        .where((m) => m.routeId == null)
        .toList();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else {
              Navigator.of(context).maybePop();
            }
          },
        ),
        title: const Text('Fleet Routes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Route',
            onPressed: () => _showCreateRouteDialog(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        '${routes.length}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Total Routes',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    color: colorScheme.outlineVariant,
                  ),
                  Column(
                    children: [
                      Text(
                        '${machines.where((m) => m.routeId != null).length}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Assigned',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    color: colorScheme.outlineVariant,
                  ),
                  Column(
                    children: [
                      Text(
                        '${unassignedMachines.length}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: unassignedMachines.isEmpty
                              ? colorScheme.onSurfaceVariant
                              : colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Unassigned',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Configured Routes (${routes.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showCreateRouteDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Route'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...routes.map((route) {
              final assigned = machines
                  .where((m) => m.routeId == route.id)
                  .toList();
              return RouteCard(
                route: route,
                assignedMachines: assigned,
                onEditRoute: () => _showCreateRouteDialog(route),
                onAssignMachine: () => _showAssignMachineDialog(route),
              );
            }),
            if (unassignedMachines.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Unassigned Machines (${unassignedMachines.length})',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              ...unassignedMachines.map(
                (m) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: colorScheme.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 18,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              m.locationName,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
