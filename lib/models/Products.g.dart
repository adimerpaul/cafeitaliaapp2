// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Products.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as int,
      name: fields[1] as String,
      price: fields[2] as double,
      imagen: fields[3] as String,
      cantidad: fields[4] as int,
      category_id: fields[5] as int,
      categoryName: fields[6] as String,
      color: fields[7] as String,
      cantidadCarrito: fields[8] as int,
      llevar: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.imagen)
      ..writeByte(4)
      ..write(obj.cantidad)
      ..writeByte(5)
      ..write(obj.category_id)
      ..writeByte(6)
      ..write(obj.categoryName)
      ..writeByte(7)
      ..write(obj.color)
      ..writeByte(8)
      ..write(obj.cantidadCarrito)
      ..writeByte(9)
      ..write(obj.llevar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
