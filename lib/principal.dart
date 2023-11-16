import 'dart:ui';
import 'package:appdb/Editar.dart';
import 'package:appdb/Registrar.dart';
import 'package:flutter/material.dart';
import 'productos.dart';
import 'package:http/http.dart' as http;
import 'Ruta.dart';
import 'dart:convert';

class Admproducto extends StatefulWidget {
  const Admproducto({super.key});

  @override
  State<Admproducto> createState() => _AdmproductoState();
}

class _AdmproductoState extends State<Admproducto> {
  late Future<List<productos>> listaproductos;
  @override
  void initState() {
    super.initState();
    listaproductos = getproductos();
  }

  Future<List<productos>> getproductos() async {
    final respuesta =
        await http.get(Uri.parse("${Ruta.DIRECCION}lisProductos.php"));
    final items = json.decode(respuesta.body).cast<Map<String, dynamic>>();
    
    List<productos> pr = items.map<productos>((json) {
      return productos.fromJson(json);
    }).toList();
    return pr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listado de productos"),
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
      body: FutureBuilder<List<productos>>(
        future: listaproductos,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF79AC78),
                      Color(0xFFB0D9B1),
                      Color(0xFFD0E7D2),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                width: double.infinity,
                height: 280,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0, 
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(121, 172, 120, 0.5), 
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: Offset(0, 0), 
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(4),
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Card(
                          child: ListTile(
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Color.fromARGB(199, 238, 238, 24)),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => EditarPage(
                                          productoId: data.PRO_ID,
                                          nombre: data.PRO_NOMBRE,
                                          precio: data.PRO_PRECIO,
                                          descripcion: data.PRO_DESCRIPCION
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    // Muestra un diálogo de confirmación antes de eliminar
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Confirmar Eliminación"),
                                          content: Text("¿Estás seguro de eliminar este producto?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Cancelar"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                eliminarProducto(context, data.PRO_ID.toString());
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Eliminar"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            title: Text(
                              "Nombre: ${data.PRO_NOMBRE}",
                              style: TextStyle(fontFamily: 'Minimalista', fontSize: 15),
                            ),
                            subtitle: Text(
                              "Precio: \$${data.PRO_PRECIO}",
                              style: TextStyle(fontFamily: 'Minimalista', fontSize: 12),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(105, 150, 104, 0.498),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => RegistrarPage()),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> eliminarProducto(BuildContext context, productoId) async {
  final Map<String, String> headers = {
    'Authorization': 'e1f602bf73cc96f53c10bb7f7953a438fb7b3c0a',
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  try {
    final respuesta = await http.post(
      Uri.parse("${Ruta.DIRECCION}eliProductos.php"),
      headers: headers,
      body: {
        "id": productoId,
      },
    );

    if (respuesta.statusCode == 200) {
      final r = json.decode(respuesta.body);
      Mensaje(context, r["mensaje"]);
      // Recargar la página actual
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Admproducto()));
    } else {
      Mensaje(context, "Error en la respuesta del servidor: ${respuesta.statusCode}");
    }
  } catch (e) {
    print("Error durante la solicitud: $e");
    Mensaje(context, "Ocurrió un error en la solicitud: $e");
  }
}

void Mensaje(BuildContext context, String msj) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Notificación"),
        content: Text(msj),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Aceptar"),
          ),
        ],
      );
    },
  );
}
}
