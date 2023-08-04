import 'package:admin_dashboard/router/dashboard_handlers.dart';
import 'package:admin_dashboard/router/no_page_found_handlers.dart';
import 'package:fluro/fluro.dart';
import 'package:admin_dashboard/router/admin_handlers.dart';

class Flurorouter {

  static final FluroRouter router = new FluroRouter();

  static String rootRoute     = '/';

  // Auth Router
  static String loginRoute    = '/auth/login';
  static String registerRoute = '/auth/register';

  // Dashboard
  static String dashboardRoute  = '/dashboard';


  static String categoriesRoute = '/dashboard/solares';
  static String solaresAsesor = '/dashboard/asesor/solares';
  static String solaresClient = '/dashboard/cliente/solares';
  
    static String ordenesClient = '/dashboard/cliente/ordenes';
    static String ordenesAsesor = '/dashboard/asesor/ordenes';

  static String reservasAsesor = '/dashboard/asesor/reservas';
  static String contratoAsesor = '/dashboard/asesor/contrato';
  static String reservasCliente = '/dashboard/cliente/reservas';
   static String userAsesorRoute  = '/dashboard/users/Asesor';
   static String asesorReportesRoute  = '/dashboard/asesor/reportes';
  static String adminReportesRoute  = '/dashboard/admin/reportes';
  static String perfilRoute = '/dashboard/perfil';
  static String usersRoute = '/dashboard/cliente';
  static String userRoute  = '/dashboard/users/:uid';
    static String ressetView  = '/auth/ressetPasswordP/:token';
    static String ressetPasswordEmailView = '/auth/ressetPassword';

  static void configureRoutes() {
    // Auth Routes
    router.define( rootRoute, handler: AdminHandlers.login, transitionType: TransitionType.none );
    router.define( loginRoute, handler: AdminHandlers.login, transitionType: TransitionType.none );
    router.define( registerRoute, handler: AdminHandlers.register, transitionType: TransitionType.none );
            router.define( ressetPasswordEmailView, handler: AdminHandlers.ressetPasswordEmailView, transitionType: TransitionType.none );
     router.define( ressetView, handler: AdminHandlers.resset, transitionType: TransitionType.none );
    // Dashboard
    router.define( dashboardRoute, handler: DashboardHandlers.dashboard, transitionType: TransitionType.fadeIn );

    router.define( categoriesRoute, handler: DashboardHandlers.categories, transitionType: TransitionType.fadeIn );

    router.define( solaresAsesor, handler: DashboardHandlers.asesoresSolares, transitionType: TransitionType.fadeIn );
  router.define( solaresClient, handler: DashboardHandlers.solaresClient, transitionType: TransitionType.fadeIn );
    router.define( ordenesClient, handler: DashboardHandlers.ordenesClient, transitionType: TransitionType.fadeIn );
   router.define( ordenesAsesor, handler: DashboardHandlers.ordenesAsesor, transitionType: TransitionType.fadeIn );
   router.define( reservasAsesor, handler: DashboardHandlers.reservasAsesor, transitionType: TransitionType.fadeIn );
  router.define( reservasCliente, handler: DashboardHandlers.reservasCliente, transitionType: TransitionType.fadeIn );
   router.define( perfilRoute, handler: DashboardHandlers.perfilRoute, transitionType: TransitionType.fadeIn );
   router.define( userAsesorRoute, handler: DashboardHandlers.userAsesorRoute, transitionType: TransitionType.fadeIn );
   router.define( contratoAsesor, handler: DashboardHandlers.contratoAsesor, transitionType: TransitionType.fadeIn );
      router.define( asesorReportesRoute, handler: DashboardHandlers.asesorReportesRoute, transitionType: TransitionType.fadeIn );
    router.define( adminReportesRoute, handler: DashboardHandlers.adminReportesRoute, transitionType: TransitionType.fadeIn );
    // users
    // users
    router.define( usersRoute, handler: DashboardHandlers.users, transitionType: TransitionType.fadeIn );
    router.define( userRoute, handler: DashboardHandlers.user, transitionType: TransitionType.fadeIn );

    // 404
    router.notFoundHandler = NoPageFoundHandlers.noPageFound;

  }
  


}

