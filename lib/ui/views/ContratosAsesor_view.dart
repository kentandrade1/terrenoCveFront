import 'dart:convert';
import 'dart:typed_data';
import 'package:admin_dashboard/models/orden.dart';
import 'package:admin_dashboard/models/reserva.dart';
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

import '../../providers/auth_provider.dart';
import '../../providers/users_provider.dart';

Future<void> generateAndDownloadPdf(Reserva reserva, int meses) async {
  // Cálculos de cotización

  double valorxMetro =
      reserva.solar.caracteristicas == 'esquinero' ? 61.67 : 53.34;
  double metros = reserva.solar.ancho * reserva.solar.largo;
  double valorLote = metros * valorxMetro;
  double entrada = valorLote * (0.11 / 2);
  double valorMensual = (valorLote - entrada) / meses;
  double total = valorMensual * meses + entrada;
  double entradaTerrenoPlanIdeal = entrada + 30;
  double cuotasTerrenoPlanIdeal = valorMensual + 30;
  double totalTerrenoPlanIdeal = total + 390;
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Contrato de Compra de Terreno',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Divider(thickness: 1),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Fecha:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('01/06/2023'),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Vendedor:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Narboni Corporation dba-${reserva.asesor.nombre}'),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Comprador:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('${reserva.usuario.nombre}'),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('Descripción del Terreno:',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
            pw.Text('Características: ${reserva.solar.caracteristicas}'),
            pw.Text('Ancho: ${reserva.solar.ancho} m'),
            pw.Text('Largo: ${reserva.solar.largo} m'),
            pw.SizedBox(height: 20),
            pw.Text('Condiciones de Pago:',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
            pw.Text('Valor del Terreno: \$${valorLote.toStringAsFixed(2)}'),
            pw.Text('Entrada: \$${entrada.toStringAsFixed(2)}'),
            pw.Text('Valor Mensual: \$${valorMensual.toStringAsFixed(2)}'),
            pw.SizedBox(height: 20),
            pw.Text('Acuerdo de Compra:',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
            pw.Text(
                '1. El Comprador se compromete a pagar el valor del terreno según las condiciones acordadas.'),
            pw.Text(
                '2. El Vendedor se compromete a entregar el terreno en las condiciones establecidas.'),
            pw.Text(
                '3. Ambas partes acuerdan cumplir con los plazos y condiciones especificadas en este contrato.'),
            pw.SizedBox(height: 20),
            pw.Text('Firmas:',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Vendedor:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Comprador:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.SizedBox(height: 50), // Espacio para la firma del comprador
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('${reserva.asesor.nombre}'),
                pw.Text('${reserva.usuario.nombre}'),
              ],
            ),
          ],
        );
      },
    ),
  );

  final Uint8List bytes = await pdf.save();

  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = 'Contrato_${reserva.usuario.nombre}.pdf';

  html.document.body?.children.add(anchor);
  anchor.click();

  html.document.body?.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}

