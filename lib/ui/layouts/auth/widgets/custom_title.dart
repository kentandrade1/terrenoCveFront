import 'package:flutter/material.dart';


class CustomTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric( horizontal: 20 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'narboni.png',
              width: 200,
              height: 200,
    
            ),
          ),

          SizedBox( height: 20 ),

          Center(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                'Urbanizacion centro de viajes ecuador',
                style:TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}