import 'dart:math';

import 'package:admin_dashboard/providers/categories_provider.dart';
import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:data_table_2/data_table_2.dart';

import '../../models/solares.dart';
import '../inputs/custom_inputs.dart';

class CategoriesView extends StatefulWidget {
  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  TextEditingController ubicacionController = TextEditingController();
  TextEditingController etapaController = TextEditingController();
  TextEditingController manzanaController = TextEditingController();
  TextEditingController solareController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  TextEditingController _estadoController = TextEditingController();
  TextEditingController _ubicacionController = TextEditingController();
  @override
  String caracteristicas = 'medianero';
  String proyect = 'PU01';
  String dropdownValue = 'disponible';
  double anchoValue = 0.0;
  double largoValue = 0.0;
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();

    Provider.of<GeneralProvider>(context, listen: false).getSolares();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final categoryProvider =
        Provider.of<GeneralProvider>(context, listen: false);
    final solares = Provider.of<GeneralProvider>(context).solares;
    List<Solares> filteredSolares = solares
        .where((solar) => solar.caracteristicas
            .toLowerCase()
            .contains(_descripcionController.text.toLowerCase()))
        .where((solar) => solar.estadoR
            .toLowerCase()
            .contains(_estadoController.text.toLowerCase()))
        .where((solar) => solar.ubicacion
            .toLowerCase()
            .contains(_ubicacionController.text.toLowerCase()))
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
                    label: Text('Tipo lote'),
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
                      DataCell(Text(solar.caracteristicas[0].toUpperCase() +
                          solar.caracteristicas.substring(1))),
                      DataCell(Text(solar.largo.toString() + "m")),
                      DataCell(Text(solar.ancho.toString() + "m")),
                      DataCell(Text("${solar.ancho * solar.largo}m²")),
                      DataCell(Text(solar.estadoR[0].toUpperCase() +
                          solar.estadoR.substring(1))),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String ubicacion = solar.ubicacion;
                                    String caracteristicas =
                                        solar.caracteristicas;
                                    double largo = solar.largo;
                                    double ancho = solar.ancho;
                                    double precio = solar.precio;
                                    String estado = solar.estadoR;
                                    etapaController.text = solar.etapa;
                                    manzanaController.text = solar.manzana;
                                    solareController.text = solar.solare;
                                    String dropdownValue = estado;

