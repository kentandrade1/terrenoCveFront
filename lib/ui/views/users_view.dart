import 'package:admin_dashboard/providers/users_provider.dart';
import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../datatables/users_datasource.dart';
import '../../models/usuario.dart';
import '../../providers/auth_provider.dart';
import 'package:flutter/services.dart';

import '../buttons/custom_outlined_button.dart';

class UsersView extends StatefulWidget {
  @override
  _UsersViewState createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  bool _showPassword = false;
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _correoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  List<String> roles = ['ASESOR_ROLE', 'ADMIN_ROLE', 'CLIENTE_ROLE'];
  String? selectedRole = "ASESOR_ROLE";

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);
    final user = Provider.of<AuthProvider>(context).user!;
    final List<Usuario> usuario = [];
    usersProvider.users.forEach((element) {
      if (element.correo != user.correo) usuario.add(element);
    });
    final usersDataSource = new UsersDataSource(usuario, user,context);
    return Card(
      elevation: 10,
      color: Colors.grey.shade200,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            SizedBox(height: 20),
           PaginatedDataTable(
             columnSpacing: 0,
             horizontalMargin:20,
            
             sortAscending: usersProvider.ascending,
             sortColumnIndex: usersProvider.sortColumnIndex,
             columns: [
               DataColumn(label: Text('Rol')),
               DataColumn(
                 label: Text('Nombre'),
                 onSort: (colIndex, _) {
                   usersProvider.sortColumnIndex = colIndex;
                   usersProvider.sort<String>((user) => user.nombre);
                 },
               ),
               DataColumn(label: Text('Apellido')),
               DataColumn(label: Text('Cedula')),
               DataColumn(label: Text('Dirección')),
               DataColumn(label: Text('Teléfono')),
               DataColumn(
                 label: Text('Email'),
                 onSort: (colIndex, _) {
                   usersProvider.sortColumnIndex = colIndex;
                   usersProvider.sort<String>((user) => user.correo);
                 },
               ),
               DataColumn(label: Text('Acciones')),
             ],
             source: usersDataSource,
             onPageChanged: (page) {},
           )
    ,
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CustomOutlinedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                title: Text('Nuevo Usuario'),
                                content: SingleChildScrollView(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                         TextFormField(
              controller: _nombreController,
              decoration: CustomInputs.formInputDecoration(
                hint: 'Nombre del usuario', 
                label: 'Nombre', 
                icon: Icons.supervised_user_circle_outlined
              ),
             
              validator: ( value ) {
                if ( value == null || value.isEmpty ) return 'Ingrese un nombre.';
                if ( value.length < 2 ) return 'El nombre debe de ser de dos letras como mínimo.';
                return null;
              },
            ),
             SizedBox( height: 20 ),
              TextFormField(
                controller: _apellidoController,
              decoration: CustomInputs.formInputDecoration(
                hint: 'Apellido del usuario', 
                label: 'Apellido', 
                icon: Icons.supervised_user_circle_outlined
              ),
             
              validator: ( value ) {
                if ( value == null || value.isEmpty ) return 'Ingrese un apellido.';
                if ( value.length < 2 ) return 'apellido incorrecta.';
                return null;
              },
            ),
              SizedBox( height: 20 ),
              TextFormField(
               controller: _cedulaController,
              decoration: CustomInputs.formInputDecoration(
                hint: 'Cédula del usuario', 
                label: 'Cédula', 
                icon: Icons.supervised_user_circle_outlined
              ),
             
              validator: ( value ) {
                if ( value == null || value.isEmpty ) return 'Ingrese un Cédula.';
                if ( value.length < 2 ) return 'Cédula incorrecta.';
                return null;
              },
            ),
              SizedBox( height: 20 ),
              TextFormField(
                controller: _direccionController,
              decoration: CustomInputs.formInputDecoration(
                hint: 'Dirección del usuario', 
                label: 'Dirección', 
                icon: Icons.supervised_user_circle_outlined
              ),
            
              validator: ( value ) {
                if ( value == null || value.isEmpty ) return 'Ingrese una dirección.';
                if ( value.length < 2 ) return 'dirección incorrecta.';
                return null;
              },
            ),
             SizedBox( height: 20 ),
              TextFormField(
               controller: _telefonoController,
              decoration: CustomInputs.formInputDecoration(
                hint: 'Teléfono del usuario', 
                label: 'Teléfono', 
                icon: Icons.supervised_user_circle_outlined
              ),
              
              validator: ( value ) {
                if ( value == null || value.isEmpty ) return 'Ingrese un teléfono.';
                if ( value.length < 2 ) return 'teléfono incorrecta.';
                return null;
              },
            ),


            SizedBox( height: 20 ),

            TextFormField(
              controller: _correoController,
              decoration: CustomInputs.formInputDecoration(
                hint: 'Correo del usuario', 
                label: 'Correo', 
                icon: Icons.mark_email_read_outlined
              ),
            
              validator: ( value ) {
                if( !EmailValidator.validate(value ?? '') ) return 'Email no válido';

                return null;
              },
            ),
                             
               SizedBox( height: 20 ),

                                        TextFormField(
                                          controller: _passwordController,
                                          obscureText: !_showPassword,
                                          decoration: CustomInputs.formInputDecoration(
                hint: 'Contraseña del usuario', 
                label: 'Contraseña', 
                icon: Icons.supervised_user_circle_outlined,
                suffixIcon:  IconButton(
                                              icon: Icon(_showPassword
                                                  ? Icons.visibility
                                                  : Icons.visibility_off),
                                              onPressed: () {
                                                setState(() {
                                                  _showPassword = !_showPassword;
                                                });
                                              },
                                            ),
              ),
           
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Por favor, ingrese la contraseña';
                                            }
                                            return null;
                                          },
                                        ),
    
                                        // Radio button para seleccionar el rol
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  CustomOutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      text: "Cancelar"),
                                  CustomOutlinedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate() &&
                                          selectedRole != null) {
                                        final nombre = _nombreController.text;
                                        final correo = _correoController.text;
                                        final direccion =
                                            _direccionController.text;
                                        final telefono = _telefonoController.text;
                                        final password = _passwordController.text;
                                        final apellido=_apellidoController.text;
                                        final cedula=_cedulaController.text;
                             // Imprimir el rol seleccionado
    
                                        await usersProvider.crearCliente(
                                            correo,
                                            direccion,
                                            telefono,
                                            nombre,
                                            password,
                                            "CLIENTE_ROLE",cedula,apellido);
    
                                        Navigator.pop(
                                            context); // Cerrar el diálogo
                                      }
                                    },
                                    text: "Guardar",
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  text: "Agregar cliente",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
