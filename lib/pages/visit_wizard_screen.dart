import 'package:flutter/material.dart';
import 'package:fleetflow/models/machine.dart';
import 'package:fleetflow/models/visit_slot_entry.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:fleetflow/globals/vending_provider.dart';
import 'package:fleetflow/vending_sample_data.dart';
import 'package:fleetflow/models/inventory_visit.dart';

@NowaGenerated()
class VisitWizardScreen extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const VisitWizardScreen({super.key, this.machineId = 'mach_1', this.onClose});

  final String machineId;

  final void Function()? onClose;

  @override
  State<VisitWizardScreen> createState() {
    return _VisitWizardScreenState();
  }
}

@NowaGenerated()
class _VisitWizardScreenState extends State<VisitWizardScreen> {
  int _currentStep = 0;

  late Machine _machine;

  late List<VisitSlotEntry> _entries;

  final TextEditingController _notesController = TextEditingController();

  double get _totalRevenue {
    return _entries.fold(0, (sum, e) => sum + e.revenue);
  }

  double get _totalCost {
    return _entries.fold(0, (sum, e) => sum + e.cogs);
  }

  double get _totalGrossProfit {
    return _totalRevenue - _totalCost;
  }

  int get _totalSold {
    return _entries.fold(0, (sum, e) => sum + e.unitsSold);
  }

  int get _totalRestocked {
    return _entries.fold(0, (sum, e) => sum + e.actualRestock);
  }

