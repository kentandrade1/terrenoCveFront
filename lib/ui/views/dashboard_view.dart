import 'package:flutter/material.dart';

import '../buttons/custom_outlined_button.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  String selectedImage = 'assets/Render1.png';
  String selectedDescription = 'Plano General';
  double zoomLevel = 5.0;
  String selectedImageCV1 = 'assets/general_cv1.png';
  String selectedDescriptionCV1 = 'Etapa 1';
  double zoomLevelCV1 = 5.0; // Nivel de zoom inicial
  bool proyectobool = false;

  void selectImageCV1(String image, String description) {
    setState(() {
      selectedImageCV1 = image;
      selectedDescriptionCV1 = description;
    });
  }

  void zoomInCV1() {
    setState(() {
      zoomLevelCV1 += 0.5;
    });
  }

  void zoomOutCV1() {
    setState(() {
      zoomLevelCV1 -= 0.5;
      if (zoomLevelCV1 < 0.5) {
        zoomLevelCV1 = 0.5;
      }
    });
  }

  void selectImage(String image, String description) {
    setState(() {
      selectedImage = image;
      selectedDescription = description;
    });
  }

  void zoomIn() {
    setState(() {
      zoomLevel += 0.5;
    });
  }

  void zoomOut() {
    setState(() {
      zoomLevel -= 0.5;
      if (zoomLevel < 0.5) {
        zoomLevel = 0.5;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical, // Permite desplazamiento vertical
        child: Card(
          elevation: 10,
          color: Colors.grey.shade200,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (proyectobool == false)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal, // Permite desplazamiento horizontal
                      child: Card(
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "PROYECTO CVE1",
                                  style: TextStyle(
                                      fontSize: 30, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                IconButton(
                                  onPressed: () {
                                    proyectobool = !proyectobool;
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.change_circle, color: Colors.blue),
                                ),
                              ],
                            ),
                            
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomOutlinedButton(
                                    onPressed: () {
                                      selectImageCV1('assets/general_cv1.png', 'General');
                                    },
                                    text: "General",
                                  ),
                                  SizedBox(width: 8),
                                  CustomOutlinedButton(
                                    onPressed: () {
                                      selectImageCV1('assets/etapa1_cv1.png', 'Etapa 1');
                                    },
                                    text: "Etapa 1",
                                  ),
                                  SizedBox(width: 8),
                                  CustomOutlinedButton(
                                    onPressed: () {
                                      selectImageCV1('assets/etapa2_cv1.PNG', 'Etapa 2');
                                    },
                                    text: "Etapa 2",
                                  ),
                                  SizedBox(width: 8),
                                  CustomOutlinedButton(
                                    onPressed: () {
                                      selectImageCV1('assets/etapa3_cv1.PNG', 'Etapa 3');
                                    },
                                    text: "Etapa 3",
                                  ),
                                  SizedBox(width: 8),
                                  CustomOutlinedButton(
                                    onPressed: () {
                                      selectImageCV1('assets/etapa4_cv1.PNG', 'Etapa 4');
                                    },
                                    text: "Etapa 4",
                                  ),
                                  SizedBox(width: 8),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 8),
                                  CustomOutlinedButton(
                                    onPressed: () {
                                      selectImageCV1('assets/etapa5_cv1.png', 'Etapa 5');
                                    },
                                    text: "Etapa 5",
                                  ),
                                  SizedBox(width: 8),
                                  CustomOutlinedButton(
                                    onPressed: () {
                                      selectImageCV1('assets/etapa6_cv1.PNG', 'Etapa 6');
                                    },
                                    text: "Etapa 6",
                                  ),
                                  SizedBox(width: 8),
                                  CustomOutlinedButton(
                                    onPressed: () {
                                      selectImageCV1('assets/etapa7_cv1.PNG', 'Etapa 7');
                                    },
                                    text: "Etapa 7",
                                  ),
                                  SizedBox(width: 8),
                                  CustomOutlinedButton(
                                    onPressed: () {
                                      selectImageCV1('assets/etapa8_cv1.PNG', 'Etapa 8');
                                    },
                                    text: "Etapa 8",
                                  ),
                                  SizedBox(width: 8),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(height: 10),
                            Text(
                              selectedDescriptionCV1,
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // Desplazamiento horizontal
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  selectedImageCV1.isNotEmpty
                                      ? InteractiveViewer(
                                          boundaryMargin: EdgeInsets.all(20),
                                          minScale: 0.5,
                                          maxScale: 4.0,
                                          scaleEnabled: true,
                                          child: Image.asset(
                                            selectedImageCV1,
                                            width: MediaQuery.of(context).size.width,
                                            height: MediaQuery.of(context).size.height,
                                          ),
                                        )
                                      : Text('Seleccione una imagen'),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  // Proyecto CVE2
                  if (proyectobool == true)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal, // Permite desplazamiento horizontal
                      child: Card(
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "PROYECTO CVE2",
                                  style: TextStyle(
                                      fontSize: 30, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                IconButton(
                                  onPressed: () {
                                    proyectobool = !proyectobool;
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.change_circle, color: Colors.blue),
                                ),
                              ],
                            ),
                            // ... (Código anterior)
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // Desplazamiento horizontal
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  selectedImage.isNotEmpty
                                      ? InteractiveViewer(
                                          boundaryMargin: EdgeInsets.all(20),
                                          minScale: 0.5,
                                          maxScale: 4.0,
                                          scaleEnabled: true,
                                          child: Image.asset(
                                            selectedImage,
                                            width: MediaQuery.of(context).size.width,
                                            height: MediaQuery.of(context).size.height,
                                          ),
                                        )
                                      : Text('Seleccione una imagen'),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
