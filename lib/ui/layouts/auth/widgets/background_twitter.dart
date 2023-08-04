import 'package:flutter/material.dart';

class BackgroundTwitter extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: buildBoxDecoration(),
      child: Container(
     
        constraints: BoxConstraints( maxWidth: 200 ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Image(
              image: AssetImage('logo_terrenos.png'),
              width: 400,
            ),
          ),
        ),
      ),
    );
  }

 BoxDecoration buildBoxDecoration() {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [ Colors.black,Colors.grey.shade800,Colors.black, Colors.grey.shade800,Colors.black,],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
}

}

