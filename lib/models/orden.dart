import 'dart:convert';

class Orden {
  double entrada;
  String imgPago;
  String id;
  _Solares solar;
  _Usuario usuario;
  DateTime fechaIngreso;
  int meses; // Nuevo campo

  Orden({
    required this.entrada,
    required this.imgPago,
    required this.id,
    required this.solar,
    required this.usuario,
    required this.fechaIngreso,
    required this.meses,
  });

  factory Orden.fromJson(String str) => Orden.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Orden.fromMap(Map<String, dynamic> json) => Orden(
        entrada: json["entrada"]?.toDouble(),
        imgPago: json["imgPago"],
        id: json["_id"],
        solar: _Solares.fromMap(json["solar"]),
        usuario: _Usuario.fromMap(json["usuario"]),
        fechaIngreso: DateTime.parse(json["fechaIngreso"]),
        meses: json["meses"],
      );

  Map<String, dynamic> toMap() => {
        "entrada": entrada,
        "imgPago": imgPago,
        "_id": id,
        "solar": solar.toMap(),
        "usuario": usuario.toMap(),
        "fechaIngreso": fechaIngreso.toIso8601String(),
        "meses": meses,
      };
}

class _Solares {
  String caracteristicas;
  String id;
  String ubicacion;
      String solare;
    String etapa;
    String manzana;
  double ancho;
  double largo;

  _Solares({
    required this.caracteristicas,
    required this.id,
    required this.ubicacion,
          required this.manzana,
        required this.etapa,
        required this.solare,
    required this.ancho,
    required this.largo,
  });

  factory _Solares.fromJson(String str) => _Solares.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory _Solares.fromMap(Map<String, dynamic> json) => _Solares(
        caracteristicas: json["caracteristicas"],
        id: json["_id"],
        ubicacion: json["ubicacion"],
        solare: json["solare"],
        etapa: json["etapa"],
        manzana: json["manzana"],
        ancho: json["ancho"]?.toDouble(),
        largo: json["largo"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "caracteristicas": caracteristicas,
        "_id": id,
        "ubicacion": ubicacion,
        "solare": solare,
        "etapa": etapa,
        "manzana": manzana,
        "ancho": ancho,
        "largo": largo,
      };
}

class _Usuario {
  String id;
  String nombre;

  _Usuario({
    required this.id,
    required this.nombre,
  });

  factory _Usuario.fromJson(String str) => _Usuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory _Usuario.fromMap(Map<String, dynamic> json) => _Usuario(
        id: json["_id"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "nombre": nombre,
      };
}


