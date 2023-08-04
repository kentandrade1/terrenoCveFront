import 'package:flutter/material.dart';



class NotificationsService {

  static GlobalKey<ScaffoldMessengerState> messengerKey = new GlobalKey<ScaffoldMessengerState>();


  static showSnackbarError( String message ) {

    final snackBar = new SnackBar(
      backgroundColor: Colors.red.withOpacity(0.9),
      content: Text( message, style: TextStyle( color: Colors.white, fontSize: 20 ) )
    );

    messengerKey.currentState!.showSnackBar(snackBar);

  }

 static showSnackbar(String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white, fontSize: 20),
    ),
    backgroundColor: Colors.blue, // Color de fondo personalizado
    duration: Duration(seconds: 3), // Duración de 3 segundos
    behavior: SnackBarBehavior.floating, // Mostrar en el centro de la pantalla
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Bordes redondeados
    ),
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30), // Margen
  );


  messengerKey.currentState!.showSnackBar(snackBar);
}

  static showBusyIndicator( BuildContext context ) {

    final AlertDialog dialog = AlertDialog(
      content: Container(
        width: 100,
        height: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );

    showDialog(context: context, builder: ( _ )=> dialog );

  }


}