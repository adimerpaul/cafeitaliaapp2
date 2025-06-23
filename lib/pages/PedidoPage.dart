import 'package:flutter/material.dart';

import '../components/MyDialog.dart';
import '../models/Products.dart';
import '../services/ImportService.dart';

class PedidoPage extends StatefulWidget {
  final List<Product> products;
  const PedidoPage({
    super.key,
    required this.products,
  });

  @override
  State<PedidoPage> createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  List orderPending = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrdersPending();
  }
  getOrdersPending() async{
    var orders = await ImportService().orderPending();
    setState(() {
      orderPending = orders;
      print(orderPending);
    });
  }
  void MyChangeLlevar(int index) {
    // print(index);
    // setState(() {
    //   products[index].llevar = products[index].llevar == 'SI' ? 'NO' : 'SI';
    // });
    //abiri el dialog
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos'),
      ),
      body: Column(
        children: [
          Text(
            'Pedidos Pendientes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: orderPending.length,
              itemBuilder: (BuildContext context, int index) {
                // Asumiendo que orderPending contiene información sobre los pedidos pendientes
                // Puedes personalizar esto según la estructura real de tus datos
                return ListTile(
                  title: Text(
                    '${orderPending[index]['id']} Mesa #${orderPending[index]['mesa']} - Total: Bs ${orderPending[index]['total']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Productos: ${orderPending[index]['TextProducts']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  // Agrega más información según sea necesario
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MyDialog(
                              total: 0,
                              mesa: 0,
                              products: widget.products,
                              order_id: orderPending[index]['id'],
                              callback: () {
                                // Actualiza la lista de pedidos pendientes
                                getOrdersPending();
                              },
                              changeLlevar: MyChangeLlevar
                          );
                        }
                    );
                  },
                );
              },
            ),
          ),
        ],
      )
    );
  }
}
