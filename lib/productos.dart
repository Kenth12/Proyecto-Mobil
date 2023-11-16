class productos {
  final int PRO_ID;
  final String PRO_NOMBRE;
  final int PRO_PRECIO;
  final String PRO_DESCRIPCION;

  productos(
      {required this.PRO_ID,
      required this.PRO_NOMBRE,
      required this.PRO_PRECIO,
      required this.PRO_DESCRIPCION});

  factory productos.fromJson(Map<String, dynamic> json) {
    return productos(
        PRO_ID: int.parse(json["PRO_ID"]),
        PRO_NOMBRE: json['PRO_NOMBRE'],
        PRO_PRECIO: int.parse(json['PRO_PRECIO']),
        PRO_DESCRIPCION: json['PRO_DESCRIPCION']);
  }
}