                                    return AlertDialog(
                                      title: Text('Editar Solar'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            DropdownButtonFormField<String>(
                                              value: proyect,
                                              decoration: InputDecoration(
                                                  labelText: 'Proyecto'),
                                              items: <String>[
                                                'PU01',
                                                'PU02'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  proyect = newValue!;
                                                });
                                              },
                                            ),
                                            TextField(
                                              controller: etapaController,
                                              decoration: InputDecoration(
                                                  labelText: 'Lote'),
                                            ),
                                            TextField(
                                              controller: manzanaController,
                                              decoration: InputDecoration(
                                                  labelText: 'Manzana'),
                                            ),
                                            TextField(
                                              controller: solareController,
                                              decoration: InputDecoration(
                                                  labelText: 'Solar'),
                                            ),
                                            DropdownButtonFormField<String>(
                                              value: caracteristicas,
                                              decoration: InputDecoration(
                                                  labelText: 'Tipo lote'),
                                              items: <String>[
                                                'medianero',
                                                'esquinero'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  caracteristicas = newValue!;
                                                });
                                              },
                                            ),
                                            DropdownButtonFormField<String>(
                                              value: dropdownValue,
                                              decoration: InputDecoration(
                                                  labelText: 'Estado'),
                                              items: <String>[
                                                'disponible',
                                                'en proceso',
                                                'reservado'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownValue = newValue!;
                                                });
                                              },
                                            ),
                                            TextField(
                                              controller: TextEditingController(
                                                  text: largo.toString()),
                                              onChanged: (value) {
                                                if (double.tryParse(value) !=
                                                    null) {
                                                  largo = double.parse(value);
                                                }
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        r'^\d+\.?\d{0,2}'))
                                              ],
                                              decoration: InputDecoration(
                                                labelText: 'Largo',
                                              ),
                                            ),
                                            TextField(
                                              controller: TextEditingController(
                                                  text: ancho.toString()),
                                              onChanged: (value) {
                                                if (double.tryParse(value) !=
                                                    null) {
                                                  ancho = double.parse(value);
                                                }
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        r'^\d+\.?\d{0,2}'))
                                              ],
                                              decoration: InputDecoration(
                                                labelText: 'Ancho',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        CustomOutlinedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          text: "Cerrar",
                                        ),
                                        CustomOutlinedButton(
                                            onPressed: () async {
                                              String manzana =
                                                  manzanaController.text;
                                              String etapa =
                                                  etapaController.text;
                                              String solare =
                                                  solareController.text;
                                              // Validar que los campos no estén vacíos
                                              if (ubicacion.isEmpty ||
                                                  caracteristicas.isEmpty ||
                                                  // ignore: unnecessary_null_comparison
                                                  largo == null ||
                                                  // ignore: unnecessary_null_comparison
                                                  ancho == null ||
                                                  dropdownValue.isEmpty) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text('Campos vacíos'),
                                                      content: Text(
                                                          'Por favor, completa todos los campos.'),
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text('Cerrar'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                return;
                                              }

                                              await categoryProvider
                                                  .updateSolar(
                                                      solar.id,
                                                      ubicacion,
                                                      caracteristicas,
                                                      precio,
                                                      ancho,
                                                      largo,
                                                      dropdownValue,
                                                      solare,
                                                      manzana,
                                                      etapa);
                                              Navigator.of(context).pop();
                                            },
                                            text: "editar"),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                size: 18,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                await categoryProvider.deleteSolar(solar.id);
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
            //botones
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
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
            CustomOutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Nuevo'),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButtonFormField<String>(
                              value: proyect,
                              decoration: CustomInputs.formInputDecoration(
                                  hint: 'Proyecto',
                                  label: 'Proyecto',
                                  icon: Icons.supervised_user_circle_outlined),
                              items: <String>[
                                'PU01',
                                'PU02'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  proyect = newValue!;
                                });
                              },
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: etapaController,
                              decoration: CustomInputs.formInputDecoration(
                                  hint: 'Etapa',
                                  label: 'Etapa',
                                  icon: Icons.supervised_user_circle_outlined),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: manzanaController,
                              decoration: CustomInputs.formInputDecoration(
                                  hint: 'Manzana',
                                  label: 'Manzana',
                                  icon: Icons.supervised_user_circle_outlined),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: solareController,
                              decoration: CustomInputs.formInputDecoration(
                                  hint: 'Solar',
                                  label: 'Solar',
                                  icon: Icons.supervised_user_circle_outlined),
                            ),
                            SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              value: caracteristicas,
                              decoration: CustomInputs.formInputDecoration(
                                  hint: 'Tipo lote',
                                  label: 'Tipo lote',
                                  icon: Icons.supervised_user_circle_outlined),
                              items: <String>[
                                'medianero',
                                'esquinero'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  caracteristicas = newValue!;
                                });
                              },
                            ),
                            SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              value: dropdownValue,
                              decoration: CustomInputs.formInputDecoration(
                                  hint: 'Estado',
                                  label: 'Estado',
                                  icon: Icons.supervised_user_circle_outlined),
                              items: <String>[
                                'disponible',
                                'en proceso',
                                'reservado'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                            ),
                            SizedBox(height: 20),
                            TextField(
                              decoration: CustomInputs.formInputDecoration(
                                  hint: 'Ancho(m)',
                                  label: 'Ancho(m)',
                                  icon: Icons.supervised_user_circle_outlined),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              onChanged: (value) {
                                anchoValue = double.tryParse(value) ?? 0.0;
                              },
                            ),
                            SizedBox(width: 20),
                            TextField(
                              decoration: CustomInputs.formInputDecoration(
                                  hint: 'Largo(m)',
                                  label: 'Largo(m)',
                                  icon: Icons.supervised_user_circle_outlined),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              onChanged: (value) {
                                largoValue = double.tryParse(value) ?? 0.0;
                              },
                            ),
                          ],
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
                            String ubicacion = ubicacionController.text;
                            String etapa = etapaController.text;
                            String manzana = manzanaController.text;
                            String solare = solareController.text;
                            // Verificar si algún campo está vacío o nulo
                            if (solare.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content: Text(
                                        'El campo "Solar" no puede estar vacío.'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Aceptar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return; // Detener el flujo de ejecución
                            }
                            if (manzana.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content: Text(
                                        'El campo "Manzana" no puede estar vacío.'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Aceptar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return; // Detener el flujo de ejecución
                            }
                            if (etapa.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content: Text(
                                        'El campo "Lote" no puede estar vacío.'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Aceptar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return; // Detener el flujo de ejecución
                            }

                            if (caracteristicas.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content: Text(
                                        'El campo "Características" no puede estar vacío.'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Aceptar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return; // Detener el flujo de ejecución
                            }

                            if (anchoValue <= 0.0) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content: Text(
                                        'El campo "Ancho" debe ser mayor que 0.'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Aceptar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return; // Detener el flujo de ejecución
                            }

                            if (largoValue <= 0.0) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content: Text(
                                        'El campo "Largo" debe ser mayor que 0.'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Aceptar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              return; // Detener el flujo de ejecución
                            }

                            // Resto de la lógica de validación y guardado de datos
                            print(dropdownValue);
                            await categoryProvider.newSolar(
                                proyect,
                                etapa,
                                manzana,
                                solare,
                                caracteristicas,
                                anchoValue,
                                largoValue,
                                dropdownValue);

                            Navigator.of(context).pop();
                          },
                          child: Text('Guardar'),
                        ),
                      ],
                    );
                  },
                );
              },
              text: "Nuevo",
            ),
          ],
        ),
      ),
    );
  }
}
