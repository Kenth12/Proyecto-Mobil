import 'package:appdb/Ruta.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditarPage extends StatelessWidget {
  final int productoId;
  final String nombre;
  final int precio;
  final String descripcion;

  TextEditingController _productoController = TextEditingController();
  TextEditingController _precioController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();

  EditarPage({
    required this.productoId,
    required this.nombre,
    required this.precio,
    required this.descripcion,
  }) {
    _productoController.text = nombre;
    _precioController.text = precio.toString();
    _descripcionController.text = descripcion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF617E64), Color(0xFF79AC78)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF79AC78), Color(0xFFB0D9B1), Color(0xFFD0E7D2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            width: double.infinity,
            height: 340,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Editar Producto',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _productoController,
                  decoration: InputDecoration(labelText: 'Producto Actual'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _precioController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Precio Actual'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _descripcionController,
                  decoration: InputDecoration(labelText: 'Descripción Actual'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                onPressed: () {
                  editarProducto(context, productoId);
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF79AC78),
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0), 
                ),
                child: Text(
                  'Guardar Cambios',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void editarProducto(BuildContext context, idproducto) async {
    final String updatedProductName = _productoController.text;
    final int updatedProductPrice = int.parse(_precioController.text);
    final String updatedProductDescription = _descripcionController.text;

    try {
      final Map<String, String> headers = {
        'authorization': 'e1f602bf73cc96f53c10bb7f7953a438fb7b3c0a',
      };

      final respuesta = await http.post(
        Uri.parse("${Ruta.DIRECCION}edtProducto.php"),
        headers: headers,
        body: {
          "id": productoId.toString(),
          "nombre": updatedProductName,
          "precio": updatedProductPrice.toString(),
          "descripcion": updatedProductDescription,
        },
      );

      if (respuesta.statusCode == 200) {
        final r = json.decode(respuesta.body);
        mostrarMensaje(context, r["mensaje"]);
      } else {
        mostrarMensaje(
          context,
          "Error en la respuesta del servidor: ${respuesta.statusCode}",
        );
      }
    } catch (e) {
      print("Error durante la solicitud: $e");
      mostrarMensaje(context, "Ocurrió un error en la solicitud: $e");
    }
  }

  void mostrarMensaje(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Notificación"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
              },
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }
}
