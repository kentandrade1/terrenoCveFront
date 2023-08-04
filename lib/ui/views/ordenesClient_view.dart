
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

import '../../providers/auth_provider.dart';



Future<void> generateAndDownloadPdf(Orden order) async {

  final pdf = pw.Document();

   pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
         final double dimension = order.solar.ancho * order.solar.largo;
        return pw.Container(
          padding: pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Orden de Pago',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Número de Orden: ${order.id}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Fecha de emisión de orden: ${order.fechaIngreso}'),
              pw.SizedBox(height: 20),
              pw.Text('Cliente: ${order.usuario.nombre}'),

              pw.SizedBox(height: 20),
              pw.Text('Detalles del Pago:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Concepto: Entrada de solar :${order.solar.ubicacion}'),
              pw.SizedBox(height: 10),
              pw.Text('Monto de entrada : \$${order.entrada.toStringAsFixed(2)}'),
                            pw.SizedBox(height: 10),
              pw.Text('Caracteristica del solar: ${order.solar.caracteristicas}'),
              pw.SizedBox(height: 10),
              pw.Text('Dimensión del solar: ${order.solar.ancho} m x ${order.solar.largo} m = ${dimension.toStringAsFixed(2)} m²'),
              pw.SizedBox(height: 20),
              pw.Text('Fecha de Expiración: ${order.fechaIngreso.add(Duration(hours: 12))}'),
            ],
          ),
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
    ..download = 'Orden de pago(${order.usuario.nombre}).pdf';

  html.document.body?.children.add(anchor);
  anchor.click();

  html.document.body?.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}


class OrdenesClientsView extends StatefulWidget {
  @override
  _OrdenesClientsViewState createState() => _OrdenesClientsViewState();
}

class _OrdenesClientsViewState extends State<OrdenesClientsView> {
    bool _isFirstBuild = true;
    TextEditingController _descripcionController = TextEditingController();
  TextEditingController _ubicacionController = TextEditingController();
  TextEditingController _codigoController = TextEditingController();

@override
void didChangeDependencies() {
  super.didChangeDependencies();

    if (_isFirstBuild) {
  final user = Provider.of<AuthProvider>(context).user!;
  Provider.of<GeneralProvider>(context, listen: false).getOrdenes(user.uid,user.rol);
    _isFirstBuild = false;
  }

}

