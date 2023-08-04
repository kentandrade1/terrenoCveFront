import 'package:admin_dashboard/models/usuario.dart';
import 'package:flutter/material.dart';


import 'package:admin_dashboard/api/CafeApi.dart';
import 'package:admin_dashboard/models/http/auth_response.dart';

import 'package:admin_dashboard/router/router.dart';

import 'package:admin_dashboard/services/local_storage.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/services/notifications_service.dart';

enum AuthStatus {
  checking,
  authenticated,
  notAuthenticated
}

class AuthProvider extends ChangeNotifier {

  String? _token;
  AuthStatus authStatus = AuthStatus.checking;
  Usuario? user;

  AuthProvider() {
    this.isAuthenticated();
  }
  Future deleteUser( String id) async {
    
     print(await CafeApi.delete('/usuarios/$id',{}));


  }

 Future actualizarPerfil( String email, String direccion,String telefono,String nombre,String id,String rol,String cedula,String apellido ) async {

    final data = {
      'correo': email,
      'nombre': nombre,
      'direccion':direccion,
      'telefono':telefono,
      'rol':rol,
      'cedula':cedula,
      'apellido':apellido
    };
   await CafeApi.put('/usuarios/$id', data );

  user?.correo=email;
  user?.direccion=direccion;
  user?.nombre=nombre;
  user?.telefono=telefono;
  user?.rol=rol;
  user?.apellido=apellido;
  user?.cedula=cedula;
  }
  login( String email, String password ) {

    final data = {
      'correo': email,
      'password': password
    };

    CafeApi.post('/auth/login', data ).then(
      (json) {
        print(json);
        final authResponse = AuthResponse.fromMap(json);
        this.user = authResponse.usuario;

        authStatus = AuthStatus.authenticated;
        LocalStorage.prefs.setString('token', authResponse.token );
        NavigationService.replaceTo(Flurorouter.dashboardRoute);

        CafeApi.configureDio();

        notifyListeners();

      }
      
    ).catchError( (e){
      print('error en: $e');
      NotificationsService.showSnackbarError('Usuario / Password no válidos');
    });

  }
     changedPassword(String password,String token) async {
 
    final data = {
      'password': password,
    };

       CafeApi.post('/auth/ressetPasswordChange/$token', data).then((json) {


          print(json);
           NotificationsService.showSnackbar('Contraseña cambiada con éxito');
      NavigationService.replaceTo(Flurorouter.loginRoute);


      notifyListeners();
    }).catchError((e) {
      print('error en: $e');
      NotificationsService.showSnackbarError('Usuario / Password no válidos');
    });
  }
   ressetPassword(String email) async {
 
    final data = {
      'email': email,
    };

       CafeApi.post('/auth/ressetPassword', data).then((json) {


          print(json);
           NotificationsService.showSnackbarError('Correo enviado');
      NavigationService.replaceTo(Flurorouter.loginRoute);


      notifyListeners();
    }).catchError((e) {
      print('error en: $e');
      NotificationsService.showSnackbarError('Usuario / Password no válidos');
    });
  }
  register( String email, String password, String name ) {
    
    final data = {
      'nombre': name,
      'correo': email,
      'password': password,
      'direccion':"",
      'telefono':"",
      'rol':"CLIENTE_ROLE"
    };

    CafeApi.post('/usuarios', data ).then(
      (json) {
        print(json);
        final authResponse = AuthResponse.fromMap(json);
        this.user = authResponse.usuario;

        authStatus = AuthStatus.authenticated;
        LocalStorage.prefs.setString('token', authResponse.token );
        NavigationService.replaceTo(Flurorouter.dashboardRoute);

        CafeApi.configureDio();
        notifyListeners();

      }
      
    ).catchError( (e){
      print('error en: $e');
      NotificationsService.showSnackbarError('Usuario / Password no válidos');
    });
    
    
    

  }

  Future<bool> isAuthenticated() async {

    final token = LocalStorage.prefs.getString('token');

    if( token == null ) {
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    }
    
    try {
      final resp = await CafeApi.httpGet('/auth');
      final authReponse = AuthResponse.fromMap(resp);
      LocalStorage.prefs.setString('token', authReponse.token );
      
      this.user = authReponse.usuario;
      authStatus = AuthStatus.authenticated;
      notifyListeners();
      return true;

    } catch (e) {
      print(e);
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    }

  }


  logout() {
    LocalStorage.prefs.remove('token');
    authStatus = AuthStatus.notAuthenticated;
    notifyListeners();
  }

}
