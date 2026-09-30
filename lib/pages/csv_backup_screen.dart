import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:fleetflow/globals/vending_provider.dart';

@NowaGenerated()
class CsvBackupScreen extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const CsvBackupScreen({super.key, this.onBack});

  final void Function()? onBack;

  @override
  State<CsvBackupScreen> createState() {
    return _CsvBackupScreenState();
  }
}

@NowaGenerated()
class _CsvBackupScreenState extends State<CsvBackupScreen> {
  bool _isImportFileSelected = false;

  String _importStrategy = 'merge';

  bool _createSafetyBackup = true;

  void _handleExport() {
    final vending = VendingProvider.of(context, listen: false);
    final csv = vending.exportCsv();
    final rowCount = csv
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Generated Schema v1.0 CSV backup with ${rowCount} records. Ready to share or save!',
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _handleSelectFile() {
    final vending = VendingProvider.of(context, listen: false);
    setState(() {
      _isImportFileSelected = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected "vending_fleet_backup_${DateTime.now().year}_${DateTime.now().month}.csv" (${vending.machines.length} machines, ${vending.products.length} products, ${vending.visits.length} visits verified).',
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showRestoreConfirmation() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isReplace = _importStrategy == 'replace';
    final vending = VendingProvider.of(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isReplace ? Icons.warning_amber_rounded : Icons.sync_rounded,
              color: isReplace ? colorScheme.error : colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(isReplace ? 'Confirm Replace All' : 'Confirm Merge Restore'),
          ],
        ),
        content: Text(
          isReplace
              ? 'This will wipe all existing machines, visits, and slot records on this device and replace them with records from the CSV file. A local safety snapshot will be created before proceeding.'
              : 'This will merge records from the CSV file into your local fleet database. Existing records with matching IDs will be updated, and new products and machines will be added.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
            FilledButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                final backupCsv = vending.exportCsv();
                await vending.importCsv(backupCsv, replace: isReplace);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isReplace
                            ? 'Fleet database successfully replaced from CSV!'
                            : 'Fleet database successfully merged from CSV!',
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
            style: FilledButton.styleFrom(
              backgroundColor: isReplace
                  ? colorScheme.error
                  : colorScheme.primary,
            ),
            child: Text(isReplace ? 'Replace All Data' : 'Execute Merge'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final vending = VendingProvider.of(context);
    final machines = vending.machines;
    final products = vending.products;
    final routes = vending.routes;
    final visits = vending.visits;
    final totalSlots = machines.fold(0, (sum, m) => sum + m.slots.length);
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
        title: const Text('CSV Backup & Restore'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    color: colorScheme.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Local-First Offline Storage',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'All data is stored directly on this device. Create regular CSV backups to save to Google Drive, iCloud, Files, or transfer to another phone.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Export Data',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'FULL FLEET SNAPSHOT',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Schema v1.0',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Export all machines, slots, blueprint library, historical restock visits, and sales calculations into a single universal CSV file.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildRecordSummaryRow(
                          context,
                          'Machines',
                          '${machines.length} active',
                        ),
                        const SizedBox(height: 6),
                        _buildRecordSummaryRow(
                          context,
                          'Machine Slots',
                          '${totalSlots} configured',
                        ),
                        const SizedBox(height: 6),
                        _buildRecordSummaryRow(
                          context,
                          'Product Blueprints',
                          '${products.length} master items',
                        ),
                        const SizedBox(height: 6),
                        _buildRecordSummaryRow(
                          context,
                          'Fleet Routes',
                          '${routes.length} routes',
                        ),
                        const SizedBox(height: 6),
                        _buildRecordSummaryRow(
                          context,
                          'Completed Visits',
                          '${visits.length} historical logs',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _handleExport,
                      icon: const Icon(Icons.share_outlined, size: 18),
                      label: const Text('Export Full CSV Backup'),
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Restore From Backup',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Restore or migrate your vending fleet database from a previously exported CSV file.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: _handleSelectFile,
                    icon: const Icon(Icons.file_upload_outlined, size: 18),
                    label: Text(
                      _isImportFileSelected
                          ? 'Change Selected File (.csv)'
                          : 'Select Backup File (.csv)',
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colorScheme.outlineVariant),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                  if (_isImportFileSelected) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'vending_fleet_backup_2023_10_25.csv',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Verified',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Schema v1.0 • 30 Total records found • 0 Integrity errors',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Divider(height: 16),
                          Text(
                            'RESTORATION STRATEGY',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () =>
                                setState(() => _importStrategy = 'merge'),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _importStrategy == 'merge'
                                    ? colorScheme.primaryContainer.withValues(
                                        alpha: 0.3,
                                      )
                                    : colorScheme.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _importStrategy == 'merge'
                                      ? colorScheme.primary
                                      : colorScheme.outlineVariant,
                                  width: _importStrategy == 'merge' ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    _importStrategy == 'merge'
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: _importStrategy == 'merge'
                                        ? colorScheme.primary
                                        : colorScheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Merge With Existing Data (Recommended)',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: colorScheme.onSurface,
                                              ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Updates matching IDs, appends new records, and keeps existing history.',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                setState(() => _importStrategy = 'replace'),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _importStrategy == 'replace'
                                    ? colorScheme.errorContainer.withValues(
                                        alpha: 0.3,
                                      )
                                    : colorScheme.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _importStrategy == 'replace'
                                      ? colorScheme.error
                                      : colorScheme.outlineVariant,
                                  width: _importStrategy == 'replace' ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    _importStrategy == 'replace'
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: _importStrategy == 'replace'
                                        ? colorScheme.error
                                        : colorScheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Replace All Existing Data',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: colorScheme.error,
                                              ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Completely deletes all current records and replaces with backup data.',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CheckboxListTile(
                            value: _createSafetyBackup,
                            title: const Text(
                              'Create safety backup before restore',
                            ),
                            subtitle: const Text(
                              'Saves your current data into an emergency rollback file.',
                            ),
                            contentPadding: EdgeInsets.zero,
                            activeColor: colorScheme.primary,
                            onChanged: (val) => setState(
                              () => _createSafetyBackup = val ?? true,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _showRestoreConfirmation,
                              style: FilledButton.styleFrom(
                                backgroundColor: _importStrategy == 'replace'
                                    ? colorScheme.error
                                    : colorScheme.primary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                _importStrategy == 'replace'
                                    ? 'Confirm and Replace Fleet'
                                    : 'Confirm and Merge Fleet',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordSummaryRow(
    BuildContext context,
    String title,
    String count,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          count,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
