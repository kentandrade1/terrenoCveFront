import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class PerfilView extends StatefulWidget {
  @override
  _PerfilViewState createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _direccionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user!;
    _nombreController.text = user.nombre;
    _telefonoController.text = user.telefono;
    _direccionController.text = user.direccion;
    _apellidoController.text=user.apellido!=null?user.apellido!:"";
    _cedulaController.text=user.cedula!=null?user.cedula!:"";
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

void _guardarCambios() async{
}



  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user!;
    final generalProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(50),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Perfil',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: user.correo,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Correo',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _apellidoController,
                  decoration: InputDecoration(
                    labelText: 'Apellido',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _cedulaController,
                  decoration: InputDecoration(
                    labelText: 'Cédula',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _telefonoController,
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _direccionController,
                  decoration: InputDecoration(
                    labelText: 'Dirección',
                  ),
                ),
                SizedBox(height: 10),
                CustomOutlinedButton(
                  onPressed: ()async {
                    
                  final correo = Provider.of<AuthProvider>(context, listen: false).user!.correo;
                  final id = Provider.of<AuthProvider>(context, listen: false).user!.uid;
                  final rol = Provider.of<AuthProvider>(context, listen: false).user!.rol;
                  final nombre = _nombreController.text.trim();
                  final telefono = _telefonoController.text.trim();
                  final direccion = _direccionController.text.trim();
                   final cedula = _cedulaController.text.trim();
                    final apellido = _apellidoController.text.trim();
                  if (nombre.isEmpty || telefono.isEmpty || direccion.isEmpty|| apellido.isEmpty|| cedula.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text('Por favor, ingrese todos los datos.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Aceptar'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Todos los campos están completos, realizar la lógica de guardado

                    await generalProvider.actualizarPerfil(correo, direccion, telefono, nombre, id,rol,cedula,apellido);
                  }
                  },
                  text: "Guardar",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
