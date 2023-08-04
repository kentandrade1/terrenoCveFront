// To parse this JSON data, do
//
//     final solares = solaresFromMap(jsonString);

import 'dart:convert';

class Solares {
    String caracteristicas;
    String estadoR;
    double precio;
    String id;
    String ubicacion;
    String solare;
    String etapa;
    String manzana;
    double ancho;
    double largo;
    Usuario usuario;

    Solares({
        required this.caracteristicas,
        required this.estadoR,
        required this.precio,
        required this.id,
        required this.ubicacion,
        required this.manzana,
        required this.etapa,
        required this.solare,
        required this.ancho,
        required this.largo,
        required this.usuario,
    });

    factory Solares.fromJson(String str) => Solares.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Solares.fromMap(Map<String, dynamic> json) => Solares(
        caracteristicas: json["caracteristicas"],
        estadoR: json["estadoR"],
        precio: json["precio"],
        id: json["_id"],
        ubicacion: json["ubicacion"],
        solare: json["solare"],
        etapa: json["etapa"],
        manzana: json["manzana"],

        ancho: json["ancho"]?.toDouble(),
        largo: json["largo"]?.toDouble(),
        usuario: Usuario.fromMap(json["usuario"]),
    );

    Map<String, dynamic> toMap() => {
        "caracteristicas": caracteristicas,
        "estadoR": estadoR,
        "precio": precio,
        "_id": id,
        "ubicacion": ubicacion,
        "solare": solare,
        "etapa": etapa,
        "manzana": manzana,

        "ancho": ancho,
        "largo": largo,
        "usuario": usuario.toMap(),
    };
}

class Usuario {
    String id;
    String nombre;

    Usuario({
        required this.id,
        required this.nombre,
    });

    factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        id: json["_id"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toMap() => {
        "_id": id,
        "nombre": nombre,
    };
}
