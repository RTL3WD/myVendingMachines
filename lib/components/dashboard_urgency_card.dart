import 'package:flutter/material.dart';
import 'package:fleetflow/models/machine.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class DashboardUrgencyCard extends StatelessWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const DashboardUrgencyCard({
    super.key,
    required this.machine,
    required this.statusText,
    required this.isOverdue,
    required this.onStartVisit,
    required this.onTapMachine,
  });

  final Machine machine;

  final String statusText;

  final bool isOverdue;

  final void Function() onStartVisit;

  final void Function() onTapMachine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = isOverdue ? colorScheme.error : colorScheme.tertiary;
    final statusBgColor = isOverdue
        ? colorScheme.errorContainer
        : colorScheme.tertiaryContainer;
    return InkWell(
      onTap: onTapMachine,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isOverdue
                ? colorScheme.error.withValues(alpha: 0.3)
                : colorScheme.outlineVariant,
            width: isOverdue ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isOverdue
                    ? Icons.warning_amber_rounded
                    : Icons.schedule_rounded,
                color: statusColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          machine.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statusText,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    machine.locationName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Last visit: ${machine.lastVisitDate} • Due: ${machine.nextVisitDate}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.tonal(
              onPressed: onStartVisit,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                minimumSize: const Size(44, 40),
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
              ),
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
