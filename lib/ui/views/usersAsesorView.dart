import 'package:admin_dashboard/providers/users_provider.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../datatables/users_datasource.dart';
import '../../models/usuario.dart';
import '../../providers/auth_provider.dart';
import '../../router/router.dart';
import '../buttons/custom_outlined_button.dart';

class UsersAsesorView extends StatefulWidget {
  @override
  _UsersAsesorViewState createState() => _UsersAsesorViewState();
}

class _UsersAsesorViewState extends State<UsersAsesorView> {
  bool _showPassword = false;
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
    final _apellidoController = TextEditingController();
  final _cedulaController = TextEditingController();
  void _mostrarDialogNuevoUsuario(UsersProvider userP) {
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);
    final user = Provider.of<AuthProvider>(context).user!;
    final List<Usuario> usuario = [];
    usersProvider.users.forEach((element) {
      if (element.rol == "CLIENTE_ROLE") {
        usuario.add(element);
      }
    });
    final usersDataSource = new UsersDataSource( usuario,user,context );
    return Card(
      elevation: 10,
      color: Colors.grey.shade200,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CustomOutlinedButton(
                    onPressed: ()async{
                      
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext){
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
                                  decoration: InputDecoration(labelText: 'Nombre'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Por favor, ingrese el nombre';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                          controller: _apellidoController,
                                          decoration: InputDecoration(
                                              labelText: 'Apellido'),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Por favor, ingrese el apellido';
                                            }
                                            return null;
                                          },
                                        ),
                                         TextFormField(
                                          controller: _cedulaController,
                                          decoration: InputDecoration(
                                              labelText: 'Cédula'),
                                          validator: (value) {
                                            if (value!.length!=10) {
                                              return 'Por favor, ingrese la cédula';
                                            }
                                            return null;
                                          },
                                        ),
                                TextFormField(
                                  controller: _correoController,
                                  decoration: InputDecoration(labelText: 'Correo'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Por favor, ingrese el correo';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: _direccionController,
                                  decoration: InputDecoration(labelText: 'Dirección'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Por favor, ingrese la dirección';
                                    }
                                    return null;
                                  },
                                ),
                                 TextFormField(
                                          controller: _telefonoController,
                                          decoration: InputDecoration(
                                              labelText: 'Teléfono'),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(10),
                                          ],
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Por favor, ingrese el teléfono';
                                            } else if (value.length < 10) {
                                              return 'El teléfono debe tener 10 dígitos';
                                            }
                                            return null;
                                          },
                                        ),
                                TextFormField(
                                          controller: _passwordController,
                                          obscureText: !_showPassword,
                                          decoration: InputDecoration(
                                            labelText: 'Contraseña',
                                            suffixIcon: IconButton(
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
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          ElevatedButton(onPressed: (){
               Navigator.of(context).pop();
            }, child: Text("Cancelar")),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final nombre = _nombreController.text;
                                final correo = _correoController.text;
                                final direccion = _direccionController.text;
                                final telefono = _telefonoController.text;
                                final password = _passwordController.text;
                                 final apellido=_apellidoController.text;
                                        final cedula=_cedulaController.text;
                                print('Nombre: $nombre');
                                print('Correo: $correo');
                                print('Dirección: $direccion');
                                print('Teléfono: $telefono');
                                print('Contraseña: $password');
                                await usersProvider.crearCliente(correo, direccion, telefono, nombre,password, "CLIENTE_ROLE",cedula,apellido);
                                Navigator.pop(context); // Cerrar el diálogo
                              }
                            },
                            child: Text('Guardar'),
                          ),
                        ],
                      );
                            },
                          );
                      }
                    );
                    },
                    text:"Agregar",
                  ),
                ),
                SizedBox(width: 10,),
                       Center(
                  child: CustomOutlinedButton(
                    onPressed: ()async{
                           NavigationService.replaceTo(Flurorouter.dashboardRoute);
                    },
                    text:"Salir",
                  ),
                ),
         
              ],
            ),
    
            SizedBox(height: 20),
            PaginatedDataTable(
                     columnSpacing: 0,
             horizontalMargin:20,
              sortAscending: usersProvider.ascending,
              sortColumnIndex: usersProvider.sortColumnIndex,
              columns: [
                DataColumn(label: Text('ROL')),
                DataColumn(label: Text('Nombre'), onSort: ( colIndex, _ ) {
                  usersProvider.sortColumnIndex = colIndex;
                  usersProvider.sort<String>((user) => user.nombre);
                }),
                      DataColumn(label: Text('Apellido')),
                      DataColumn(label: Text('Cedula')),
                       DataColumn(label: Text('Dirección')),
                        DataColumn(label: Text('Teléfono')),
                DataColumn(label: Text('Email'), onSort: ( colIndex, _ ) {
                  usersProvider.sortColumnIndex = colIndex;
                  usersProvider.sort<String>((user) => user.correo);
                }),
               
                DataColumn(label: Text('Acciones')),
              ], 
              source: usersDataSource,
              onPageChanged: ( page ) {
                
              },
            )
          ],
        ),
      ),
    );
  }
}
