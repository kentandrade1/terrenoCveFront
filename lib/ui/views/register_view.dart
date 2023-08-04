import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/providers/register_form_provider.dart';

import 'package:email_validator/email_validator.dart';

import 'package:admin_dashboard/router/router.dart';

import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';
import 'package:admin_dashboard/ui/buttons/link_text.dart';

class RegisterView extends StatefulWidget {
  
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ( _ ) => RegisterFormProvider(),
      child: Builder(builder: (context) {

        final registerFormProvider = Provider.of<RegisterFormProvider>(context, listen: false);

        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.symmetric( horizontal: 20 ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints( maxWidth: 370 ),
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: registerFormProvider.formKey,
                  child: Column(
                    children: [
        
                      // Email
                      TextFormField(
                        onChanged: ( value ) => registerFormProvider.name = value,
                        validator: ( value ) {
                          if ( value == null || value.isEmpty ) return 'El nombre es obligatario';
                          return null;
                        },
                        style: TextStyle( color: Colors.blue ),
                        decoration: CustomInputs.loginInputDecoration(
                          hint: 'Ingrese su nombre',
                          label: 'Nombre',
                          icon: Icons.supervised_user_circle_sharp
                        ),
                      ),
        
                      SizedBox( height: 20 ),
                      
                      // Email
                      TextFormField(
                        onChanged: ( value ) => registerFormProvider.email = value,
                        validator: ( value ) {
                          if( !EmailValidator.validate(value ?? '') ) return 'Email no válido';
                          return null;
                        },
                        style: TextStyle( color: Colors.blue ),
                        decoration: CustomInputs.loginInputDecoration(
                          hint: 'Ingrese su correo',
                          label: 'Email',
                          icon: Icons.email_outlined
                        ),
                      ),
        
                      SizedBox( height: 20 ),
        
                      // Password
                      TextFormField(
                        onChanged: ( value ) => registerFormProvider.password = value,
                        validator: ( value ) {
                          if ( value == null || value.isEmpty ) return 'Ingrese su contraseña';
                          if ( value.length < 6 ) return 'La contraseña debe de ser de 6 caracteres';
        
                          return null; // Válido
                        },
                        obscureText: isVisible,
                        style: TextStyle( color: Colors.blue ),
                        decoration: CustomInputs.loginInputDecoration(
                          hint: '*********',
                          label: 'Contraseña',
                          icon: Icons.lock_outline_rounded,
                           suffixIcon: IconButton(
                            icon: Icon(
                              isVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      
                      
                      SizedBox( height: 20 ),
                      CustomOutlinedButton(
                        onPressed: () {
        
                          final validForm = registerFormProvider.validateForm();
                          if ( !validForm ) return;
        
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          authProvider.register(
                            registerFormProvider.email, 
                            registerFormProvider.password, 
                            registerFormProvider.name
                          );
        
                        }, 
                        text: 'Crear cuenta',
                      ),
        
        
                      SizedBox( height: 20 ),
                      LinkText(
                        text: '¿Tienes cuenta? Ingresa.',
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, Flurorouter.loginRoute );
                        },
                      )
        
                    ],
                  )
                ),
              ),
            ),
          ),
        );

      }),
    );
  }
}