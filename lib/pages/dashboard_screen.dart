import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:fleetflow/globals/vending_provider.dart';
import 'package:fleetflow/components/dashboard_urgency_card.dart';
import 'package:fleetflow/components/dashboard_kpi_card.dart';
import 'package:fleetflow/models/machine.dart';
import 'package:fleetflow/components/machine_performance_row.dart';

@NowaGenerated()
class DashboardScreen extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const DashboardScreen({
    super.key,
    required this.onNavigateToMachine,
    required this.onStartVisit,
  });

  final void Function(String machineId) onNavigateToMachine;

  final void Function(String machineId) onStartVisit;

  @override
  State<DashboardScreen> createState() {
    return _DashboardScreenState();
  }
}

@NowaGenerated()
class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedDateRange = 'This Month';

  String _sortBy = 'Revenue';

  final List<String> _dateRangePresets = const [
    'Today',
    'This Week',
    'This Month',
    'Last 30 Days',
    'Custom',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final vending = VendingProvider.of(context);
    final machines = vending.machines;
    final overdueMachines = machines
        .where((m) => vending.getScheduleStatus(m) == 'Overdue')
        .toList();
    final dueTodayMachines = machines
        .where((m) => vending.getScheduleStatus(m) == 'Due Today')
        .toList();
    final urgentCount = overdueMachines.length + dueTodayMachines.length;
    final List<Map<String, dynamic>> performanceList = machines.map((m) {
      final visits = vending.getVisitsForMachine(m.id);
      final mUnits = visits.fold<int>(0, (sum, v) => sum + v.totalUnitsSold);
      final mRev = visits.fold<double>(0.0, (sum, v) => sum + v.totalRevenue);
      final mProfit = visits.fold<double>(0.0, (sum, v) => sum + v.grossProfit);
      return {
        'machine': m,
        'units': mUnits,
        'revenue': mRev,
        'profit': mProfit,
      };
    }).toList();
    performanceList.sort((a, b) {
      if (_sortBy == 'Units Sold') {
        return (b['units'] as int).compareTo(a['units'] as int);
      } else if (_sortBy == 'Profit') {
        return (b['profit'] as double).compareTo(a['profit'] as double);
      } else {
        return (b['revenue'] as double).compareTo(a['revenue'] as double);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vending Fleet Manager',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              'Field Operations & Sales',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'Reminders & Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications active for overdue visits'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _dateRangePresets.map((preset) {
                  final isSelected = _selectedDateRange == preset;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(preset),
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
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedDateRange = preset;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            if (urgentCount > 0) ...[
              Row(
                children: [
                  Icon(Icons.bolt, color: colorScheme.error, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    'Urgent Field Restocks',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${urgentCount} Needs Visit',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...overdueMachines.map(
                (m) => DashboardUrgencyCard(
                  machine: m,
                  statusText: 'OVERDUE',
                  isOverdue: true,
                  onTapMachine: () => widget.onNavigateToMachine(m.id),
                  onStartVisit: () => widget.onStartVisit(m.id),
                ),
              ),
              ...dueTodayMachines.map(
                (m) => DashboardUrgencyCard(
                  machine: m,
                  statusText: 'DUE TODAY',
                  isOverdue: false,
                  onTapMachine: () => widget.onNavigateToMachine(m.id),
                  onStartVisit: () => widget.onStartVisit(m.id),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              'Fleet Performance (${_selectedDateRange})',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 550;
                final cards = [
                  DashboardKpiCard(
                    title: 'TOTAL REVENUE',
                    value: '\$${vending.totalRevenue.toStringAsFixed(2)}',
                    subtitle: '+14.2% from last cycle',
                    icon: Icons.attach_money_rounded,
                  ),
                  DashboardKpiCard(
                    title: 'GROSS PROFIT',
                    value: '\$${vending.totalGrossProfit.toStringAsFixed(2)}',
                    subtitle: vending.totalRevenue > 0
                        ? '${((vending.totalGrossProfit / vending.totalRevenue) * 100).toStringAsFixed(1)}% gross margin'
                        : '0.0% gross margin',
                    icon: Icons.trending_up_rounded,
                  ),
                  DashboardKpiCard(
                    title: 'UNITS SOLD',
                    value: '${vending.totalUnitsSold} pcs',
                    subtitle: '${vending.totalAdjustments} adjustments',
                    icon: Icons.shopping_bag_outlined,
                  ),
                  DashboardKpiCard(
                    title: 'ACTIVE FLEET',
                    value: '${machines.length} Machines',
                    subtitle: '${vending.routes.length} Routes active',
                    icon: Icons.storefront_outlined,
                  ),
                ];
                if (isWide) {
                  return GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: cards,
                  );
                } else {
                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.35,
                    children: cards,
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Machine Sales Breakdown',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  initialValue: _sortBy,
                  tooltip: 'Sort by',
                  onSelected: (val) {
                    setState(() {
                      _sortBy = val;
                    });
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'Revenue',
                      child: Text('Sort by Revenue'),
                    ),
                    PopupMenuItem(
                      value: 'Profit',
                      child: Text('Sort by Profit'),
                    ),
                    PopupMenuItem(
                      value: 'Units Sold',
                      child: Text('Sort by Units Sold'),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Sort: ${_sortBy}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 18,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...performanceList.map((item) {
              final m = item['machine'] as Machine;
              final units = item['units'] as int;
              final rev = item['revenue'] as double;
              final profit = item['profit'] as double;
              return MachinePerformanceRow(
                machineName: m.name,
                locationName: m.locationName,
                unitsSold: units,
                revenue: rev,
                grossProfit: profit,
                lastVisitDate: m.lastVisitDate,
                onTap: () => widget.onNavigateToMachine(m.id),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
