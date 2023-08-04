
// ignore: unused_import
import 'dart:convert';
// ignore: unnecessary_import
import 'dart:typed_data';

import 'package:admin_dashboard/models/reserva.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

import 'package:universal_html/html.dart' as html;
import 'package:admin_dashboard/providers/categories_provider.dart';

import 'package:flutter/services.dart';


import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/solares.dart';
import '../../providers/auth_provider.dart';

import '../buttons/custom_outlined_button.dart';


void generateAndDownloadPdf(List<Solares> solares, List<Reserva> reservas) async {
  final pdf = pw.Document();

  // Calcular los totales
  int totalSolares = solares.length;
  int solaresDisponibles = solares.where((solar) => solar.estadoR == "disponible").length;
  int solaresEnProceso = solares.where((solar) => solar.estadoR == "en proceso").length;
  int solaresReservados = solares.where((solar) => solar.estadoR == "reservado").length;
  double acutotal=0;
  double acutotalSolaresE=0;
  double acutotalReservados=0;
  // Calcular el total de ganancias de todas las reservas
  double totalGanancias = 0;
  for (var reserva in reservas) {
    double valorxMetro = reserva.solar.caracteristicas == 'esquinero' ? 61.67 : 53.34;
    double metros = reserva.solar.ancho * reserva.solar.largo;
    double valorLote = metros * valorxMetro;
    double entrada = valorLote * (0.11 / 2);
    int meses = reserva.meses; // Supongo que el plazo está en meses
    double valorMensual = (valorLote - entrada) / meses;
    double total = valorMensual * meses + entrada;
    // ignore: unused_local_variable
    double entradaTerrenoPlanIdeal = entrada + 30;
    // ignore: unused_local_variable
    double cuotasTerrenoPlanIdeal = valorMensual + 30;
    double totalTerrenoPlanIdeal = total + 390;
    totalGanancias += totalTerrenoPlanIdeal;
  }

  // Crear la tabla de solares
  final solaresTable = pw.Table(
    border: pw.TableBorder.all(),
    children: [
      pw.TableRow(
        children: [
          pw.Text('Descripción',style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.bold)),
          pw.Text('Alto',style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.bold)),
          pw.Text('Ancho',style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.bold)),
          pw.Text('Entrada Estimada',style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.bold)),
          
        ],
      ),
      ...solares.map((solar) {
        double valorxMetro = solar.caracteristicas == 'esquinero' ? 61.67 : 53.34;
        double metros = solar.ancho * solar.largo;
        double valorLote = metros * valorxMetro;
        double entrada = valorLote * (0.11 / 2);
         acutotalSolaresE=entrada+acutotalSolaresE;
         if(solar.estadoR=="reservado")
         acutotalReservados=acutotalReservados+entrada;
        return pw.TableRow(
          children: [
            pw.Text(solar.caracteristicas),
            pw.Text(solar.largo.toString()),
            pw.Text(solar.ancho.toString()),
            pw.Text(entrada.toStringAsFixed(2)),

          ],
        );
      }),
      pw.TableRow(
          children: [

            pw.Text("Total estimado:",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold)),
            pw.Text(""),
            pw.Text(""),
            pw.Text(acutotalSolaresE.toStringAsFixed(2)),

          ],
        ),
          pw.TableRow(
          children: [

            pw.Text("Total reservados:",style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.bold)),
            pw.Text(""),
            pw.Text(""),
            pw.Text(acutotalReservados.toStringAsFixed(2)),

          ],
        ),
    ],
  );

  // Crear la tabla de reservas
  final reservasTable = pw.Table(
    border: pw.TableBorder.all(),
    children: [
      pw.TableRow(
        children: [
          pw.Text('Entrada',style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.bold)),
          pw.Text('Dueño',style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.bold)),
        ],
      ),
      ...reservas.map((reserva) {
        double valorxMetro = reserva.solar.caracteristicas == 'esquinero' ? 61.67 : 53.34;
        double metros = reserva.solar.ancho * reserva.solar.largo;
        double valorLote = metros * valorxMetro;
        double entrada = valorLote * (0.11 / 2);
        return pw.TableRow(
          children: [
            pw.Text(entrada.toStringAsFixed(2)),
            pw.Text(reserva.usuario.nombre),
          ],
        );
      }),
      pw.TableRow(
        children: [
          pw.Text('Total',style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.bold)),
          pw.Text(reservas.fold(0.0, (sum, reserva) {
            double valorxMetro = reserva.solar.caracteristicas == 'esquinero' ? 61.67 : 53.34;
            double metros = reserva.solar.ancho * reserva.solar.largo;
            double valorLote = metros * valorxMetro;
            double entrada = valorLote * (0.11 / 2);
           acutotal=acutotal+entrada;
            return acutotal;
          }).toStringAsFixed(2)),
        ],
      ),
    ],
  );

  // Crear la tabla de totales
  final totalesTable = pw.Table(
    border: pw.TableBorder.all(),
    children: [
      pw.TableRow(
        children: [
          pw.Text('Total de Solares',style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.bold)),
          pw.Text('Solares Disponibles',style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.bold)),
          pw.Text('Solares en Proceso',style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.bold)),
          pw.Text('Solares Reservados',style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.bold)),
          pw.Text('Total de Ganancias',style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.bold)),
        ],
      ),
      pw.TableRow(
        children: [
          pw.Text(totalSolares.toString()),
          pw.Text(solaresDisponibles.toString()),
          pw.Text(solaresEnProceso.toString()),
          pw.Text(solaresReservados.toString()),
          pw.Text(totalGanancias.toStringAsFixed(2)),
        ],
      ),
    ],
  );

  // Agregar las tablas al documento PDF
  pdf.addPage(
    pw.MultiPage(
      header: (pw.Context context) {
        return pw.Text('Informe de Solares y Reservas', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold));
      },
      footer: (pw.Context context) {
        return pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text('Página ${context.pageNumber} de ${context.pagesCount}', style: pw.TextStyle(fontSize: 12)),
        );
      },
      build: (pw.Context context) {
        return [
          pw.Text('Tabla de Solares', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          solaresTable,
          pw.SizedBox(height: 20),
          pw.Text('Tabla de Reservas', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          reservasTable,
          pw.SizedBox(height: 20),
          pw.Text('Tabla General', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          totalesTable,
        ];
      },
    ),
  );

 

  final Uint8List bytes = await pdf.save();

  // Descargar el archivo PDF
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = 'Informe.pdf';

  html.document.body?.children.add(anchor);
  anchor.click();

  html.document.body?.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}
 
