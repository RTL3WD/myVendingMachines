# Vending Fleet Manager

A local-first Flutter application for independent vending machine operators to manage machine fleets, product slot blueprint libraries, guided restocking visits, and inventory-derived sales and profits.

### Design Brief & Agreed Architecture
- **Purpose**: Field operations, machine visit workflows, slot restocking, and inventory-derived sales tracking.
- **Audience & Identity**: Single business owner on their own device (iOS, Android, and responsive Web). No cloud auth or external backend needed for initial version.
- **Visual Style**: Emerald & Steel — crisp modern emerald green accent with clean slate neutral surfaces, high-contrast operational badges, and clear data density.
- **Typography**: Inter font family for high legibility on small numbers, currency values, and slot IDs.
- **Slot Display**: Tray-grouped hierarchy (A-tray, B-tray, etc.) with quick batch actions and stepper controls.
- **Visit Workflow**: Step-by-step guided wizard (Review -> Count -> Depletion classification -> Sales calculation -> Restock recommendation -> Completion).
- **Dashboard Priority**: Operational urgency first (overdue and due visits, route status) accompanied by financial revenue and gross profit metrics.
- **Persistence Strategy (for Agent mode)**: Local SQLite/Drift or Hive/Isar with schema versioning and full CSV export/restore capabilities.

