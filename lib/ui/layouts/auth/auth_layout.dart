import 'package:flutter/material.dart';

import 'package:admin_dashboard/ui/layouts/auth/widgets/background_twitter.dart';
import 'package:admin_dashboard/ui/layouts/auth/widgets/custom_title.dart';



class AuthLayout extends StatelessWidget {

  final Widget child;

  const AuthLayout({
    Key? key, 
    required this.child
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Scrollbar(
        // isAlwaysShown: true,
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [

            ( size.width > 1000 )
              ? _DesktopBody( child: child)
              : _MobileBody( child: child ),
            
            // LinksBar
            //LinksBar()
          ],
        ),
      )
    );
  }
}


class _MobileBody extends StatelessWidget {

  final Widget child;
  
  const _MobileBody({
    Key? key, 
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 1000,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox( height: 20 ),
          CustomTitle(),
          Container(
            width: double.infinity,
            height: 420,
            child: child,
          ),
        ],
      ),
    );
  }
}


class _DesktopBody extends StatelessWidget {

  final Widget child;

  const _DesktopBody({
    Key? key, 
    required this.child
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
       decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('fondo-background.jpeg'), // Ruta de la imagen
          fit: BoxFit.fill,
          //opacity: 100,
          filterQuality: FilterQuality.high
        ),
      ),
      child: Row(
        children: [

          
          Padding(
            padding: const EdgeInsets.only(top:90),
            child: Container(
              width: size.width,
              height: double.infinity,
              
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 100,horizontal: 350),
                child: Card(
                  color: Colors.blue.withOpacity(0.8),
                  elevation: 10,
                  child: Column(
                    children: [
                       
                      SizedBox( height: 10 ),
                      Expanded(child: child ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}