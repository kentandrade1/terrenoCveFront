import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:flutter/material.dart';

import 'package:admin_dashboard/services/navigation_service.dart';

import 'package:admin_dashboard/models/usuario.dart';
import 'package:provider/provider.dart';

import '../providers/users_provider.dart';
import '../services/notifications_service.dart';

class UsersDataSource extends DataTableSource {

  final List<Usuario> users;
  final Usuario usuario;
    final BuildContext context;
  UsersDataSource(this.users, this.usuario, this.context);


  @override
  DataRow getRow(int index) {
    

    final Usuario user = users[index];
    String mapUserRole(String role) {
        switch (role) {
          case "CLIENTE_ROLE":
            return "Cliente";
          case "ADMIN_ROLE":
            return "Admin";
          case "ASESOR_ROLE":
            return "Asesor";
          default:
            return role; // Si no es ninguno de los roles especificados, devuelve el valor original.
        }
      }

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(mapUserRole(user.rol)),
        ),
        DataCell( Text( user.nombre ) ),
        DataCell( Text( user.apellido!=null?user.apellido!:"" ) ),
        DataCell( Text( user.cedula!=null?user.cedula!:"" ) ),
        DataCell( Text( user.direccion ) ),
         DataCell( Text( user.telefono ) ),
        DataCell( Text( user.correo ) ),
       
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon( usuario.rol=="SISTEMA_ROLE"? Icons.edit_outlined:Icons.block ), 
                onPressed: ()async {
                  
                  if(usuario.rol=="SISTEMA_ROLE")
                  NavigationService.replaceTo('/dashboard/users/${ user.uid }');
                }
              ),
                IconButton(
                icon: Icon( usuario.rol=="SISTEMA_ROLE"? Icons.delete:Icons.block ), 
                onPressed: ()async {
                 
                  if(usuario.rol=="SISTEMA_ROLE"){
                        final usersProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  await usersProvider.deleteUser(user.uid);
                      final usersProvider1 = Provider.of<UsersProvider>(context,listen: false);
                      usersProvider1.getPaginatedUsers();
                   NotificationsService.showSnackbar('Usuario eliminado');
                  }
                  
                  
                }
              ),
            ],
          )
        ),
      ]
    );
  }

  @override
  
  bool get isRowCountApproximate => false;

  @override
  
  int get rowCount => this.users.length;

  @override
  
  int get selectedRowCount => 0;


}