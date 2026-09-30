import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:fleetflow/pages/route_management_screen.dart';
import 'package:fleetflow/pages/csv_backup_screen.dart';

@NowaGenerated()
class MoreOptionsScreen extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const MoreOptionsScreen({super.key, this.onOpenRoutes, this.onOpenBackup});

  final void Function()? onOpenRoutes;

  final void Function()? onOpenBackup;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('More & Management')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          _buildSectionHeader(context, 'OPERATIONS'),
          _buildTile(
            context,
            icon: Icons.alt_route_rounded,
            title: 'Fleet Routes',
            subtitle: '3 Active routes configured',
            onTap: () {
              if (onOpenRoutes != null) {
                onOpenRoutes!();
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const RouteManagementScreen(),
                  ),
                );
              }
            },
          ),
          _buildTile(
            context,
            icon: Icons.notifications_active_outlined,
            title: 'Visit Reminder Schedules',
            subtitle: 'Custom intervals & device notifications',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reminder settings')),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildSectionHeader(context, 'DATA & STORAGE'),
          _buildTile(
            context,
            icon: Icons.cloud_download_outlined,
            title: 'CSV Backup & Restore',
            subtitle: 'Full device snapshot export & import verification',
            onTap: () {
              if (onOpenBackup != null) {
                onOpenBackup!();
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CsvBackupScreen()),
                );
              }
            },
          ),
          _buildTile(
            context,
            icon: Icons.folder_zip_outlined,
            title: 'Export Schema Info',
            subtitle: 'Vending Fleet Schema v1.0 • Offline Ready',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildSectionHeader(context, 'SYSTEM & ABOUT'),
          _buildTile(
            context,
            icon: Icons.info_outline_rounded,
            title: 'Vending Fleet Manager',
            subtitle: 'Version 1.0.0 (Local-First MVP)',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
      child: Text(
        title,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurfaceVariant,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required void Function() onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 22),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}
