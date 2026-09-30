import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';
import 'package:fleetflow/globals/vending_provider.dart';
import 'package:fleetflow/models/product_blueprint.dart';

@NowaGenerated()
class ProductsLibraryScreen extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const ProductsLibraryScreen({super.key});

  @override
  State<ProductsLibraryScreen> createState() {
    return _ProductsLibraryScreenState();
  }
}

@NowaGenerated()
class _ProductsLibraryScreenState extends State<ProductsLibraryScreen> {
  String _selectedCategory = 'All';

  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = const [
    'All',
    'Cold Beverages',
    'Energy Drinks',
    'Snacks & Chips',
    'Candy & Chocolate',
    'Healthy & Bars',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddProductDialog(
    BuildContext context, {
    String initialBarcode = '',
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final vending = VendingProvider.of(context, listen: false);
    final nameController = TextEditingController();
    final brandController = TextEditingController();
    final sizeController = TextEditingController(text: '12 oz');
    final barcodeController = TextEditingController(text: initialBarcode);
    final costController = TextEditingController(text: '0.75');
    final priceController = TextEditingController(text: '2.00');
    String selectedCat = 'Cold Beverages';
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
                      'Create Product Blueprint',
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
                    labelText: 'Product Name *',
                    hintText: 'e.g. Sprite Lemon-Lime',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: brandController,
                        decoration: InputDecoration(
                          labelText: 'Brand',
                          hintText: 'e.g. Coca-Cola',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: sizeController,
                        decoration: InputDecoration(
                          labelText: 'Package Size',
                          hintText: 'e.g. 12 oz can',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedCat,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Cold Beverages',
                      child: Text('Cold Beverages'),
                    ),
                    DropdownMenuItem(
                      value: 'Energy Drinks',
                      child: Text('Energy Drinks'),
                    ),
                    DropdownMenuItem(
                      value: 'Snacks & Chips',
                      child: Text('Snacks & Chips'),
                    ),
                    DropdownMenuItem(
                      value: 'Candy & Chocolate',
                      child: Text('Candy & Chocolate'),
                    ),
                    DropdownMenuItem(
                      value: 'Healthy & Bars',
                      child: Text('Healthy & Bars'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setModalState(() => selectedCat = val!);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: barcodeController,
                  decoration: InputDecoration(
                    labelText: 'UPC / Barcode *',
                    hintText: 'e.g. 049000028904',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: costController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Default Cost (\$)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Default Sale (\$)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      final name = nameController.text.trim();
                      final barcode = barcodeController.text.trim();
                      if (name.isEmpty || barcode.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please enter a product name and barcode.',
                            ),
                          ),
                        );
                        return;
                      }
                      final existing = vending.products
                          .where((p) => p.barcode == barcode)
                          .toList();
                      if (existing.isNotEmpty) {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (c) => AlertDialog(
                            title: const Text('Duplicate Barcode'),
                            content: Text(
                              'A product "${existing.first.name}" already uses barcode "${barcode}". Do you want to continue?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(c).pop(false),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.of(c).pop(true),
                                child: const Text('Save Anyway'),
                              ),
                            ],
                          ),
                        );
                        if (confirm != true) {
                          return;
                        }
                      }
                      final cost =
                          double.tryParse(costController.text.trim()) ?? 0.75;
                      final price =
                          double.tryParse(priceController.text.trim()) ?? 2;
                      final newProd = ProductBlueprint(
                        id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
                        name: name,
                        barcode: barcode,
                        category: selectedCat,
                        brand: brandController.text.trim().isEmpty
                            ? 'General'
                            : brandController.text.trim(),
                        packageSize: sizeController.text.trim().isEmpty
                            ? 'Standard'
                            : sizeController.text.trim(),
                        defaultPurchasePrice: cost,
                        defaultSalePrice: price,
                      );
                      await vending.addProduct(newProd);
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Product "${newProd.name}" added to master library!',
                          ),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Save to Catalog',
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

  void _showScanDialog(BuildContext context) {
    final barcodeController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: const [
            Icon(Icons.qr_code_scanner_rounded),
            SizedBox(width: 8),
            Text('Scan or Enter Barcode'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Point your camera at a product barcode or enter the number below:',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: barcodeController,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'UPC Barcode Digits',
                hintText: 'e.g. 028400040112',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final code = barcodeController.text.trim();
              Navigator.of(ctx).pop();
              if (code.isEmpty) {
                return;
              }
              final vending = VendingProvider.of(context, listen: false);
              final match = vending.products
                  .where((p) => p.barcode == code)
                  .toList();
              if (match.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Found item: ${match.first.name}! Filtering catalog.',
                    ),
                  ),
                );
                setState(() {
                  _searchController.text = code;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Barcode ${code} not in catalog. Opening new product form...',
                    ),
                  ),
                );
                _showAddProductDialog(context, initialBarcode: code);
              }
            },
            child: const Text('Look Up'),
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
    final products = vending.products;
    final filteredProducts = products.where((p) {
      final matchesCategory =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      final query = _searchController.text.toLowerCase();
      final matchesQuery =
          query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          p.brand.toLowerCase().contains(query) ||
          p.barcode.contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Blueprints'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded),
            tooltip: 'Scan Barcode',
            onPressed: () => _showScanDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Blueprint',
            onPressed: () => _showAddProductDialog(context),
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
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search by name, brand, or barcode...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
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
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
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
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 48,
                            color: colorScheme.outline,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No products found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Try adjusting your search filter or add a new blueprint.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () => _showAddProductDialog(context),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Add Blueprint'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: filteredProducts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final prod = filteredProducts[index];
                      final marginPercent =
                          ((prod.defaultSalePrice - prod.defaultPurchasePrice) /
                                  prod.defaultSalePrice *
                                  100)
                              .toStringAsFixed(0);
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colorScheme.outlineVariant),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.inventory_2_outlined,
                                color: colorScheme.secondary,
                                size: 24,
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
                                          prod.name,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: colorScheme.onSurface,
                                              ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.primaryContainer
                                              .withValues(alpha: 0.6),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          '${marginPercent}% margin',
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                                color: colorScheme
                                                    .onPrimaryContainer,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${prod.brand} • ${prod.packageSize} • ${prod.category}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.qr_code,
                                        size: 14,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        prod.barcode,
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              fontFamily: 'monospace',
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        'Cost: \$${prod.defaultPurchasePrice.toStringAsFixed(2)}  →  Sell: \$${prod.defaultSalePrice.toStringAsFixed(2)}',
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme.onSurface,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
