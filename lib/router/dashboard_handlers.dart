import 'package:admin_dashboard/ui/views/ContratosAsesor_view.dart';
import 'package:admin_dashboard/ui/views/Perfil_view.dart';
import 'package:admin_dashboard/ui/views/ReportesAdmin_view.dart';
import 'package:admin_dashboard/ui/views/ReportesAsesor_view.dart';
import 'package:admin_dashboard/ui/views/ReservasAsesor_view.dart';
import 'package:admin_dashboard/ui/views/ReservasCliente_view.dart';
import 'package:admin_dashboard/ui/views/ordenesAsesor_view.dart';
import 'package:admin_dashboard/ui/views/ordenesClient_view.dart';
import 'package:admin_dashboard/ui/views/terrenosAsesor_view.dart';
import 'package:admin_dashboard/ui/views/terrenosClient_view.dart';
import 'package:admin_dashboard/ui/views/user_view.dart';
import 'package:admin_dashboard/ui/views/usersAsesorView.dart';
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';


import 'package:admin_dashboard/router/router.dart';

import 'package:admin_dashboard/providers/sidemenu_provider.dart';
import 'package:admin_dashboard/providers/auth_provider.dart';

import 'package:admin_dashboard/ui/views/categories_view.dart';

import 'package:admin_dashboard/ui/views/dashboard_view.dart';

import 'package:admin_dashboard/ui/views/login_view.dart';
import 'package:admin_dashboard/ui/views/users_view.dart';


class DashboardHandlers {

  static Handler dashboard = Handler(
    handlerFunc: ( context, params ) {

      final authProvider = Provider.of<AuthProvider>(context!);
      Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl( Flurorouter.dashboardRoute );

      if ( authProvider.authStatus == AuthStatus.authenticated )
        return DashboardView();
      else 
        return LoginView();
    }
  );


  





  static Handler categories = Handler(
    handlerFunc: ( context, params ) {

      final authProvider = Provider.of<AuthProvider>(context!);
      Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl( Flurorouter.categoriesRoute );

      if ( authProvider.authStatus == AuthStatus.authenticated )
        return CategoriesView();
      else 
        return LoginView();
    }
  );
  
  static Handler asesoresSolares = Handler(
    handlerFunc: ( context, params ) {

      final authProvider = Provider.of<AuthProvider>(context!);
      Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl( Flurorouter.solaresAsesor );

      if ( authProvider.authStatus == AuthStatus.authenticated )
        return TerrenosAsesorView();
      else 
        return LoginView();
    }
  );
  static Handler solaresClient = Handler(
    handlerFunc: ( context, params ) {

      final authProvider = Provider.of<AuthProvider>(context!);
      Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl( Flurorouter.solaresClient );

      if ( authProvider.authStatus == AuthStatus.authenticated )
        return TerrenosClientsView();
      else 
        return LoginView();
    }
  );
    static Handler ordenesClient = Handler(
    handlerFunc: ( context, params ) {

      final authProvider = Provider.of<AuthProvider>(context!);
      Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl( Flurorouter.ordenesClient );

      if ( authProvider.authStatus == AuthStatus.authenticated )
        return OrdenesClientsView();
      else 
        return LoginView();
    }
  );
      static Handler ordenesAsesor = Handler(
    handlerFunc: ( context, params ) {

      final authProvider = Provider.of<AuthProvider>(context!);
      Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl( Flurorouter.ordenesAsesor );

      if ( authProvider.authStatus == AuthStatus.authenticated )
        return OrdenesAsesorView();
      else 
        return LoginView();
    }
  );
     static Handler reservasAsesor = Handler(
    handlerFunc: ( context, params ) {

      final authProvider = Provider.of<AuthProvider>(context!);
      Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl( Flurorouter.reservasAsesor );

      if ( authProvider.authStatus == AuthStatus.authenticated )
        return ReservasAsesorView();
      else 
        return LoginView();
    }
  );
    static Handler reservasCliente = Handler(
    handlerFunc: ( context, params ) {

      final authProvider = Provider.of<AuthProvider>(context!);
      Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl( Flurorouter.reservasCliente );

      if ( authProvider.authStatus == AuthStatus.authenticated )
        return ReservasClienteView();
      else 
        return LoginView();
    }
  );
   static Handler perfilRoute = Handler(
    handlerFunc: ( context, params ) {

      final authProvider = Provider.of<AuthProvider>(context!);
      Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl( Flurorouter.perfilRoute );

      if ( authProvider.authStatus == AuthStatus.authenticated )
        return PerfilView();
      else 
        return LoginView();
    }
  );
   static Handler userAsesorRoute= Handler(
    handlerFunc: ( context, params ) {

      final authProvider = Provider.of<AuthProvider>(context!);
      Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl( Flurorouter.userAsesorRoute );

      if ( authProvider.authStatus == AuthStatus.authenticated )
        return UsersAsesorView();
      else 
        return LoginView();
    }
  );
     static Handler contratoAsesor= Handler(
    handlerFunc: ( context, params ) {

      final authProvider = Provider.of<AuthProvider>(context!);
      Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl( Flurorouter.contratoAsesor );

      if ( authProvider.authStatus == AuthStatus.authenticated )
        return ContratoAsesorView();
      else 
        return LoginView();
    }
  );
       static Handler asesorReportesRoute= Handler(
    handlerFunc: ( context, params ) {

      final authProvider = Provider.of<AuthProvider>(context!);
      Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl( Flurorouter.asesorReportesRoute );

      if ( authProvider.authStatus == AuthStatus.authenticated )
        return ReportesAsesorView();
      else 
        return LoginView();
    }
  );
      static Handler adminReportesRoute= Handler(
    handlerFunc: ( context, params ) {

      final authProvider = Provider.of<AuthProvider>(context!);
      Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl( Flurorouter.adminReportesRoute );

      if ( authProvider.authStatus == AuthStatus.authenticated )
        return ReportesAdminView();
      else 
        return LoginView();
    }
  );
  // users
  static Handler users = Handler(
    handlerFunc: ( context, params ) {

      final authProvider = Provider.of<AuthProvider>(context!);
      Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl( Flurorouter.usersRoute );

      if ( authProvider.authStatus == AuthStatus.authenticated )
        return UsersView();
      else 
        return LoginView();
    }
  );

  // user
  static Handler user = Handler(
    handlerFunc: ( context, params ) {

      final authProvider = Provider.of<AuthProvider>(context!);
      Provider.of<SideMenuProvider>(context, listen: false)
        .setCurrentPageUrl( Flurorouter.userRoute );

      if ( authProvider.authStatus == AuthStatus.authenticated ){
        print( params );
        if ( params['uid']?.first != null ) {
            return UserView(uid: params['uid']!.first );
        } else {
          return UsersView();
        }


      } else {
        return LoginView();
      }
    }
  );

}

