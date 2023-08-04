import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {

  final Function onPressed;
  final String text;
  final Color color;
  final bool isFilled;
  final bool isTextWhite;

  const CustomOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.color = Colors.blue,
    this.isFilled = false,
    this.isTextWhite = false
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder( )
        ),
        side: MaterialStateProperty.all(
          BorderSide( color: Colors.blue.shade800 )
        ),
        backgroundColor: MaterialStateProperty.all(
          isFilled ? color : Colors.blue.shade800
        ),
      ),
      onPressed: () => onPressed(), 
      child: Padding(
        padding: EdgeInsets.symmetric( horizontal: 20, vertical: 10 ),
        child: Text( 
          text,
          style: TextStyle( fontSize: 16, color: isTextWhite ? Colors.white : Colors.white ),
        ),
      )
    );
  }
}