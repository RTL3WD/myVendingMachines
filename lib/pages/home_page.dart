import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:fleetflow/pages/dashboard_screen.dart';
import 'package:fleetflow/pages/machine_list_screen.dart';
import 'package:fleetflow/pages/products_library_screen.dart';
import 'package:fleetflow/pages/sales_reports_screen.dart';
import 'package:fleetflow/pages/more_options_screen.dart';
import 'package:fleetflow/pages/visit_wizard_screen.dart';
import 'package:fleetflow/pages/machine_detail_screen.dart';
import 'package:fleetflow/pages/route_management_screen.dart';
import 'package:fleetflow/pages/csv_backup_screen.dart';

@NowaGenerated()
class HomePage extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

@NowaGenerated()
class _HomePageState extends State<HomePage> {
  int _selectedTabIndex = 0;

  String? _viewingMachineId;

  String? _wizardMachineId;

  bool _isViewingRoutes = false;

  bool _isViewingBackup = false;

  void _navigateToMachine(String machineId) {
    setState(() {
      _viewingMachineId = machineId;
      _wizardMachineId = null;
      _isViewingRoutes = false;
      _isViewingBackup = false;
    });
  }

  void _startVisit(String machineId) {
    setState(() {
      _wizardMachineId = machineId;
      _isViewingRoutes = false;
      _isViewingBackup = false;
    });
  }

  void _closeWizard() {
    setState(() {
      _wizardMachineId = null;
    });
  }

  void _backFromMachine() {
    setState(() {
      _viewingMachineId = null;
    });
  }

  Widget _buildTabBody() {
    switch (_selectedTabIndex) {
      case 0:
        return DashboardScreen(
          onNavigateToMachine: _navigateToMachine,
          onStartVisit: _startVisit,
        );
      case 1:
        return MachineListScreen(
          onSelectMachine: _navigateToMachine,
          onStartVisit: _startVisit,
        );
      case 2:
        return const ProductsLibraryScreen();
      case 3:
        return const SalesReportsScreen();
      case 4:
        return MoreOptionsScreen(
          onOpenRoutes: () => setState(() => _isViewingRoutes = true),
          onOpenBackup: () => setState(() => _isViewingBackup = true),
        );
      default:
        return DashboardScreen(
          onNavigateToMachine: _navigateToMachine,
          onStartVisit: _startVisit,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    if (_wizardMachineId != null) {
      return VisitWizardScreen(
        machineId: _wizardMachineId!,
        onClose: _closeWizard,
      );
    }
    if (_viewingMachineId != null) {
      return MachineDetailScreen(
        machineId: _viewingMachineId!,
        onBack: _backFromMachine,
        onStartVisit: _startVisit,
      );
    }
    if (_isViewingRoutes) {
      return RouteManagementScreen(
        onBack: () => setState(() => _isViewingRoutes = false),
      );
    }
    if (_isViewingBackup) {
      return CsvBackupScreen(
        onBack: () => setState(() => _isViewingBackup = false),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;
        if (isWide) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedTabIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_shipping_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard_rounded),
                      label: Text('Dashboard'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.storefront_outlined),
                      selectedIcon: Icon(Icons.storefront_rounded),
                      label: Text('Machines'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.inventory_2_outlined),
                      selectedIcon: Icon(Icons.inventory_2_rounded),
                      label: Text('Products'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.insights_outlined),
                      selectedIcon: Icon(Icons.insights_rounded),
                      label: Text('Sales'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.more_horiz_rounded),
                      selectedIcon: Icon(Icons.more_horiz_rounded),
                      label: Text('More'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: _buildTabBody()),
              ],
            ),
          );
        }
        return Scaffold(
          body: _buildTabBody(),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedTabIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.storefront_outlined),
                selectedIcon: Icon(Icons.storefront_rounded),
                label: 'Machines',
              ),
              NavigationDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2_rounded),
                label: 'Products',
              ),
              NavigationDestination(
                icon: Icon(Icons.insights_outlined),
                selectedIcon: Icon(Icons.insights_rounded),
                label: 'Sales',
              ),
              NavigationDestination(
                icon: Icon(Icons.more_horiz_rounded),
                selectedIcon: Icon(Icons.more_horiz_rounded),
                label: 'More',
              ),
            ],
          ),
        );
      },
    );
  }
}
