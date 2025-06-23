import 'package:cafeitalia/services/ImportService.dart';
import 'package:flutter/material.dart';

import '../models/Products.dart';

class MyDialog extends StatefulWidget {
  final double total;
  final int mesa;
  final List<Product> products;
  final VoidCallback? callback;
  final void Function(int)? changeLlevar;
  final int order_id;

  const MyDialog({
    Key? key,
    required this.total,
    required this.mesa,
    required this.products,
    this.callback,
    required this.changeLlevar,
    required this.order_id,
  }) : super(key: key);

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  bool _isLoading = false;

  textCapitalization(String text) {
    if (text.isEmpty) return text;
    // const textNew = text.toLowerCase();
    String textNew = text.toLowerCase();
    return textNew[0].toUpperCase() + textNew.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Mesa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '#${widget.mesa}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Bs ${widget.total}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.products.length,
          itemBuilder: (BuildContext context, int index) {
            Product product = widget.products[index];
            return ListTile(
              title: Row(
                children: [
                  // Text(widget.products[index].llevar),
                  DropdownButton<String>(
                    value: widget.products[index].llevar, // Valor actual del ComboBox
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.products[index].llevar = newValue ?? 'NO'; // Actualiza el valor del estado
                        // widget.changeLlevar?.call(index); // Llama a la función de cambio
                        // Navigator.of(context).pop(); // Cierra el diálogo
                      });
                    },
                    items: <String>['SI', 'NO'] // Opciones del ComboBox
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Flexible(
                    child: Text(
                      textCapitalization('${product.name} - ${product.price.toString()} Bs'),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                  'Cantidad: ${product.cantidadCarrito}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  )
              ),
              trailing: Text(
                  'Bs ${product.price * product.cantidadCarrito}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  )
              ),
            );
          },
        ),
      ),
      actions: <Widget>[
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : submitOrder,
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.greenAccent,
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading ? CircularProgressIndicator() :
                  Row(
                    children: [
                      Icon(
                        Icons.payment,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Text(
                          'Pedido',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el diálogo
                  },
                  child: Text('Cerrar'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Future<void> submitOrder() async {
    setState(() {
      _isLoading = true;
    });

    BuildContext localContext = context; // Almacena una referencia local al contexto

    try {
      if( widget.order_id == 0 ){
        var result = await ImportService().order(widget.mesa, widget.total, widget.products);
        if (result != null) {
          ScaffoldMessenger.of(localContext).showSnackBar(
            SnackBar(
              content: Text('Se hizo el pedido para la Mesa: ${widget.mesa}'),
              backgroundColor: Colors.greenAccent,
            ),
          );
          Navigator.of(localContext).pop(); // Cierra el diálogo
          widget.callback!(); // Ejecuta el método del padre
        } else {
          ScaffoldMessenger.of(localContext).showSnackBar(
            SnackBar(
              content: Text('Error al realizar el pedido'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }else{
        var result = await ImportService().aumentarPedido(widget.order_id, widget.products);
        if (result != null) {
          ScaffoldMessenger.of(localContext).showSnackBar(
            SnackBar(
              content: Text('Se hizo el pedido para la Mesa: ${widget.mesa}'),
              backgroundColor: Colors.greenAccent,
            ),
          );
          Navigator.of(localContext).pop(); // Cierra el diálogo
          widget.callback!(); // Ejecuta el método del padre
        } else {
          ScaffoldMessenger.of(localContext).showSnackBar(
            SnackBar(
              content: Text('Error al realizar el pedido'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
