import 'package:cafeitalia/components/MyCard.dart';
import 'package:cafeitalia/components/MyDialog.dart';
import 'package:cafeitalia/components/MyTab.dart';
import 'package:cafeitalia/models/Category.dart';
import 'package:cafeitalia/models/Products.dart';
import 'package:cafeitalia/pages/PedidoPage.dart';
import 'package:cafeitalia/services/ImportService.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final url_back = dotenv.env['API_BACK'];
  int cartItems = 0;
  double total = 0;
  bool _loading = false;
  String textCategory = 'TODO';
  int category_id = 0;
  List<Category> categories = [];
  List<Product> products = [];
  List<Product> productsAll = [];
  List<Widget> tabs = [];
  int selectedMesa = 0;
  String searchTerm = '';
  TextEditingController searchController = TextEditingController();
  import() async {
    setState(() {
      _loading = true;
    });
    await ImportService().importDatos();
    getDatos();
    setState(() {
      _loading = false;
    });
  }

  @override
  initState() {
    super.initState();
    getDatos();
  }
  getDatos() async {
    var categoriesBox = await Hive.openBox<Category>('categories');
    categories = categoriesBox.values.toList();
    var productsBox = await Hive.openBox<Product>('products');
    products = productsBox.values.toList();
    products.sort((a, b) => a.category_id.compareTo(b.category_id));
    productsAll = products;
    setState(() {});
  }

  filtrarCategoria(int category_id){
    if(category_id == 0){
      products = productsAll;
    }else{
      products = productsAll.where((element) => element.category_id == category_id).toList();
    }
  }
  cantidadPedida(){
    cartItems = 0;
    total = 0;
    productsAll.forEach((element) {
      cartItems += element.cantidadCarrito;
      total += element.cantidadCarrito * element.price;
    });
    setState(() {});
  }
  productConCarrito(List<Product> products){
    List<Product> productsCarrito = [];
    products.forEach((element) {
      if(element.cantidadCarrito > 0){
        productsCarrito.add(element);
      }
    });
    return productsCarrito;
  }
  void filtrarProductosPorNombre() {
    if (searchTerm.isEmpty) {
      // Si el término de búsqueda está vacío, mostrar todos los productos
      products = productsAll;
    } else {
      // Filtrar productos por el nombre que contiene el término de búsqueda
      products = productsAll.where((product) =>
          product.name.toLowerCase().contains(searchTerm)).toList();
    }
    setState(() {});
  }
  void MyChangeLlevar(int index) {
    // print(index);
    setState(() {
      products[index].llevar = products[index].llevar == 'SI' ? 'NO' : 'SI';
    });
    //abiri el dialog
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Icon(
              Icons.menu,
              color: Colors.grey[900],
              size: 36,
            ),
          ),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // primary: Colors.purple,
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
                onPressed: (){
                  //ir a pagina de pedido
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PedidoPage(products: productConCarrito(productsAll))),
                  );
                },
                child: Text(
                  'Ver pedidos',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
            ),
            TextButton(
            onPressed: () {
              showDialog(
              context: context,
                builder: (BuildContext context) {
                  return MyDialog(
                      total: total,
                      mesa: selectedMesa + 1,
                      products: productConCarrito(productsAll),
                      order_id: 0,
                      callback: () {
                        setState(() {
                          products.forEach((element) {
                            element.cantidadCarrito = 0;
                            element.llevar = 'NO';
                          });
                          productsAll.forEach((element) {
                            element.cantidadCarrito = 0;
                            element.llevar = 'NO';
                          });
                          cantidadPedida();
                        });
                      },
                      changeLlevar: MyChangeLlevar
                  );
                }
              );
            },
              child: Text(
                'Total: Bs ${total}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child:
              cartItems != 0 ?
              badges.Badge(
                position: badges.BadgePosition.topEnd(top: -10, end: -12),
                badgeContent: Text(
                  cartItems.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.grey[900],
                  size: 36,
                ),
              ):
              Icon(
                Icons.shopping_cart,
                color: Colors.grey[900],
                size: 36,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(10, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            selectedMesa = index;
                          });
                        },
                        child: Text(
                          'M${index + 1}',
                          style: TextStyle(
                            fontSize: 18,
                            color: selectedMesa == index ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          // primary: selectedMesa == index ? Colors.purple : Colors.grey[300],
                          backgroundColor: selectedMesa == index ? Colors.purple : Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Row(
                children: [
                  Text(
                    'Productos ',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '(${productsAll.length})',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _loading ? null : import,
                    child: _loading? CircularProgressIndicator() : Text(
                      'Import',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      // primary: Colors.purple,
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: (){
                        setState(() {
                          searchTerm = '';
                          filtrarCategoria(0);
                          products.forEach((element) {
                            element.cantidadCarrito = 0;
                            element.llevar = 'NO';
                          });
                          productsAll.forEach((element) {
                            element.cantidadCarrito = 0;
                            element.llevar = 'NO';
                          });
                          cantidadPedida();
                        });
                      },
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    style: ElevatedButton.styleFrom(
                      // primary: Colors.red,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0),
              child: TextField(
                controller: searchController, // Asigna el controlador al TextField
                onChanged: (value) {
                  setState(() {
                    searchTerm = value.toLowerCase();
                    filtrarProductosPorNombre();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Buscar producto',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                    onPressed: () {
                      setState(() {
                        searchTerm = '';
                        searchController.clear(); // Limpia el controlador
                        filtrarProductosPorNombre();
                      });
                    },
                    icon: Icon(Icons.clear),
                  )
                      : null,
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 24, right: 24),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Text(
                          categories[index].name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(10),
                          itemCount: products.length,
                          itemBuilder: (context, index2) {
                            if(products[index2].category_id == categories[index].id){
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    products[index2].cantidadCarrito++;
                                    cantidadPedida();
                                  });
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          products[index2].name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if(products[index2].cantidadCarrito > 0)
                                          Text(
                                            '${products[index2].cantidadCarrito}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent
                                            ),
                                          ),
                                      ],
                                    ),
                                    // SizedBox(height: 1),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Precio: Bs'+products[index2].price.toStringAsFixed(2),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${(products[index2].cantidadCarrito * products[index2].price).toStringAsFixed(2)} Bs',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: products[index2].cantidadCarrito > 0 ? Colors.redAccent : Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                  ],
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    );
                  },
                )
            )
          ],
        ),
      );
  }
}