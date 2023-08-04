
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:universal_html/html.dart' as html;
import 'package:admin_dashboard/providers/categories_provider.dart';

import 'package:flutter/services.dart';


import 'package:provider/provider.dart';
import 'package:data_table_2/data_table_2.dart';

import '../../models/solares.dart';

Future<void> generateAndDownloadPdf(Solares solar,int meses) async {
  // Cálculos de cotización
  double valorxMetro = solar.caracteristicas == 'esquinero' ? 61.67 : 53.34;
  double metros = solar.ancho * solar.largo;
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
            pw.Text('Narboni Corporation dba',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Dirección de la empresa'),
            pw.Divider(thickness: 1),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Fecha:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('01/06/2023'),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Cliente:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('Nombre del cliente'),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Cotización', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20)),
            pw.SizedBox(height: 20),
            pw.Text('Descripción: ${solar.caracteristicas}'),
             pw.Text('Meses: ${meses}'),
            pw.Text('Ancho: ${solar.ancho} m'),
            pw.Text('Largo: ${solar.largo} m'),
            pw.SizedBox(height: 20),
            pw.Text('Cálculos de Cotización:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
            pw.Text('Valor por Metro: \$${valorxMetro.toStringAsFixed(2)}'),
            pw.Text('Metros: ${metros.toStringAsFixed(2)}'),
            pw.Text('Valor del Lote: \$${valorLote.toStringAsFixed(2)}'),
            pw.Text('Entrada: \$${entrada.toStringAsFixed(2)}'),
            pw.Text('Valor Mensual: \$${valorMensual.toStringAsFixed(2)}'),
            pw.Text('Total: \$${total.toStringAsFixed(2)}'),
            pw.SizedBox(height: 20),
            pw.Text('Tabla de Cotización:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
            pw.Table.fromTextArray(
              border: null,
              cellAlignment: pw.Alignment.centerLeft,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              rowDecoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide())),
              headers: ['Terreno', 'Valor'],
              data: [
                ['Entrada Terreno + Plan Ideal', '\$${entradaTerrenoPlanIdeal.toStringAsFixed(2)}'],
                ['Cuotas Terreno + Plan Ideal', '\$${cuotasTerrenoPlanIdeal.toStringAsFixed(2)}'],
                ['Mensual', '\$${valorMensual.toStringAsFixed(2)}'],
                ['Total Terreno + Plan Ideal', '\$${totalTerrenoPlanIdeal.toStringAsFixed(2)}'],
              ],
            ),
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
    ..download = 'cotización.pdf';

  html.document.body?.children.add(anchor);
  anchor.click();

  html.document.body?.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}

class TerrenosClientsView extends StatefulWidget {
  @override
  _TerrenosClientsViewState createState() => _TerrenosClientsViewState();
}

class _TerrenosClientsViewState extends State<TerrenosClientsView> {
   TextEditingController _descripcionController = TextEditingController();
  TextEditingController _estadoController = TextEditingController();

  @override 
  void initState() {
    super.initState();

    Provider.of<GeneralProvider>(context, listen: false).getSolares();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    final solares = Provider.of<GeneralProvider>(context).solares;
     List<Solares> filteredSolares = solares
        .where((solar) => solar.caracteristicas
            .toLowerCase()
            .contains(_descripcionController.text.toLowerCase()))
        .where((solar) => solar.estadoR
            .toLowerCase()
            .contains(_estadoController.text.toLowerCase()))
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
                columnSpacing: 20,
               
                horizontalMargin: 6,
                minWidth: 600,
                headingRowColor: MaterialStateColor.resolveWith((states) =>
                    Colors.blue), // Color de fondo de la fila de encabezado
                dataTextStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight
                        .bold), // Estilo de texto para las celdas de datos
                fixedCornerColor:
                    Colors.amber, // Color de fondo de la esquina fija
                headingTextStyle: TextStyle(
                    fontSize: 12,
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
                        label: Text('Lote'),
                 
                      ),
                       DataColumn2(
                        label: Text('Manzana'),
                 
                      ),
                       DataColumn2(
                        label: Text('Solar'),
                 
                      ),
                      DataColumn2(
                        label: Text('Tipo de lote'),
               
                      ),
                      DataColumn2(
                        label: Text('Largo(m)'),
                       
                      ),
                      DataColumn2(
                        label: Text('Ancho(m)'),
                   
                      ),
                       DataColumn2(
                        label: Text('Dimensión(m²)'),
                   
                      ),
                     /* DataColumn2(
                        label: Text('Precio'),
                             ),*/
                      DataColumn2(
                        label: Text('Estado'),
                     
                      ),
                      DataColumn2(
                        label: Text('Acciones'),
                       
                      ),
                    ],
                    rows: filteredSolares.map((solar) {
                      return DataRow2(
                        cells: [
                          DataCell(Text(solar.ubicacion)),
                          DataCell(Text(solar.etapa)),
                          DataCell(Text(solar.manzana)),
                          DataCell(Text(solar.solare)),
                         DataCell(Text(solar.caracteristicas[0].toUpperCase() + solar.caracteristicas.substring(1))),
    
                          DataCell(Text(solar.largo.toString())),
                          DataCell(Text(solar.ancho.toString())),
                                 DataCell(RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${solar.ancho * solar.largo}m',
                              
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
                          //DataCell(Text(solar.precio.toString())),
                            DataCell(Text(solar.estadoR[0].toUpperCase() + solar.estadoR.substring(1))),
    
                          DataCell(
                            Row(
                              children: [
                                 IconButton(
                                  icon: Icon(Icons.picture_as_pdf,size: 18,color: Colors.red,),
                                  onPressed: () async {
      final meses = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int? enteredMonths;
    
        return AlertDialog(
          title: Text('Ingrese el número de meses'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final parsedValue = int.tryParse(value);
              if (parsedValue != null && parsedValue > 0) {
                enteredMonths = parsedValue;
              } else {
                enteredMonths = null;
              }
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                if (enteredMonths != null) {
                  Navigator.of(context).pop(enteredMonths);
                }
              },
            ),
          ],
        );
      },
      );
    
      if (meses != null) {
      generateAndDownloadPdf(solar, meses);
      }
    },
    
                                ),
                              Center(
      child: IconButton(
      icon: Icon(Icons.shopping_cart, size: 25, color: Colors.orange),
      onPressed: () async {
       if (solar.estadoR != 'disponible') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Advertencia'),
            content: Text('El estado del solar no está disponible intente luego'),
            actions: [
              ElevatedButton(
                child: Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                },
              ),
            ],
          );
        },
      );
      return; // Finalizar la ejecución del onPressed
      }
        
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Generar Orden de Compra'),
              content: Text('¿Está seguro que desea generar la orden de compra?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cerrar'),
                ),
                TextButton(
                  onPressed: () async{
    
                    
                  final meses = await showDialog<int>(
                    context: context,
                    builder: (BuildContext context) {
                      int? enteredMonths;
    
                      return AlertDialog(
                        title: Text('Ingrese el número de meses'),
                        content: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final parsedValue = int.tryParse(value);
                            if (parsedValue != null && parsedValue > 0) {
                              enteredMonths = parsedValue;
                            } else {
                              enteredMonths = null;
                            }
                          },
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Aceptar'),
                            onPressed: () {
                              if (enteredMonths != null) {
                                Navigator.of(context).pop(enteredMonths);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
    
                  if (meses != null) {
                      double valorxMetro = solar.caracteristicas == 'esquinero' ? 61.67 : 53.34;
                      double metros = solar.ancho * solar.largo;
                      double valorLote = metros * valorxMetro;
                      double entrada = valorLote * (0.11 / 2);
                      await generalProvider.updateSolarEstado(solar.id,"en proceso");
                    await generalProvider.newOrden(entrada, solar.id,meses);
                    Navigator.of(context).pop();
                  }
                  },
                  child: Text('Generar'),
                ),
              ],
            );
          },
        );
      },
      ),
    ),
                             
                                
                              ],
                            ),
                            
                          ),
                        ],
                      );
                    }).toList(),
                  ),
            ),
            SizedBox(height: 10,),
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
                              controller: _estadoController,
                              onChanged: (value) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                labelText: 'Estado',
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



 

}