  bool _initializedData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initializedData) {
      final vending = VendingProvider.of(context, listen: false);
      _machine =
          vending.getMachineById(widget.machineId) ??
          (vending.machines.isNotEmpty
              ? vending.machines.first
              : VendingSampleData.machines.first);
      _entries = _machine.slots.map((s) {
        final opening = s.currentQuantity;
        final counted = (opening >= 3) ? opening - 2 : opening;
        final rawDep = opening - counted;
        final recRestock = (s.targetQuantity - counted)
            .clamp(0, s.capacity - counted)
            .toInt();
        return VisitSlotEntry(
          id: 'entry_${s.id}',
          slotId: s.slotId,
          productId: s.productId,
          productName: s.productName,
          category: s.category,
          capacity: s.capacity,
          targetQuantity: s.targetQuantity,
          openingQuantity: opening,
          countedQuantity: counted,
          rawDepletion: rawDep,
          unitsSold: rawDep,
          unitsDamaged: 0,
          purchasePrice: s.purchasePrice,
          salePrice: s.salePrice,
          recommendedRestock: recRestock,
          actualRestock: recRestock,
        );
      }).toList();
      _initializedData = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _machine = VendingSampleData.machines.first;
    _entries = [];
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _markAllUnchanged() {
    setState(() {
      _entries = _entries
          .map(
            (e) => e.copyWith(
              countedQuantity: e.openingQuantity,
              rawDepletion: 0,
              unitsSold: 0,
              unitsDamaged: 0,
              recommendedRestock: (e.targetQuantity - e.openingQuantity)
                  .clamp(0, e.capacity - e.openingQuantity)
                  .toInt(),
              actualRestock: (e.targetQuantity - e.openingQuantity)
                  .clamp(0, e.capacity - e.openingQuantity)
                  .toInt(),
            ),
          )
          .toList();
    });
  }

  void _updateCount(int index, int delta) {
    setState(() {
      final e = _entries[index];
      final newCount = (e.countedQuantity + delta).clamp(0, e.capacity).toInt();
      final rawDep = (e.openingQuantity - newCount)
          .clamp(0, e.openingQuantity)
          .toInt();
      final recRestock = (e.targetQuantity - newCount)
          .clamp(0, e.capacity - newCount)
          .toInt();
      _entries[index] = e.copyWith(
        countedQuantity: newCount,
        rawDepletion: rawDep,
        unitsSold: rawDep - e.unitsDamaged,
        recommendedRestock: recRestock,
        actualRestock: recRestock,
      );
    });
  }

  void _updateRestock(int index, int delta) {
    setState(() {
      final e = _entries[index];
      final maxAdd = e.capacity - e.countedQuantity;
      final newAdd = (e.actualRestock + delta).clamp(0, maxAdd).toInt();
      _entries[index] = e.copyWith(actualRestock: newAdd);
    });
  }

  void _toggleDamaged(int index) {
    setState(() {
      final e = _entries[index];
      if (e.rawDepletion > 0) {
        final newDamaged = e.unitsDamaged == 0 ? 1 : 0;
        final newSold = (e.rawDepletion - newDamaged)
            .clamp(0, e.rawDepletion)
            .toInt();
        _entries[index] = e.copyWith(
          unitsDamaged: newDamaged,
          unitsSold: newSold,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final steps = const [
      '1. Review',
      '2. Count',
      '3. Depletion',
      '4. Sales',
      '5. Restock',
      '6. Finish',
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            if (widget.onClose != null) {
              widget.onClose!();
            } else {
              Navigator.of(context).maybePop();
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Visit: ${_machine.name}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Step ${_currentStep + 1} of 6 • ${steps[_currentStep]}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
          ),
          child: Row(
            children: [
              if (_currentStep > 0)
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () => setState(() => _currentStep--),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colorScheme.outlineVariant),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Back'),
                  ),
                ),
              if (_currentStep > 0) const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: () async {
                    if (_currentStep < 5) {
                      setState(() => _currentStep++);
                    } else {
                      final vending = VendingProvider.of(
                        context,
                        listen: false,
                      );
                      final now = DateTime.now();
                      final visitDateStr =
                          '${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year}';
                      final hour = now.hour > 12
                          ? now.hour - 12
                          : (now.hour == 0 ? 12 : now.hour);
                      final ampm = now.hour >= 12 ? 'PM' : 'AM';
                      final timeStr =
                          '${hour}:${now.minute.toString().padLeft(2, '0')} ${ampm}';
                      final finalSlotQuantities = <String, int>{};
                      for (final e in _entries) {
                        finalSlotQuantities[e.slotId] =
                            e.countedQuantity + e.actualRestock;
                      }
                      final visit = InventoryVisit(
                        id: 'visit_${DateTime.now().millisecondsSinceEpoch}',
                        machineId: _machine.id,
                        machineName: _machine.name,
                        visitDate: visitDateStr,
                        completedAt: '${visitDateStr} at ${timeStr}',
                        notes: _notesController.text.trim(),
                        totalRevenue: _totalRevenue,
                        totalCost: _totalCost,
                        grossProfit: _totalGrossProfit,
                        totalUnitsSold: _totalSold,
                        totalAdjustments: _entries.fold(
                          0,
                          (sum, e) => sum + e.unitsDamaged,
                        ),
                        slotEntries: _entries,
                      );
                      await vending.completeVisit(
                        visit: visit,
                        finalSlotQuantities: finalSlotQuantities,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Visit completed! Recorded +\$${_totalRevenue.toStringAsFixed(2)} revenue and updated slot inventory.',
                            ),
                            duration: const Duration(seconds: 4),
                          ),
                        );
                        if (widget.onClose != null) {
                          widget.onClose!();
                        } else {
                          Navigator.of(context).maybePop();
                        }
                      }
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    _currentStep == 5
                        ? 'Complete Visit'
                        : 'Next Step (${steps[(_currentStep + 1).clamp(0, 5)]})',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: colorScheme.surfaceContainerLow,
            child: Row(
              children: List.generate(6, (index) {
                final isDone = index < _currentStep;
                final isCurrent = index == _currentStep;
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isDone || isCurrent
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _buildStepContent(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return _buildStep1Review(context);
      case 1:
        return _buildStep2Count(context);
      case 2:
        return _buildStep3Depletion(context);
      case 3:
        return _buildStep4Sales(context);
      case 4:
        return _buildStep5Restock(context);
      case 5:
        return _buildStep6Finish(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep1Review(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step 1: Machine Review',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Confirm machine details and recorded baseline inventory before counting.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _machine.locationName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(_machine.address, style: theme.textTheme.bodySmall),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Model: ${_machine.machineType}',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    'SN: ${_machine.serialNumber}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Recorded Baseline Slots (${_entries.length})',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        ..._entries.map(
          (e) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    e.slotId,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    e.productName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${e.openingQuantity} / ${e.capacity} pcs',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2Count(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step 2: Count Inventory',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Record new counted quantity in each slot.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            OutlinedButton(
              onPressed: _markAllUnchanged,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                minimumSize: const Size(40, 32),
              ),
              child: const Text(
                'All Unchanged',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._entries.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item.slotId,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Opening: ${item.openingQuantity} • Cap: ${item.capacity}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  icon: const Icon(Icons.remove, size: 18),
                  onPressed: () => _updateCount(index, -1),
                  style: IconButton.styleFrom(minimumSize: const Size(36, 36)),
                ),
                Container(
                  constraints: const BoxConstraints(minWidth: 38),
                  alignment: Alignment.center,
                  child: Text(
                    '${item.countedQuantity}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: () => _updateCount(index, 1),
                  style: IconButton.styleFrom(minimumSize: const Size(36, 36)),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStep3Depletion(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step 3: Depletion & Adjustment',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Raw depletion = Opening − Counted. Classify non-sales (damaged/missing).',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        ..._entries.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item.slotId} - ${item.productName}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Depleted: ${item.rawDepletion} pcs',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(
                          alpha: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Sold: ${item.unitsSold}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: Text(
                        item.unitsDamaged > 0 ? '1 Damaged' : 'Flag Damaged',
                        style: TextStyle(
                          fontSize: 11,
                          color: item.unitsDamaged > 0
                              ? colorScheme.error
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      selected: item.unitsDamaged > 0,
                      selectedColor: colorScheme.errorContainer,
                      onSelected: (_) => _toggleDamaged(index),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStep4Sales(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step 4: Visit Financials',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Sales revenue, cost of goods, and gross profit calculated from units sold.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Units Sold:', style: theme.textTheme.bodyMedium),
                  Text(
                    '${_totalSold} pcs',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Gross Revenue:', style: theme.textTheme.bodyMedium),
                  Text(
                    '\$${_totalRevenue.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cost of Goods (COGS):',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    '\$${_totalCost.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Estimated Gross Profit:',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '\$${_totalGrossProfit.toStringAsFixed(2)}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep5Restock(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step 5: Restock Quantities',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Recommended restock brings slots to target capacity. Adjust actual additions.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        ..._entries.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item.slotId,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Count: ${item.countedQuantity} • Target: ${item.targetQuantity} • Rec: +${item.recommendedRestock}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  icon: const Icon(Icons.remove, size: 18),
                  onPressed: () => _updateRestock(index, -1),
                  style: IconButton.styleFrom(minimumSize: const Size(36, 36)),
                ),
                Container(
                  constraints: const BoxConstraints(minWidth: 38),
                  alignment: Alignment.center,
                  child: Text(
                    '+${item.actualRestock}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: () => _updateRestock(index, 1),
                  style: IconButton.styleFrom(minimumSize: const Size(36, 36)),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStep6Finish(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step 6: Review & Finalize',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Confirm visit totals before generating immutable visit snapshot.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Machine:'),
                  Text(
                    _machine.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Items Sold:'),
                  Text(
                    '${_totalSold} units',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Restocked:'),
                  Text(
                    '+${_totalRestocked} units',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Revenue:'),
                  Text(
                    '\$${_totalRevenue.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Gross Profit:'),
                  Text(
                    '\$${_totalGrossProfit.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Visit Notes (Optional)',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'e.g. Cleaned bill validator, replaced coin tube...',
            filled: true,
            fillColor: colorScheme.surfaceContainerLowest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
