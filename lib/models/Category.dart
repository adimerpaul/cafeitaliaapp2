import 'package:hive/hive.dart';
part  'Category.g.dart';

@HiveType(typeId: 1)
class Category {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String icon;

  Category({
    required this.id,
    required this.name,
    required this.icon,
  });
}