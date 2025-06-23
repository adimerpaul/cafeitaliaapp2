import 'dart:convert';

import 'package:cafeitalia/models/Category.dart';
import 'package:cafeitalia/models/Products.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
class ImportService{
  final API_BACK = dotenv.env['API_BACK'];
  Future importDatos() async{
    var uri = Uri.parse(API_BACK! + '/import');
    var response = await http.get(uri);
    if(response.statusCode == 200){
      final jsonRes = json.decode(response.body);
      final categories = jsonRes['categories'];
      final products = jsonRes['products'];
      var categoriesBox = await Hive.openBox<Category>('categories');
      categoriesBox.clear();
      var productsBox = await Hive.openBox<Product>('products');
      productsBox.clear();
      categories.forEach((category) async {
        await categoriesBox.put(category['id'], Category(
          id: int.parse(category['id'].toString()),
          name: category['name'].toString(),
          icon: category['icon'].toString(),
        ));
      });
      products.forEach((product) async {
        // print(product['id']);
        await productsBox.put(product['id'], Product(
        id: int.parse(product['id'].toString()),
        name: product['name'].toString(),
        price: double.parse(product['price'].toString()),
        imagen: product['imagen'].toString(),
        cantidad: int.parse(product['cantidad'].toString()),
        category_id: int.parse(product['category_id'].toString()),
        categoryName: product['category']['name'].toString(),
        color: product['color'].toString(),
        cantidadCarrito: 0,
        llevar: 'NO',
        ));
      });
      return response.body;
    }else{
      throw Exception('Error al importar');
    }
  }
  Future order(int mesa, double total, List<Product> products) async{
    var uri = Uri.parse(API_BACK! + '/order');
    var productsJson = products.map((product) => product.toJson()).toList();
    print('body:');
    print({
      'mesa': mesa.toString(),
      'total': total.toString(),
      'detail': json.encode(productsJson),
    });
    // print errror url
    print('url: $uri');
    var response = await http.post(uri,
        headers: {'Accept': 'application/json'},
        body: {
          'mesa': mesa.toString(),
          'total': total.toString(),
          'detail': json.encode(productsJson),
        }
    );

    if(response.statusCode == 201){
      return response.body;
    }else{
      print('Error al importar order: ${response.statusCode}');
      throw Exception('Error al importar order');
    }
  }
  //aumentarPedido
  Future aumentarPedido(int id, List<Product> products) async{
    var uri = Uri.parse(API_BACK! + '/aumentarPedido');
    var productsJson = products.map((product) => product.toJson()).toList();
    var response = await http.post(uri,
        headers: {'Accept': 'application/json'},
        body: {
          'id': id.toString(),
          'detail': json.encode(productsJson),
        }
    );
    if(response.statusCode == 201){
      return response.body;
    }else{
      throw Exception('Error al importar');
    }
  }


  Future<List> orderPending() async{
    var uri = Uri.parse(API_BACK! + '/orderPending');
    var response = await http.get(uri,
        headers: {'Accept': 'application/json'},
    );
    if(response.statusCode == 200){
      final jsonRes = json.decode(response.body);
      return jsonRes;
    }else{
      throw Exception('Error al importar');
    }
  }
}