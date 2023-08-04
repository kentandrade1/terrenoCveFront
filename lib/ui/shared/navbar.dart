import 'package:admin_dashboard/providers/sidemenu_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';



class Navbar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final user = Provider.of<AuthProvider>(context).user!;
     final currentTime = DateTime.now();
    final formattedDateTime = DateFormat('dd MMMM yyyy, HH:mm:ss').format(currentTime);

    return Padding(
      padding:  EdgeInsets.only(),
      child: Container(
        width: double.infinity,    
        height: 60,
        decoration: buildBoxDecoration(),
        child: Row(
          children: [
            
            if ( size.width <= 700 )
              IconButton(
                icon: Icon( Icons.menu_outlined,color: Colors.white, ), 
                onPressed: () => SideMenuProvider.openMenu()
              ),
            
            SizedBox( width: 5 ),
          
              SizedBox(width: 10,),
           
           

            Spacer(),
             

             Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
            if(user.rol=="SISTEMA_ROLE")
            Text("GERENTE",style: TextStyle(color: Colors.white),),
              if(user.rol=="ADMIN_ROLE")
            Text("ADMIN",style: TextStyle(color: Colors.white),),
              if(user.rol=="CLIENTE_ROLE")
            Text("CLIENTE",style: TextStyle(color: Colors.white),),
              if(user.rol=="ASESOR_ROLE")
            Text("ASESOR",style: TextStyle(color: Colors.white),),
                 Text("Nombre del usuario: ${user.nombre}",style: TextStyle(color: Colors.white),),
                 Text("Última vez: $formattedDateTime", style: TextStyle(color: Colors.white),),
              ],
            ),
          
            SizedBox(width: 10,),
          
            CircleAvatar(
            child: Icon(Icons.person),
            ),
              SizedBox(width: 10,),
          ],
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color( 0xff092044 ),
        Color.fromARGB(255, 20, 52, 101),
      ]
    ),
    //borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
    boxShadow: [
      BoxShadow(
        color: Colors.white,
        blurRadius: 5
      )
    ]
  );
}