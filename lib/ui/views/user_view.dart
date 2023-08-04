import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';

import 'package:admin_dashboard/models/usuario.dart';

import 'package:admin_dashboard/providers/providers.dart';


import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/services/notifications_service.dart';

import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:admin_dashboard/ui/labels/custom_labels.dart';
import 'package:admin_dashboard/ui/cards/white_card.dart';

import '../../router/router.dart';
import '../buttons/custom_outlined_button.dart';


class UserView extends StatefulWidget {

  final String uid;

  const UserView({
    Key? key, 
    required this.uid
  }) : super(key: key);

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {

  Usuario? user;


  @override
  void initState() { 
    super.initState();
    final usersProvider    = Provider.of<UsersProvider>(context, listen: false);
    final userFormProvider = Provider.of<UserFormProvider>(context, listen: false);

    usersProvider.getUserById(widget.uid)
      .then((userDB) {
        
        if ( userDB != null ) {
          userFormProvider.user = userDB;
          userFormProvider.formKey = new GlobalKey<FormState>();
          
          setState((){ this.user = userDB; });
        } else {
          NavigationService.replaceTo('/dashboard/users');
        }

      }
    );
    
  }

  @override
  void dispose() { 
    Provider.of<UserFormProvider>(context, listen: false).user = null;
    super.dispose();
  }
  


  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric( horizontal: 20, vertical: 10 ),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('VISTA DEL USUARIO', style: CustomLabels.h1 ),

          SizedBox( height: 10 ),

          if( user == null ) 
            WhiteCard(
              child: Container(
                alignment: Alignment.center,
                height: 300,
                child: CircularProgressIndicator(),
              )
            ),
          
          if( user != null ) 
            _UserViewBody()

        ],
      ),
    );
  }
}

class _UserViewBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Table(
        columnWidths: {
          0: FixedColumnWidth(300)
        },

        children: [
          TableRow(
            children: [
              // AVATAR
             // _AvatarContainer(),

              // Formulario de actualización
              _UserViewForm(),
            ]
          )
        ],
      ),
    );
  }
}