class ReportesAsesorView extends StatefulWidget {
  @override
  _ReportesAsesorViewState createState() => _ReportesAsesorViewState();
}

class _ReportesAsesorViewState extends State<ReportesAsesorView> {
  bool _isFirstBuild = true;
   TextEditingController _fechaController = TextEditingController();
   TextEditingController _fechaController2 = TextEditingController();
  List<DataColumn> _reservasColumns = [
    DataColumn(label: Text('Proyecto')),
    DataColumn(label: Text('Descripción')),
    DataColumn(label: Text('Dimensión')),
    DataColumn(label: Text('Meses')),
    DataColumn(label: Text('Cliente')),
    DataColumn(label: Text('Asesor')),
    DataColumn(label: Text('Fecha')),
  ];

  List<DataColumn> _solaresColumns = [
    DataColumn(label: Text('Proyecto')),
    DataColumn(label: Text('Descripción')),
    DataColumn(label: Text('Dimensión')),
  ];

  List<DataRow> _reservasRows = [];
  List<DataRow> _solaresRows = [];

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
Future<void> _selectDate(BuildContext context) async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime(2030),
  );

  if (picked != null) {
    _fechaController.text = picked.toLocal().toString().split(' ')[0];
    
    setState(() {
      
    });
    
  }
}
Future<void> _selectDate2(BuildContext context) async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime(2030),
  );

  if (picked != null) {
    _fechaController2.text = picked.toLocal().toString().split(' ')[0];

    setState(() {
      
    });
    
  }
}

  @override
  Widget build(BuildContext context) {
    final reservas1 = Provider.of<GeneralProvider>(context).reservas;
    final solares = Provider.of<GeneralProvider>(context).solares;
     List<Reserva>reservas =[];
if (_fechaController.text != "" && _fechaController2.text != "") {
  DateTime fechaInicio = DateTime.parse(_fechaController.text);
  DateTime fechaFin = DateTime.parse(_fechaController2.text).add(Duration(days: 1));

  reservas = reservas1.where((reserva) {
    DateTime fechaReserva = reserva.fechaIngreso.toLocal();
    return fechaReserva.isAfter(fechaInicio) && fechaReserva.isBefore(fechaFin);
  }).toList();
} else {
  reservas = reservas1;
}




    // Realizar cálculos y recopilar estadísticas
    int reservasPendientes = 0;
    int reservasAprobadas = 0;
    int reservasDisponibles = 0;

    solares.forEach((reserva) {
      if (reserva.estadoR == 'en proceso') {
        reservasPendientes++;
      } else if (reserva.estadoR == 'reservado') {
        reservasAprobadas++;
      } else if (reserva.estadoR == 'disponible') {
        reservasDisponibles++;
      }
    });
    

    _reservasRows = reservas.map((reserva) {

      DateTime fecha = reserva.fechaIngreso;
      return DataRow(
        cells: [
          
          DataCell(Text(reserva.solar.ubicacion)),
          DataCell(Text(reserva.solar.caracteristicas[0].toUpperCase() + reserva.solar.caracteristicas.substring(1))),
         DataCell(RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${reserva.solar.ancho * reserva.solar.largo}m',
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
          DataCell(Text('${reserva.meses}')),
          DataCell(Text(reserva.usuario.nombre)),
          DataCell(Text(reserva.asesor.nombre)),
          
          DataCell(
        Text(
          DateFormat('dd/MM/yyyy').format(fecha),
          // Estilo de texto opcional para el DataCell
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
        ],
      );
    }).toList();

    _solaresRows = solares.map((solar) {
      return DataRow(
        cells: [
          DataCell(Text(solar.ubicacion)),
          DataCell(Text(solar.caracteristicas[0].toUpperCase() + solar.caracteristicas.substring(1))),
          DataCell(Text(
              '${(solar.ancho * solar.largo).toStringAsFixed(2)}')),
        ],
      );
    }).toList();

    return Card(
      elevation: 10,
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Card(
            elevation: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 SizedBox(height: 20),
                Text(
                  'Reportes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
               
                CustomOutlinedButton(
                  onPressed: () => generateAndDownloadPdf(solares, reservas),
                  text: "Generar Informe en PDF",
                ),
                
                SizedBox(height: 30),
                Text(
                  'Reservas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                
             Row(
      children: [
           Expanded(
        child: Column(
          children: [
           
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: 0.0,
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Card(
                
                elevation: 10,
                child: Container(
                  height: 500,
                  child: _buildReservasChart(
                    reservasPendientes,
                    reservasAprobadas,
                    reservasDisponibles,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
                 
      Expanded(
        child: Column(
          children: [
            Text(
              'Solares',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: 0.0,
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Card(
                elevation: 10,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: _solaresColumns,
                    rows: _solaresRows,
                  ),
                ),
              ),
            ),
    
           
                          
          ],
        ),
      ),
      ],
    ),
    Column(
      children: [
            Text(
              'Reservas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          Card(
        elevation: 10,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: _reservasColumns,
            rows: _reservasRows,
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           CustomOutlinedButton(
               text: _fechaController.text==""?"fecha desde":_fechaController.text,
                onPressed: () => _selectDate(context),
                
              ),
              SizedBox(width: 20,),
              CustomOutlinedButton(
               text: _fechaController2.text==""?"fecha hasta":_fechaController2.text,
                onPressed: () => _selectDate2(context),
                
              ),
        ],
      ),
       
              SizedBox(height: 10,)
      ],
    ),
    
           
                
                
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _buildReservasChart(
  int reservasPendientes,
  int reservasAprobadas,
  int reservasDisponibles,
) {
  final sections = _generateReservasSections(
    reservasPendientes,
    reservasAprobadas,
    reservasDisponibles,
  );

  return SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(height: 100,),
        AspectRatio(
          aspectRatio: 2.0, // Relación de aspecto 1:1 (gráfico circular cuadrado)
          child: PieChart(
            PieChartData(
              sections: sections,
            ),
          ),
        ),
       // Espacio entre el gráfico y el contenedor de porcentajes
       SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildPercentageWidgets(sections),
        ),

        SizedBox(height: 20,),
        SizedBox(height: 20,),
      ],
    ),
  );
}

List<Widget> _buildPercentageWidgets(List<PieChartSectionData> sections) {
  final List<Widget> percentageWidgets = [];
  final totalReservas = sections.fold<double>(
      0.0, (previous, section) => previous + section.value);

  for (final section in sections) {
    final percentage = (section.value / totalReservas) * 100;
    percentageWidgets.add(
      Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: section.color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '${percentage.toStringAsFixed(2)}%',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  return percentageWidgets;
}


  List<PieChartSectionData> _generateReservasSections(
  int reservasPendientes,
  int reservasAprobadas,
  int reservasDisponibles,
) {
  final totalReservas = reservasPendientes + reservasAprobadas + reservasDisponibles;

  final sections = <PieChartSectionData>[
    PieChartSectionData(
      value: reservasPendientes.toDouble(),
      title: 'Pendientes (${((reservasPendientes / totalReservas) * 100).toStringAsFixed(2)}%)',
      color: Colors.orange,
      radius: 50,
    ),
    PieChartSectionData(
      value: reservasAprobadas.toDouble(),
      title: 'Aprobadas (${((reservasAprobadas / totalReservas) * 100).toStringAsFixed(2)}%)',
      color: Colors.green,
      radius: 50,
    ),
    PieChartSectionData(
      value: reservasDisponibles.toDouble(),
      title: 'Disponibles (${((reservasDisponibles / totalReservas) * 100).toStringAsFixed(2)}%)',
      color: Colors.blue,
      radius: 50,
    ),
  ];

  return sections;
}


 


}
