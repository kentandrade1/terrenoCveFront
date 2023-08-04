import 'dart:convert';
import 'dart:typed_data';
import 'package:admin_dashboard/models/orden.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;
import 'package:admin_dashboard/providers/categories_provider.dart';

import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:data_table_2/data_table_2.dart';

import '../../models/reserva.dart';
import '../../providers/auth_provider.dart';
import '../../providers/users_provider.dart';
import '../buttons/custom_outlined_button.dart';

class ReservasAsesorView extends StatefulWidget {
  @override
  _ReservasAsesorViewState createState() => _ReservasAsesorViewState();
}

class _ReservasAsesorViewState extends State<ReservasAsesorView> {
  bool _isFirstBuild = true;
  TextEditingController _descripcionController = TextEditingController();
  TextEditingController _ubicacionController = TextEditingController();
  TextEditingController _clienteController = TextEditingController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isFirstBuild) {
      final user = Provider.of<AuthProvider>(context).user!;
      Provider.of<GeneralProvider>(context, listen: false).getSolares();
      Provider.of<GeneralProvider>(context, listen: false)
          .getReservas(user.uid, user.rol);
      _isFirstBuild = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final generalProvider =
        Provider.of<GeneralProvider>(context, listen: false);
    final usersProvider = Provider.of<UsersProvider>(context);
    final solares = Provider.of<GeneralProvider>(context).solares;
    final reservas = Provider.of<GeneralProvider>(context).reservas;
    List<Reserva> filteredReservas = reservas
        .where((reserva) => reserva.solar.caracteristicas
            .toLowerCase()
            .contains(_descripcionController.text.toLowerCase()))
        .where((orden) => orden.solar.ubicacion
            .toLowerCase()
            .contains(_ubicacionController.text.toLowerCase()))
        .where((orden) => orden.usuario.nombre
            .toLowerCase()
            .contains(_clienteController.text.toLowerCase()))
        .toList();
    return Card(
      elevation: 10,
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
           
            //empiez elevated
            CustomOutlinedButton(
              onPressed: () {
                String? selectedUserId;
                String? selectedSolarId;
                String? selectedUserAsesorId;
                int? selectedMonths; // Nuevo campo
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Reservar'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButtonFormField<String>(
                            value: selectedUserId,
                            items: usersProvider.users
                                .where((user) => user.rol == 'CLIENTE_ROLE')
                                .map((user) => DropdownMenuItem<String>(
                                      value: user.uid,
                                      child: Text(user.nombre),
                                    ))
                                .toList(),
                            hint: Text('Seleccionar usuario'),
                            onChanged: (value) {
                              selectedUserId = value;
                            },
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedUserAsesorId,
                            items: usersProvider.users
                                .where((user) => user.rol == 'ASESOR_ROLE')
                                .map((user) => DropdownMenuItem<String>(
                                      value: user.uid,
                                      child: Text(user.nombre),
                                    ))
                                .toList(),
                            hint: Text('Seleccionar usuario'),
                            onChanged: (value) {
                              selectedUserAsesorId = value;
                            },
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedSolarId,
                            items: solares
                                .where((solar) => solar.estadoR == 'disponible')
                                .map((solar) => DropdownMenuItem<String>(
                                      value: solar.id,
                                      child: Text(solar.ubicacion),
                                    ))
                                .toList(),
                            hint: Text('Seleccionar ubicación de solar'),
                            onChanged: (value) {
                              selectedSolarId = value;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Meses',
                            ),
                            onChanged: (value) {
                              selectedMonths = int.tryParse(value);
                            },
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () async {
                            if (selectedUserId != null &&
                                selectedSolarId != null &&
                                selectedMonths != null &&
                                selectedUserAsesorId != null) {
                              await generalProvider.updateSolarEstado(
                                  selectedSolarId!, "reservado");
                              await generalProvider.newReserva(
                                  selectedSolarId!,
                                  selectedUserId!,
                                  selectedMonths!,
                                  selectedUserAsesorId!);
                              Navigator.of(context).pop();
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content: Text(
                                        'Por favor, seleccione un usuario y una ubicación de solar.'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cerrar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Text('Reservar'),
                        ),
                      ],
                    );
                  },
                );
              },
             text:"Reservar"
            ),
    
            //termina elevated
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: DataTable2(
                columnSpacing: 20,
                horizontalMargin: 12,
                minWidth: 600,
                headingRowColor: MaterialStateColor.resolveWith((states) =>
                    Colors.blue), // Color de fondo de la fila de encabezado
                dataTextStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight
                        .bold), // Estilo de texto para las celdas de datos
                fixedCornerColor:
                    Colors.grey, // Color de fondo de la esquina fija
                headingTextStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight
                        .bold), // Estilo de texto para las celdas de encabezado
                bottomMargin: 20.0, // Margen inferior de la tabla
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black,
                      width: 1.0), // Agrega un borde negro de ancho 1.0
                  borderRadius: BorderRadius.circular(
                      5.0), // Agrega bordes redondeados a la tabla
                ),
                columns: [
                  DataColumn2(
                    label: Text('Proyecto'),
                  ),
                  DataColumn2(
                    label: Text('Tipo Lote'),
                  ),
                  DataColumn2(
                    label: Text('Dimensión(m²)'),
                  ),
                  DataColumn2(
                    label: Text('Meses'),
                  ),
                  DataColumn2(
                    label: Text('Reservado por:'),
                  ),
                  DataColumn2(
                    label: Text('Asesor:'),
                  ),
                ],
                rows: filteredReservas.map((reserva) {
                  return DataRow2(
                    cells: [
                      DataCell(
                        Tooltip(
                          message: reserva.solar.ubicacion,
                          child: Text(
                            reserva.solar.ubicacion.length > 10
                                ? '${reserva.solar.ubicacion.substring(0, 10)}...'
                                : reserva.solar.ubicacion,
                          ),
                        ),
                      ),
                       DataCell(Text(reserva.solar.caracteristicas[0].toUpperCase() + reserva.solar.caracteristicas.substring(1))),
                      DataCell(RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${reserva.solar.ancho * reserva.solar.largo}m',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            WidgetSpan(
                              child: Transform.translate(
                                offset: const Offset(0,
                                    -8), // Ajusta el desplazamiento según tus necesidades
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                    fontSize:
                                        12, // Ajusta el tamaño según tus necesidades
                                    fontWeight: FontWeight.bold,
                                    // Añade cualquier otro estilo deseado
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                      DataCell(
                        Tooltip(
                          message: '${reserva.meses}',
                          child: Text(
                            '${reserva.meses}',
                          ),
                        ),
                      ),
                      DataCell(
                        Tooltip(
                          message: reserva.usuario.nombre,
                          child: Text(
                            reserva.usuario.nombre.length > 10
                                ? '${reserva.usuario.nombre.substring(0, 10)}...'
                                : reserva.usuario.nombre,
                          ),
                        ),
                      ),
                      DataCell(
                        Tooltip(
                          message: reserva.asesor.nombre,
                          child: Text(
                            reserva.usuario.nombre.length > 10
                                ? '${reserva.asesor.nombre.substring(0, 10)}...'
                                : reserva.asesor.nombre,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _clienteController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Cliente',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _descripcionController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _ubicacionController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Ubicación',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<html.File?> pickImageFromLibrary() async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    await input.onChange.first;

    if (input.files!.isNotEmpty) {
      return input.files![0];
    }

    return null;
  }
}

const cloudName = 'darqvpjtk';
const apiKey = '434675434518466';
const apiSecret = 'OgXh4l0qh_7mriMCxu2b0FP0vQU';
const uploadPreset =
    'lwa56ryv'; // Replace 'tu_upload_preset' with your own Cloudinary upload preset

Future<String> uploadToCloudinary(html.File imageFile) async {
  final reader = html.FileReader();
  reader.readAsArrayBuffer(imageFile);
  await reader.onLoad.first; // Wait for the reader to load the file

  final buffer = reader.result as Uint8List;
  final length = buffer.lengthInBytes;

  final uri =
      Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
  final request = http.MultipartRequest('POST', uri);

  final multipartFile = http.MultipartFile.fromBytes(
    'file',
    buffer,
    filename: imageFile.name,
  );

  request.fields['upload_preset'] = uploadPreset;
  request.files.add(multipartFile);

  final response = await request.send();
  final responseBody = await response.stream.bytesToString();
  print(responseBody);

  if (response.statusCode == 200) {
    // Parse the JSON response
    final jsonData = jsonDecode(responseBody);
    final imageUrl = jsonData['secure_url'];

    return imageUrl;
  } else {
    throw Exception('Error uploading photo to Cloudinary');
  }
}
