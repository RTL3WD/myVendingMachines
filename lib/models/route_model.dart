import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class RouteModel {
  const RouteModel({
    required this.id,
    required this.name,
    this.description = '',
    this.colorHex = '0xFF0F8A5F',
    this.isArchived = false,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      colorHex: json['colorHex'] as String? ?? '0xFF0F8A5F',
      isArchived: json['isArchived'] as bool? ?? false,
    );
  }

  final String id;

  final String name;

  final String description;

  final String colorHex;

  final bool isArchived;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'colorHex': colorHex,
      'isArchived': isArchived,
    };
  }
}