class _UserViewForm extends StatelessWidget {
  const _UserViewForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final userFormProvider = Provider.of<UserFormProvider>(context);
    final user = userFormProvider.user!;
    final List<String> roles = ['SISTEMA_ROLE', 'ASESOR_ROLE', 'CLIENTE_ROLE', 'ADMIN_ROLE'];
    return WhiteCard(
      title: 'Información general',
      child: Form(
        key: userFormProvider.formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: [

            TextFormField(
              initialValue: user.nombre,
              decoration: CustomInputs.formInputDecoration(
                hint: 'Nombre del usuario', 
                label: 'Nombre', 
                icon: Icons.supervised_user_circle_outlined
              ),
              onChanged: ( value )=> userFormProvider.copyUserWith( nombre: value ),
              validator: ( value ) {
                if ( value == null || value.isEmpty ) return 'Ingrese un nombre.';
                if ( value.length < 2 ) return 'El nombre debe de ser de dos letras como mínimo.';
                return null;
              },
            ),
             SizedBox( height: 20 ),
              TextFormField(
              initialValue: user.apellido,
              decoration: CustomInputs.formInputDecoration(
                hint: 'Apellido del usuario', 
                label: 'Apellido', 
                icon: Icons.supervised_user_circle_outlined
              ),
              onChanged: ( value )=> userFormProvider.copyUserWith( apellido: value ),
              validator: ( value ) {
                if ( value == null || value.isEmpty ) return 'Ingrese un apellido.';
                if ( value.length < 2 ) return 'apellido incorrecta.';
                return null;
              },
            ),
              SizedBox( height: 20 ),
              TextFormField(
              initialValue: user.cedula,
              decoration: CustomInputs.formInputDecoration(
                hint: 'Cédula del usuario', 
                label: 'Cédula', 
                icon: Icons.supervised_user_circle_outlined
              ),
              onChanged: ( value )=> userFormProvider.copyUserWith( cedula: value ),
              validator: ( value ) {
                if ( value == null || value.isEmpty ) return 'Ingrese un Cédula.';
                if ( value.length < 2 ) return 'Cédula incorrecta.';
                return null;
              },
            ),
              SizedBox( height: 20 ),
              TextFormField(
              initialValue: user.direccion,
              decoration: CustomInputs.formInputDecoration(
                hint: 'Dirección del usuario', 
                label: 'Dirección', 
                icon: Icons.supervised_user_circle_outlined
              ),
              onChanged: ( value )=> userFormProvider.copyUserWith( direccion: value ),
              validator: ( value ) {
                if ( value == null || value.isEmpty ) return 'Ingrese una dirección.';
                if ( value.length < 2 ) return 'dirección incorrecta.';
                return null;
              },
            ),
             SizedBox( height: 20 ),
              TextFormField(
              initialValue: user.telefono,
              decoration: CustomInputs.formInputDecoration(
                hint: 'Teléfono del usuario', 
                label: 'Teléfono', 
                icon: Icons.supervised_user_circle_outlined
              ),
              onChanged: ( value )=> userFormProvider.copyUserWith( telefono: value ),
              validator: ( value ) {
                if ( value == null || value.isEmpty ) return 'Ingrese un teléfono.';
                if ( value.length < 2 ) return 'teléfono incorrecta.';
                return null;
              },
            ),


            SizedBox( height: 20 ),

            TextFormField(
              initialValue: user.correo,
              decoration: CustomInputs.formInputDecoration(
                hint: 'Correo del usuario', 
                label: 'Correo', 
                icon: Icons.mark_email_read_outlined
              ),
              onChanged: ( value )=> userFormProvider.copyUserWith( correo: value ),
              validator: ( value ) {
                if( !EmailValidator.validate(value ?? '') ) return 'Email no válido';

                return null;
              },
            ),

             SizedBox( height: 20 ),

            DropdownButtonFormField<String>(
              value: user.rol,
              decoration: CustomInputs.formInputDecoration(
                hint: 'Rol del usuario', 
                label: 'Rol', 
                icon: Icons.admin_panel_settings
              ),
              items: roles.map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                userFormProvider.copyUserWith(rol: value);
              },
            ),


            SizedBox( height: 20 ),
            Row( 
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  ConstrainedBox(
              constraints: BoxConstraints( maxWidth: 130 ),
              child: CustomOutlinedButton(
                text: "Atrás",
                onPressed: () async {

                 NavigationService.replaceTo(Flurorouter.usersRoute);


                }, 
                
                
              ),
            ),
              SizedBox(width: 20,),
                ConstrainedBox(
              constraints: BoxConstraints( maxWidth: 130 ),
              child: CustomOutlinedButton(
                text: "Guardar",
                onPressed: () async {

                  final saved = await userFormProvider.updateUser();
                  if( saved ) {
                    NotificationsService.showSnackbar('Usuario actualizado');
                    Provider.of<UsersProvider>(context, listen: false).refreshUser( user );
                  } else {
                    NotificationsService.showSnackbarError('No se pudo guardar');
                  }


                }, 
               
              ),
            ),
          
          
            ],),
            

          ],
        ),
      )
    );
  }
}




class _AvatarContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final userFormProvider = Provider.of<UserFormProvider>(context);
    final user = userFormProvider.user!;

    final image = ( user.img == null )  
      ? Image(image: AssetImage('no-image.jpg') )
      : FadeInImage.assetNetwork(placeholder: 'loader.gif', image: user.img! );


    return WhiteCard(
      width: 250,
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Profile', style: CustomLabels.h2),
            SizedBox( height: 20 ),

            Container(
              width: 150,
              height: 160,
              child: Stack(
                children: [
                  
                  ClipOval(
                    child: image
                  ),

                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all( color: Colors.white, width: 5 )
                      ),
                      child: FloatingActionButton(
                        backgroundColor: Colors.indigo,
                        elevation: 0,
                        child: Icon( Icons.camera_alt_outlined, size: 20,),
                        onPressed: () async {
                          
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            allowedExtensions: ['jpg','jpeg','png'],
                            allowMultiple: false
                          );

                          if(result != null) {
                            // PlatformFile file = result.files.first;
                            NotificationsService.showBusyIndicator(context);
                            
                            final newUser = await userFormProvider.uploadImage('/uploads/usuarios/${ user.uid }', result.files.first.bytes! );

                            Provider.of<UsersProvider>(context, listen: false)
                              .refreshUser(newUser);
                            

                            Navigator.of(context).pop();
                            
                          } else {
                            // User canceled the picker
                            print('no hay imagen');
                          }

                        },
                      ),
                    ),
                  )

                ],
              )
            ),

            SizedBox( height: 20 ),

            Text(
              user.nombre,
              style: TextStyle( fontWeight: FontWeight.bold ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      )
    );
  }
}