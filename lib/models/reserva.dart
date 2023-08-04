import 'dart:convert';

class Reserva {
  String id;
  _Solares solar;
  _Usuario usuario;
  DateTime fechaIngreso;
  int meses; 
  _Asesor asesor;
  Reserva({
    required this.id,
    required this.solar,
    required this.usuario,
    required this.asesor,
    required this.fechaIngreso,
     required this.meses,
  });

  factory Reserva.fromJson(String str) => Reserva.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Reserva.fromMap(Map<String, dynamic> json) => Reserva(
        id: json["_id"],
        solar: _Solares.fromMap(json["solar"]),
        usuario: _Usuario.fromMap(json["usuario"]),
        asesor: _Asesor.fromMap(json["asesor"]),
        fechaIngreso: DateTime.parse(json["fechaIngreso"]),
         meses: json["meses"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "solar": solar.toMap(),
        "usuario": usuario.toMap(),
        "asesor": asesor.toMap(),
        "fechaIngreso": fechaIngreso.toIso8601String(),
        "meses": meses,
      };
}

class _Solares {
  String caracteristicas;
  String id;
  String ubicacion;
  double ancho;
  double largo;

  _Solares({
    required this.caracteristicas,
    required this.id,
    required this.ubicacion,
    required this.ancho,
    required this.largo,
  });

  factory _Solares.fromJson(String str) => _Solares.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory _Solares.fromMap(Map<String, dynamic> json) => _Solares(
        caracteristicas: json["caracteristicas"],
        id: json["_id"],
        ubicacion: json["ubicacion"],
        ancho: json["ancho"]?.toDouble(),
        largo: json["largo"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "caracteristicas": caracteristicas,
        "_id": id,
        "ubicacion": ubicacion,
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
class _Asesor {
  String id;
  String nombre;

  _Asesor({
    required this.id,
    required this.nombre,
  });

  factory _Asesor.fromJson(String str) => _Asesor.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory _Asesor.fromMap(Map<String, dynamic> json) => _Asesor(
        id: json["_id"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "nombre": nombre,
      };
}