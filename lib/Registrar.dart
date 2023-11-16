import 'dart:convert';

import 'package:appdb/Ruta.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class RegistrarPage extends StatelessWidget {

 TextEditingController  _productoController = TextEditingController();
 TextEditingController _precioController = TextEditingController();
  TextEditingController  _descripcionController = TextEditingController();

  RegistrarPage({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF79AC78), Color(0xFFB0D9B1), Color(0xFFD0E7D2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(""),
        //shadowColor: Colors.amber,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
               colors: [Color(0xFF617E64), Color(0xFF79AC78) ,],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Center(
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
                  'Registro de productos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _productoController, 
                  decoration: InputDecoration(labelText: 'Ingrese Producto'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _precioController, 
                  keyboardType: TextInputType.number, 
                  decoration: InputDecoration(labelText: 'Ingrese Precio'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _descripcionController, 
                  decoration: InputDecoration(labelText: 'Ingrese Descripcion'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                onPressed: () {
                   if (validarCampos()) {
                    RegistrarProductos(context);
                  } else {
                    CamposVaciosAlerta(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF79AC78),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 32.0)
                ),
                child: Text(
                  'Guardar',
                  style: TextStyle(
                    color: Colors.white, 
                  ),
                ),
              )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future RegistrarProductos(BuildContext context) async {
    try {
      final Map<String, String> headers = {
        'authorization': 'e1f602bf73cc96f53c10bb7f7953a438fb7b3c0a',
      };

      final respuesta = await http.post(
        Uri.parse("${Ruta.DIRECCION}/regProducto.php"),
        headers: headers,
        body: {
          "nombre": _productoController.text,
          "precio": _precioController.text,
          "descripcion": _descripcionController.text,
        },
      );

     
      if (respuesta.statusCode == 200) {
        final r = json.decode(respuesta.body);
        Mensaje(context, r["mensaje"]);
      } else {
        
        Mensaje(context, "Error en la respuesta del servidor: ${respuesta.statusCode}");
      }
    } catch (e) {
      
      print("Error durante la solicitud: $e");
      Mensaje(context, "Ocurrió un error en la solicitud: $e");
    }
  }

  Mensaje(BuildContext context, String msj) {
    Widget okBoton = TextButton(
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
        },
        child: const Text("Aceptar"));

    AlertDialog alerta = AlertDialog(
      title: const Text("Notificacion"),
      content: Text(msj),
      actions: [okBoton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alerta;
        });
  }

  CamposVaciosAlerta(BuildContext context) {
    Widget ok = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Aceptar"));

    AlertDialog al = AlertDialog(
      title: Text("Mensaje", textAlign: TextAlign.center),
      content: const Text("Por favor, Valide todos los campos"),
      actions: [ok],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return al;
        });
  }

  bool validarCampos() {
    return _descripcionController.text.isNotEmpty &&
        _productoController.text.isNotEmpty &&
        _precioController.text.isNotEmpty;
  }
}


class CustomTextField extends StatelessWidget {
  final String label;

  const CustomTextField({required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: Color(0xFF79AC78),
          ),
        ),
      ),
    );
  }
}

