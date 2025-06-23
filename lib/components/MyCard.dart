import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';
class MyCard extends StatelessWidget {
  final double radius = 12;
  final int index;
  final String title;
  final String subtitle;
  final String image;
  final String price;
  final String color;
  final int cantidadCarrito;
  final VoidCallback? callbackMinus;

  const MyCard({
    Key? key,
    required this.index,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.price,
    required this.color,
    required this.cantidadCarrito,
    this.callbackMinus,
  }) : super(key: key);

  Color getContainerColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red[50] ?? Colors.white;
      case 'blue':
        return Colors.blue[50] ?? Colors.white;
      case 'green':
        return Colors.green[50] ?? Colors.white;
      case 'yellow':
        return Colors.yellow[50] ?? Colors.white;
      case 'purple':
        return Colors.purple[50] ?? Colors.white;
      default:
        return Colors.white; // Color predeterminado si el nombre no coincide con ninguno de los anteriores
    }
  }

  Color getBadgeColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red[200] ?? Colors.white;
      case 'blue':
        return Colors.blue[200] ?? Colors.white;
      case 'green':
        return Colors.green[200] ?? Colors.white;
      case 'yellow':
        return Colors.yellow[200] ?? Colors.white;
      case 'purple':
        return Colors.purple[200] ?? Colors.white;
      default:
        return Colors.white; // Color predeterminado si el nombre no coincide con ninguno de los anteriores
    }
  }
  Color getTextColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red[800] ?? Colors.white;
      case 'blue':
        return Colors.blue[800] ?? Colors.white;
      case 'green':
        return Colors.green[800] ?? Colors.white;
      case 'yellow':
        return Colors.yellow[800] ?? Colors.white;
      case 'purple':
        return Colors.purple[800] ?? Colors.white;
      default:
        return Colors.white; // Color predeterminado si el nombre no coincide con ninguno de los anteriores
    }
  }
  textCapitalization(String text){
    text = text.toLowerCase();
    return text[0].toUpperCase() + text.substring(1);
  }


  @override
  Widget build(BuildContext context) {
    Color containerColor = getContainerColorFromString(color);
    Color badgeColor = getBadgeColorFromString(color);
    Color textColor = getTextColorFromString(color);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Column(
          children: [
            //badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                cantidadCarrito == 0 ? Container() :
                GestureDetector(
                  onTap: callbackMinus,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellowAccent, // Color con opacidad diferente
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(radius),
                        topLeft: Radius.circular(radius),
                      ),
                    ),
                    // padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '$cantidadCarrito',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.remove_circle_outline,
                          color: Colors.redAccent,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: badgeColor, // Color con opacidad diferente
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(radius),
                      topRight: Radius.circular(radius),
                    ),
                  ),
                  // padding: EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '\Bs$price',
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //image
            Padding(
                padding: const EdgeInsets.symmetric(
                  // horizontal: 24,
                  // vertical: 12,
                ),
              child: CachedNetworkImage(
                imageUrl: dotenv.env['API_BACK']! + '/../images/' + image,
                placeholder: (context, url) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey, // Puedes personalizar el color o usar un icono en lugar de un contenedor
                  child: Icon(Icons.image, color: Colors.white),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.red, // Puedes personalizar el color o usar un icono en lugar de un contenedor
                  child: Icon(Icons.error, color: Colors.white),
                ),
                width: 100,
                height: 100,
              ),
            ),
            // Agrega aquí los demás widgets que necesitas para tu tarjeta (título, subtítulo, imagen, etc.)
            SingleChildScrollView(
              child: Center(
                child: Text(
                  textCapitalization(title),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              textCapitalization(subtitle),
              style: TextStyle(
                fontSize: 10,
                // fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
