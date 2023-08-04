import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/ui/shared/widgets/customdialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/providers/sidemenu_provider.dart';

import 'package:admin_dashboard/router/router.dart';

import 'package:admin_dashboard/services/navigation_service.dart';

import 'package:admin_dashboard/ui/shared/widgets/menu_item.dart';
import 'package:admin_dashboard/ui/shared/widgets/logo.dart';

import '../../services/notifications_service.dart';



class Sidebar extends StatelessWidget {
   void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: 'Cerrar sesión',
        content: '¿Deseas salir directamente del sistema?',
        onCancel: () {
          Navigator.of(context).pop();
        },
        onClose: () {
          Navigator.of(context).pop();
          // Lógica para cerrar sesión aquí
        },
      ),
    );
  }

  void navigateTo( String routeName ) {
    NavigationService.replaceTo( routeName );
    SideMenuProvider.closeMenu();
  }

  @override
  Widget build(BuildContext context) {

    final sideMenuProvider = Provider.of<SideMenuProvider>(context);
      final user = Provider.of<AuthProvider>(context).user!;
    return Container(
      width: 200,
      height: double.infinity,
      decoration: buildBoxDecoration(),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [

          Logo(),

          SizedBox( height: 10 ),
          if(user.rol=="SISTEMA_ROLE")
          Column(
            children: [

              MenuItem( 
            text: 'Usuarios', 
            icon: Icons.people_alt_outlined, 
            onPressed: () => navigateTo( Flurorouter.usersRoute ),
            isActive: sideMenuProvider.currentPage == Flurorouter.usersRoute,
          ),
          MenuItem(
            text: 'Solares', 
            icon: Icons.layers_outlined, 
            onPressed: () => navigateTo( Flurorouter.categoriesRoute ),
            isActive: sideMenuProvider.currentPage == Flurorouter.categoriesRoute,
          ),
          
          MenuItem(
            text: 'Reportes', 
            icon: Icons.analytics_outlined, 
              onPressed: () => navigateTo( Flurorouter.adminReportesRoute ),
            isActive: sideMenuProvider.currentPage == Flurorouter.adminReportesRoute,
          ),
           MenuItem(
            text: 'General',
            icon: Icons.dashboard_outlined,
            onPressed: () => navigateTo( Flurorouter.dashboardRoute ),
            isActive: sideMenuProvider.currentPage == Flurorouter.dashboardRoute,
          ),
            ],
          ),
          if(user.rol=="ADMIN_ROLE")  
          Column(
            children: [
                   MenuItem( 
            text: 'Usuarios', 
            icon: Icons.people_alt_outlined, 
            onPressed: () => navigateTo( Flurorouter.usersRoute ),
            isActive: sideMenuProvider.currentPage == Flurorouter.usersRoute,
          ),
          MenuItem(
            text: 'Solares', 
            icon: Icons.layers_outlined, 
            onPressed: () => navigateTo( Flurorouter.categoriesRoute ),
            isActive: sideMenuProvider.currentPage == Flurorouter.categoriesRoute,
          ),
          
          MenuItem(
            text: 'Reportes', 
            icon: Icons.analytics_outlined, 
              onPressed: () => navigateTo( Flurorouter.adminReportesRoute ),
            isActive: sideMenuProvider.currentPage == Flurorouter.adminReportesRoute,
          ),

          
           MenuItem(
            text: 'General',
            icon: Icons.dashboard_outlined,
            onPressed: () => navigateTo( Flurorouter.dashboardRoute ),
            isActive: sideMenuProvider.currentPage == Flurorouter.dashboardRoute,
          ),
            ],
          ),
          if(user.rol=="ASESOR_ROLE")
          Column(
            children: [

          MenuItem(
            text: 'Registro de clientes', 
            icon: Icons.person_add_alt_1_outlined, 
            onPressed: () => navigateTo( Flurorouter.userAsesorRoute ),
            isActive: sideMenuProvider.currentPage == Flurorouter.userAsesorRoute,
          ),
             MenuItem(
            text: 'Estado de solares', 
            icon: Icons.calendar_today_outlined, 
            onPressed: () => navigateTo( Flurorouter.solaresAsesor ),
            isActive: sideMenuProvider.currentPage == Flurorouter.solaresAsesor,
          ),
            MenuItem(
            text: 'Validación de orden', 
            icon: Icons.calendar_today_outlined, 
            onPressed: () => navigateTo( Flurorouter.ordenesAsesor ),
            isActive: sideMenuProvider.currentPage == Flurorouter.ordenesAsesor,
          ),
             MenuItem(
            text: 'Ver reservaciones', 
            icon: Icons.view_list_outlined, 
            onPressed: () => navigateTo( Flurorouter.reservasAsesor ),
            isActive: sideMenuProvider.currentPage == Flurorouter.reservasAsesor,
          ),
               MenuItem(
            text: 'Generación de contratos', 
            icon: Icons.file_copy_outlined, 
            onPressed: () => navigateTo( Flurorouter.contratoAsesor ),
            isActive: sideMenuProvider.currentPage == Flurorouter.contratoAsesor,
          ),
               MenuItem(
            text: 'Reportes y estadísticas', 
            icon: Icons.bar_chart_outlined, 
             onPressed: () => navigateTo( Flurorouter.asesorReportesRoute ),
            isActive: sideMenuProvider.currentPage == Flurorouter.asesorReportesRoute,
          ),
           MenuItem(
            text: 'General',
            icon: Icons.dashboard_outlined,
            onPressed: () => navigateTo( Flurorouter.dashboardRoute ),
            isActive: sideMenuProvider.currentPage == Flurorouter.dashboardRoute,
          ),
            ],
          ),
          if(user.rol=="CLIENTE_ROLE")
         Column(children: [

          MenuItem(
            text: 'Perfil', 
            icon: Icons.account_circle_outlined, 
           onPressed: () => navigateTo( Flurorouter.perfilRoute ),
             isActive: sideMenuProvider.currentPage == Flurorouter.perfilRoute,
          ),
              MenuItem(
            text: 'Buscar Terrenos', 
            icon: Icons.search_outlined, 
       onPressed: () => navigateTo( Flurorouter.solaresClient ),
            isActive: sideMenuProvider.currentPage == Flurorouter.solaresClient,
          ),
               MenuItem(
            text: 'Orden de pago', 
            icon: Icons.payment_outlined, 
            onPressed: () => navigateTo( Flurorouter.ordenesClient ),
             isActive: sideMenuProvider.currentPage == Flurorouter.ordenesClient,
          ),
               MenuItem(
            text: 'Ver reservas', 
            icon: Icons.view_list_outlined, 
            onPressed: () => navigateTo( Flurorouter.reservasCliente ),
             isActive: sideMenuProvider.currentPage == Flurorouter.reservasCliente,
          ),
            MenuItem(
            text: 'General',
            icon: Icons.dashboard_outlined,
            onPressed: () => navigateTo( Flurorouter.dashboardRoute ),
            isActive: sideMenuProvider.currentPage == Flurorouter.dashboardRoute,
          ),
         ],),

           
      

          SizedBox( height: 10 ),

          MenuItem( 
            text: 'Logout', 
            icon: Icons.exit_to_app_outlined, 
            onPressed: (){
                 NotificationsService.showSnackbarError('Cerrando sesión');
   
              Provider.of<AuthProvider>(context, listen: false)
                .logout();
            }),
        ],
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
      // borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),
    boxShadow: [
    BoxShadow(
      color: Colors.white.withOpacity(1), // Color de la sombra, puedes ajustar la opacidad según tus preferencias
      offset: Offset(0, 8), // Ajusta el desplazamiento en la dirección x e y para el efecto de elevación
      blurRadius: 20, // Ajusta el radio de desenfoque para suavizar o enfocar la sombra
      spreadRadius: 5, // Ajusta la expansión de la sombra
    ),
    ]
  );
}