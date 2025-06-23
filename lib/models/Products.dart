import 'package:hive/hive.dart';
part 'Products.g.dart';

@HiveType(typeId: 0)
class Product {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double price;
  @HiveField(3)
  final String imagen;
  @HiveField(4)
  final int cantidad;
  @HiveField(5)
  final int category_id;
  @HiveField(6)
  final String categoryName;
  @HiveField(7)
  final String color;
  @HiveField(8)
  int cantidadCarrito = 0;
  @HiveField(9)
  String llevar = 'NO';
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imagen,
    required this.cantidad,
    required this.category_id,
    required this.categoryName,
    required this.color,
    required this.cantidadCarrito,
    required this.llevar,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imagen': imagen,
      'cantidad': cantidad,
      'category_id': category_id,
      'categoryName': categoryName,
      'color': color,
      'cantidadCarrito': cantidadCarrito,
      'llevar': llevar,
    };
  }
}