 Future<void> _uploadImage(GeneralProvider generalProvider,Orden orden) async {
    final imageFile = await pickImageFromLibrary();

    if (imageFile != null) {
      // Llama a la función uploadToCloudinary con el archivo de imagen
      try {
        String newImageUrl = await uploadToCloudinary(imageFile);
        generalProvider.updateOrdenFoto(orden.id,newImageUrl);

      } catch (error) {
        print('Error al subir la foto: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final generalProvider = Provider.of<GeneralProvider>(context, listen: false);

    final ordenes = Provider.of<GeneralProvider>(context).orden;
    List<Orden> filteredOrdenes = ordenes
        .where((orden) => orden.solar.caracteristicas
            .toLowerCase()
            .contains(_descripcionController.text.toLowerCase()))
        .where((orden) => orden.solar.ubicacion
            .toLowerCase()
            .contains(_ubicacionController.text.toLowerCase()))
            .where((orden) => orden.id
            .toLowerCase()
            .contains(_codigoController.text.toLowerCase()))
        .toList();
    return Card(
      elevation: 10,
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            
                   
            SizedBox(height: 10,),
            Expanded(
              child: DataTable2(
                columnSpacing: 0,
                horizontalMargin: 6,
                minWidth: 600,
                headingRowColor: MaterialStateColor.resolveWith((states) =>
                    Colors.blue), // Color de fondo de la fila de encabezado
                dataTextStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight
                        .bold), // Estilo de texto para las celdas de datos
                fixedCornerColor:
                    Colors.amber, // Color de fondo de la esquina fija
                headingTextStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight
                        .bold), // Estilo de texto para las celdas de encabezado
                bottomMargin: 20.0, // Margen inferior de la tabla
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black,
                      width: 1.0), // Agrega un borde negro de ancho 1.0
                  borderRadius: BorderRadius.circular(
                      0.0), // Agrega bordes redondeados a la tabla
                ),
                    columns: [
                      DataColumn2(
                        label: Text('Proyecto'),
                 
                      ),
                       DataColumn2(
                        label: Text('Etapa'),
                 
                      ),
                       DataColumn2(
                        label: Text('Manzana'),
                 
                      ),
                       DataColumn2(
                        label: Text('Solar'),
                 
                      ),
                      DataColumn2(
                        label: Text('Descripción'),
               
                      ),
                      DataColumn2(
                        label: Text('Dimensión(m²)'),
                       
                      ),
                      DataColumn2(
                        label: Text('Entrada'),
                   
                      ),
                       DataColumn2(
                        label: Text('Codigo'),
                   
                      ),
                      
                     /* DataColumn2(
                        label: Text('Precio'),
                             ),*/
                      DataColumn2(
                        label: Text('Generar'),
                     
                      ),
                      DataColumn2(
                        label: Text('Subir'),
                       
                      ),
                    ],
                    rows: filteredOrdenes.map((orden) {
                      return DataRow2(
                        cells: [
                       DataCell(
                        Tooltip(
                          message: orden.solar.ubicacion,
                          child: Text(
                            orden.solar.ubicacion.length > 10
                                ? '${orden.solar.ubicacion.substring(0, 10)}...'
                                : orden.solar.ubicacion,
                          ),
                        ),
                      ),
                       DataCell(
                        Tooltip(
                          message: orden.solar.etapa,
                          child: Text(
                            orden.solar.etapa.length > 10
                                ? '${orden.solar.etapa.substring(0, 10)}...'
                                : orden.solar.etapa,
                          ),
                        ),
                      ),
                       DataCell(
                        Tooltip(
                          message: orden.solar.manzana,
                          child: Text(
                            orden.solar.manzana.length > 10
                                ? '${orden.solar.manzana.substring(0, 10)}...'
                                : orden.solar.manzana,
                          ),
                        ),
                      ),
                       DataCell(
                        Tooltip(
                          message: orden.solar.solare,
                          child: Text(
                            orden.solar.solare.length > 10
                                ? '${orden.solar.solare.substring(0, 10)}...'
                                : orden.solar.solare,
                          ),
                        ),
                      ),
                      DataCell(
                        Tooltip(
                          message: orden.solar.caracteristicas,
                          child: Text(
                            orden.solar.caracteristicas.length > 10
                                ? '${orden.solar.caracteristicas.substring(0, 10)}...'
                                : orden.solar.caracteristicas,
                          ),
                        ),
                      ),
                      DataCell(RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${orden.solar.ancho * orden.solar.largo}m',
                              style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
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
                          message: orden.entrada.toStringAsFixed(2),
                          child: Text(orden.entrada.toStringAsFixed(2)),
                        ),
                      ),
                      DataCell(
                        Tooltip(
                          message: orden.id,
                          child: Text(
                            orden.id.length > 10 ? '${orden.id.substring(0, 10)}...' : orden.id,
                          ),
                        ),
                      ),
                      DataCell(
                        Tooltip(
                          message: "Generar Orden de pago",
                          child:IconButton(
                                  icon: Icon(Icons.picture_as_pdf,size: 18,color: Colors.red,),
                                  onPressed: () async {
    
                                      generateAndDownloadPdf(orden);
                      
                                  },
    
                                ),
                        ),
                      ),
                    DataCell(
                      Tooltip(
                        message: (orden.imgPago == "")
                          ? "Subir pago"
                          : "Pago subido",
                        child: Row(
                          children: [
                            IconButton(
                              icon: (orden.imgPago == "")
                                ? Icon(Icons.upload_file_outlined, size: 18, color: Colors.green)
                                : Icon(Icons.check_circle, size: 18, color: Colors.blue),
                              onPressed: () async {
                                  _uploadImage(generalProvider,orden);
                              },
                            ),
                            if (orden.imgPago != "") // Agregar esta condición para mostrar el SizedBox
                              SizedBox(width: 8), // Espacio entre los dos íconos
                            if (orden.imgPago != "") // Agregar esta condición para mostrar el segundo IconButton
                              IconButton(
                                icon: Icon(Icons.image_outlined, size: 18, color: Colors.black),
                                onPressed: () async {
                                  
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: CachedNetworkImage(
                                            imageUrl: orden.imgPago,
                                            fit: BoxFit.contain,
                                          ),
                                        );
                                      },
                                    );
                                },
                              ),
                          ],
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
                              controller: _codigoController,
                              onChanged: (value) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                labelText: 'Código',
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
const uploadPreset = 'lwa56ryv'; // Replace 'tu_upload_preset' with your own Cloudinary upload preset

Future<String> uploadToCloudinary(html.File imageFile) async {
  final reader = html.FileReader();
  reader.readAsArrayBuffer(imageFile);
  await reader.onLoad.first; // Wait for the reader to load the file

  final buffer = reader.result as Uint8List;
  final length = buffer.lengthInBytes;

  final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
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
