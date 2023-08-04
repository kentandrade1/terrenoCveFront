import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/providers/login_form_provider.dart';

import 'package:flutter/material.dart';

import 'package:admin_dashboard/router/router.dart';

import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';
import 'package:admin_dashboard/ui/buttons/link_text.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => LoginFormProvider(),
      child: Builder(builder: (context) {
        final loginFormProvider =
            Provider.of<LoginFormProvider>(context, listen: false);

        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 40),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 370),
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: loginFormProvider.formKey,
                  child: Column(
                    children: [
                      // Email
                      TextFormField(
                        onFieldSubmitted: (_) =>
                            onFormSubmit(loginFormProvider, authProvider),
                        onChanged: (value) => loginFormProvider.email = value,
                        style: TextStyle(color: Colors.black),
                        decoration: CustomInputs.loginInputDecoration(
                          hint: 'Ingrese su correo',
                          //label: 'Correo',
                          icon: Icons.email_outlined,
                        ),
                      ),

                      SizedBox(height: 20),

                      // Password
                      TextFormField(
                        onFieldSubmitted: (_) =>
                            onFormSubmit(loginFormProvider, authProvider),
                        onChanged: (value) =>
                            loginFormProvider.password = value,
                        obscureText: isVisible,
                        style: TextStyle(color: Colors.black),
                        decoration: CustomInputs.loginInputDecoration(
                          hint: '*********',
                          //label: 'Contraseña',
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
                        onPressed: () =>
                            onFormSubmit(loginFormProvider, authProvider),
                        text: 'Ingresar',
                      ),

                      SizedBox(height: 20),
                      LinkText(
                        text: '¿Perdiste tu contraseña?.',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, Flurorouter.ressetPasswordEmailView);
                        },
                      ),
                      LinkText(
                        text: '¿No tienes cuenta?Registrate.',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, Flurorouter.registerRoute);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void onFormSubmit(
      LoginFormProvider loginFormProvider, AuthProvider authProvider) {
    final isValid = loginFormProvider.validateForm();
    if (isValid) authProvider.login(loginFormProvider.email, loginFormProvider.password);
  }
}
