import 'package:admin_dashboard/models/http/ordenes_response.dart';
import 'package:admin_dashboard/models/http/reservas_response.dart';
import 'package:admin_dashboard/models/http/solares_response.dart';
import 'package:admin_dashboard/models/orden.dart';
import 'package:admin_dashboard/models/solares.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:admin_dashboard/api/CafeApi.dart';

import 'package:admin_dashboard/models/category.dart';

import '../models/reserva.dart';
import '../services/notifications_service.dart';


class GeneralProvider extends ChangeNotifier {

  List<Categoria> categorias = [];
  List<Solares> solares = [];
  List<Orden> orden = [];
  List<Reserva> reservas = [];
  getSolares() async {
    final resp = await CafeApi.httpGet('/solares');
    final solaresResp = SolaresResponse.fromMap(resp);

    this.solares = [...solaresResp.solares];


    notifyListeners();
  }
    getOrdenes(String id,String rol) async {
      String get= "/orden";

    if(rol=="CLIENTE_ROLE")
    get="/orden/$id";
    final resp = await CafeApi.httpGet('$get');
    final ordenesResp = OrdenesResponse.fromMap(resp);

    this.orden = [...ordenesResp.ordenes];


    notifyListeners();
  }
      getReservas(String id,String rol) async {
      String get= "/reserva";

    if(rol=="CLIENTE_ROLE")
    get="/reserva/$id";
    final resp = await CafeApi.httpGet('$get');
    final reservaResp = ReservasResponse.fromMap(resp);

    this.reservas = [...reservaResp.reservas];


    notifyListeners();
  }
   Future deleteSolar( String id ) async {
    try {

      await CafeApi.delete('/solares/$id', {} );
    
      solares.removeWhere((solar) => solar.id == id );
      NotificationsService.showSnackbar("Borrado con exito");
      notifyListeners();
      
      
    } catch (e) {
      print(e);
       NotificationsService.showSnackbar("Error al borrar");
      print('Error al eliminar Solar');
    }

  }
     Future deleteOrden( String id ) async {
    try {

      await CafeApi.delete('/orden/$id', {} );
    
      orden.removeWhere((ordens) => ordens.id == id );
     
      notifyListeners();
       NotificationsService.showSnackbar("Borrado con exito");
      
    } catch (e) {
      print(e);
       NotificationsService.showSnackbar("Error al Borrar");
      print('Error al eliminar orden');
    }

  }
Future newReserva(String solar,String usuario,int meses,String asesor) async {


  final data = {
    "solar": solar,
    "usuario": usuario,
    "meses":meses,
    "asesor":asesor
  };

  try {
    final json = await CafeApi.post('/reserva', data);

    final newReserva = Reserva.fromMap(json);

    reservas.add(newReserva);
     NotificationsService.showSnackbar("Ingresada la reserva con exito");
    notifyListeners();
  } catch (e) {
    // Verificar si hay un error HTTP 400
    if (e is DioError && e.response?.statusCode == 400) {
       NotificationsService.showSnackbar("Error: $e");
      throw 'Error en los datos proporcionados';
    } else {
       NotificationsService.showSnackbar("Error en la reserva");
      throw 'Error al crear solar';
    }
  }
}
Future newSolar(String ubicacion, String etapa, String manzana, String solare, String caracteristicas, double ancho, double largo, String estadoR) async {
  final data = {
    "caracteristicas": caracteristicas,
    "estadoR": estadoR,
    "precio": 0,
    "ubicacion": ubicacion,
    "etapa": etapa,
    "manzana": manzana,
    "solare": solare,
    "ancho": ancho,
    "largo": largo
  };

  try {
    final json = await CafeApi.post('/solares', data);

    // Verificar si la respuesta JSON contiene un campo de "error" o indicador de error
    if (json.containsKey("msg")) {
      NotificationsService.showSnackbar("Error: ${json["msg"]}");
    } else {
      final newSolar = Solares.fromMap(json);
      solares.add(newSolar);
      NotificationsService.showSnackbar("Ingresado el solar con éxito");
      notifyListeners();
    }
  } catch (e) {
    // Mostrar mensaje de error genérico en el snackbar
    NotificationsService.showSnackbar("Error al crear el solar");
  }
}

Future newOrden(double entrada, String solar,int meses) async {


  final data = {
    "entrada": entrada,
    "solar":solar,
    "meses":meses,
  };

  try {
     await CafeApi.post('/orden', data);

     NotificationsService.showSnackbar("Ingresado de orden con exito");
    notifyListeners();
  } catch (e) {
    // Verificar si hay un error HTTP 400
    if (e is DioError && e.response?.statusCode == 400) {
       NotificationsService.showSnackbar("Error : $e");
      throw 'Error en los datos proporcionados';
    } else {
       NotificationsService.showSnackbar("Error al crear orden");
      throw 'Error al crear la orden';
    }
  }
}
  Future updateSolarEstado( String id,String estadoR ) async {

    final data = {

            "estadoR": estadoR,

    };


    try {

      await CafeApi.put('/solares/$id', data );
    
      this.solares = this.solares.map(
        (solar) {
          if ( solar.id != id ) return solar;

          solar.estadoR = estadoR;
          if(estadoR=="en proceso")
           NotificationsService.showSnackbar("Actualizado con exito");
           
          return solar;
        }
      ).toList();
      
      notifyListeners();
      
    } catch (e) {
       NotificationsService.showSnackbar("Error al actualizar");
      throw 'Error al crear categoria';
    }

  }
    Future updateOrdenFoto( String id,String url ) async {

    final data = {

            "imgPago": url,

    };


    try {

      await CafeApi.put('/orden/$id', data );
    
      this.orden = this.orden.map(
        (ordens) {
          if ( ordens.id != id ) return ordens;

          ordens.imgPago = url;
           NotificationsService.showSnackbar("Actualizada Orden con exito");
          return ordens;
        }
      ).toList();
      
      notifyListeners();
      
    } catch (e) {
       NotificationsService.showSnackbar("Error al actualizar");
      throw 'Error al actualizar orden';
    }

  }


Future updateSolar(String id, String ubicacion, String caracteristicas, double precio, double ancho, double largo, String estadoR, String solare, String manzana, String etapa) async {
  final data = {
    "caracteristicas": caracteristicas,
    "estadoR": estadoR,
    "precio": 0,
    "ubicacion": ubicacion,
    "ancho": ancho,
    "largo": largo,
    "etapa": etapa,
    "solare": solare,
    "manzana": manzana
  };

  try {
    final json = await CafeApi.put('/solares/$id', data);

    if (json.containsKey("msg")) {
      NotificationsService.showSnackbar("Error: ${json["msg"]}");
    } else {
      NotificationsService.showSnackbar("Solar actualizado con éxito");
      this.solares = this.solares.map((solar) {
        if (solar.id != id) return solar;
        solar.ubicacion = ubicacion;
        solar.caracteristicas = caracteristicas;
        solar.estadoR = estadoR;
        solar.largo = largo;
        solar.ancho = ancho;
        solar.precio = 0;
        solar.manzana=manzana;
        solar.etapa=etapa;
        solar.solare=solare;
        return solar;
      }).toList();

      notifyListeners();
    }
  } catch (e) {
    if (e is DioError && e.response?.statusCode == 400) {
      final errorJson = e.response?.data;
      if (errorJson != null && errorJson.containsKey("msg")) {
        NotificationsService.showSnackbar("Error: ${errorJson["msg"]}");
      } else {
        NotificationsService.showSnackbar("Error actualizando el solar");
      }
    } else {
      NotificationsService.showSnackbar("Error actualizando el solar");
    }
  }
}


  Future deleteCategory( String id ) async {

    try {

      await CafeApi.delete('/categorias/$id', {} );
    
      categorias.removeWhere((categoria) => categoria.id == id );
     
      notifyListeners();
      
      
    } catch (e) {
      print(e);
      print('Error al crear categoria');
    }

  }

}