import 'dart:convert';

class Usuario {
  Usuario({
    required this.rol,
    required this.estado,
    required this.google,
    required this.nombre,
    required this.correo,
    this.cedula,
    this.apellido,
    required this.uid,
    this.img,
    required this.direccion,
    required this.telefono,
  });

  String rol;
  bool estado;
  bool google;
  String nombre;
  String correo;
  String uid;
  String? img;
  String? cedula;

  String? apellido;
  String direccion;
  String telefono;

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        rol: json["rol"],
        estado: json["estado"],
        google: json["google"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        cedula: json["cedula"],
        correo: json["correo"],
        uid: json["uid"],
        img: json["img"],
        direccion: json["direccion"],
        telefono: json["telefono"],
      );

  Map<String, dynamic> toMap() => {
        "rol": rol,
        "estado": estado,
        "google": google,
        "nombre": nombre,
        "apellido":apellido,
        "cedula":cedula,
        "correo": correo,
        "uid": uid,
        "img": img,
        "direccion": direccion,
        "telefono": telefono,
      };
}
