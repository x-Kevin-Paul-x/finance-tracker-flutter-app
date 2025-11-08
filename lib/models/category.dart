class CategoryModel {
  final String id;
  final String name;
  final String icon; // use emoji or font_awesome names
  final String color; // hex string
  final String type; // 'income' or 'expense'

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'icon': icon,
        'color': color,
        'type': type,
      };

  factory CategoryModel.fromMap(Map<String, dynamic> m) => CategoryModel(
        id: m['id'] as String,
        name: m['name'] as String,
        icon: m['icon'] as String,
        color: m['color'] as String,
        type: m['type'] as String,
      );
}