Future<void> generateAndDownloadPdfPorNombre(
    Reserva reserva, int meses, String nombre) async {
  // Cálculos de cotización

  double valorxMetro =
      reserva.solar.caracteristicas == 'esquinero' ? 61.67 : 53.34;
  double metros = reserva.solar.ancho * reserva.solar.largo;
  double valorLote = metros * valorxMetro;
  double entrada = valorLote * (0.11 / 2);
  double valorMensual = (valorLote - entrada) / meses;
  double total = valorMensual * meses + entrada;
  double entradaTerrenoPlanIdeal = entrada + 30;
  double cuotasTerrenoPlanIdeal = valorMensual + 30;
  double totalTerrenoPlanIdeal = total + 390;
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Contrato de Compra de Terreno',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Divider(thickness: 1),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Fecha:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('01/06/2023'),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Vendedor:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Narboni Corporation dba-${reserva.asesor.nombre}'),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Comprador:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('${nombre}'),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text('Descripción del Terreno:',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
            pw.Text('Características: ${reserva.solar.caracteristicas}'),
            pw.Text('Ancho: ${reserva.solar.ancho} m'),
            pw.Text('Largo: ${reserva.solar.largo} m'),
            pw.SizedBox(height: 20),
            pw.Text('Condiciones de Pago:',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
            pw.Text('Valor del Terreno: \$${valorLote.toStringAsFixed(2)}'),
            pw.Text('Entrada: \$${entrada.toStringAsFixed(2)}'),
            pw.Text('Valor Mensual: \$${valorMensual.toStringAsFixed(2)}'),
            pw.SizedBox(height: 20),
            pw.Text('Acuerdo de Compra:',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
            pw.Text(
                '1. El Comprador se compromete a pagar el valor del terreno según las condiciones acordadas.'),
            pw.Text(
                '2. El Vendedor se compromete a entregar el terreno en las condiciones establecidas.'),
            pw.Text(
                '3. Ambas partes acuerdan cumplir con los plazos y condiciones especificadas en este contrato.'),
            pw.SizedBox(height: 20),
            pw.Text('Firmas:',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Vendedor:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Comprador:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.SizedBox(height: 50), // Espacio para la firma del comprador
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('${reserva.asesor.nombre}'),
                pw.Text('${nombre}'),
              ],
            ),
          ],
        );
      },
    ),
  );

  final Uint8List bytes = await pdf.save();

  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = 'Contrato_${reserva.usuario.nombre}.pdf';

  html.document.body?.children.add(anchor);
  anchor.click();

  html.document.body?.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}

class ContratoAsesorView extends StatefulWidget {
  @override
  _ContratoAsesorViewState createState() => _ContratoAsesorViewState();
}

class _ContratoAsesorViewState extends State<ContratoAsesorView> {
  bool _isFirstBuild = true;
  TextEditingController _descripcionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _ubicacionController = TextEditingController();
  TextEditingController _clienteController = TextEditingController();
   final _nombreController = TextEditingController();
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
                    label: Text('Ubicación'),
                  ),
                  DataColumn2(
                    label: Text('Tipo lote'),
                  ),
                  DataColumn2(
                    label: Text('Dimensión(m²)'),
                  ),
                  DataColumn2(
                    label: Text('Meses'),
                  ),
                  DataColumn2(
                    label: Text('Cliente:'),
                  ),
                  DataColumn2(
                    label: Text('Asesor:'),
                  ),
                  DataColumn2(
                    label: Text('Contrato:'),
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
                      DataCell(
                        Tooltip(
                          message: reserva.solar.caracteristicas,
                          child: Text(
                            reserva.solar.caracteristicas.length > 10
                                ? '${reserva.solar.caracteristicas.substring(0, 10)}...'
                                : reserva.solar.caracteristicas,
                          ),
                        ),
                      ),
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
                            reserva.asesor.nombre.length > 10
                                ? '${reserva.asesor.nombre.substring(0, 10)}...'
                                : reserva.asesor.nombre,
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.picture_as_pdf,
                                size: 18,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                generateAndDownloadPdf(reserva, reserva.meses);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.picture_as_pdf,
                                size: 18,
                                color: Colors.green,
                              ),
                              onPressed: () async {
                                
                                showDialog(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return AlertDialog(
                                            title: Text('Propietario del Terreno'),
                                            content: SingleChildScrollView(
                                              child: Form(
                                                key: _formKey,
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      controller:
                                                          _nombreController,
                                                      decoration: InputDecoration(
                                                          labelText: 'Nombre'),
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Por favor, ingrese el nombre';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                    
                                                  ],
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Cancelar")),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    final nombre =
                                                        _nombreController.text;
                                                         generateAndDownloadPdfPorNombre(
                                    reserva, reserva.meses, nombre);
                                                    Navigator.pop(
                                                        context); // Cerrar el diálogo
                                                  }
                                                },
                                                child: Text('Guardar'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    });
                             
                              },
                            ),
                          ],
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
