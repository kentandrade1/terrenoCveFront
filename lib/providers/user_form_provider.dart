import 'dart:typed_data';

import 'package:admin_dashboard/api/CafeApi.dart';
import 'package:admin_dashboard/models/usuario.dart';
import 'package:flutter/material.dart';

class UserFormProvider extends ChangeNotifier {

  Usuario? user;
  late GlobalKey<FormState> formKey;

  // void updateListener() {
  //   notifyListeners();
  // }
  copyUserWith({
    String? rol,
    bool? estado,
    bool? google,
    String? nombre,
    String? cedula,
    String? apellido,
    String? correo,
    String? uid,
    String? img,
    String? direccion,
    String? telefono,
  }) {
    user = new Usuario(
      rol: rol ?? this.user!.rol,
      estado: estado ?? this.user!.estado,
      google: google ?? this.user!.google,
      nombre: nombre ?? this.user!.nombre,
      correo: correo ?? this.user!.correo,
      uid: uid ?? this.user!.uid,
      img: img ?? this.user!.img,
       direccion: direccion??this.user!.direccion, 
       telefono: telefono??this.user!.telefono,
       cedula: cedula??this.user!.cedula,
       apellido: apellido??this.user!.apellido,
    );
    notifyListeners();
  }



  bool _validForm() {
    return formKey.currentState!.validate();
  }

  Future updateUser() async {

    if ( !this._validForm() ) return false;

    final data = {
      'nombre': user!.nombre,
      'correo': user!.correo,
      'telefono':user!.telefono,
      'direccion':user!.direccion,
      'rol':user!.rol,
      'apellido':user!.apellido,
      'cedula':user!.cedula
    };

    try {
      
      final resp = await CafeApi.put('/usuarios/${ user!.uid }', data);
      print( resp );
      return true;

    } catch (e) {
      print('error en updateUser: $e');
      return false;
    }


  }


  Future<Usuario> uploadImage( String path, Uint8List bytes ) async {

    try {
      
      final resp = await CafeApi.uploadFile(path, bytes);
      user = Usuario.fromMap(resp);
      notifyListeners();

      return user!;

    } catch (e) {
      print(e);
      throw 'Error en user from provider provider';
    }

  }


}
