import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> myDialogWarning(BuildContext context, String label) {
  ///

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      ///
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });

      ///
      return Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width <= 281 ? 260 : 350,
              height: label.length > 100 ? 120 : 100,
              margin: const EdgeInsets.fromLTRB(5, 20, 0, 0),
              // padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red,
              ),
              child: Stack(
                children: <Widget>[
                  ///!
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      color: Colors.red,
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: const Icon(
                        Icons.warning,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  ///!
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(47, 10, 47, 5),
                      child: Material(
                        color: Colors.red,
                        child: SizedBox(
                          child: Text(
                            label,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  ///!
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: Material(
                  //     color: Colors.transparent,
                  //     child: IconButton(
                  //       onPressed: () {
                  //         Navigator.pop(context);
                  //       },
                  //       icon: const Icon(
                  //         Icons.close,
                  //         size: 25,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  ///!
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> myDialogWarning2(BuildContext context, String label) {
  ///

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      ///
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });

      ///
      return Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width <= 281 ? 260 : 350,
              height: label.length > 100 ? 120 : 100,
              margin: const EdgeInsets.fromLTRB(5, 20, 0, 0),
              // padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red,
              ),
              child: Stack(
                children: <Widget>[
                  ///!
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      color: Colors.red,
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: const Icon(
                        Icons.warning,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  ///!
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(47, 10, 47, 5),
                      child: Material(
                        color: Colors.red,
                        child: SizedBox(
                          child: Text(
                            label,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  ///!
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: Material(
                  //     color: Colors.transparent,
                  //     child: IconButton(
                  //       onPressed: () {
                  //         Navigator.pop(context);
                  //       },
                  //       icon: const Icon(
                  //         Icons.close,
                  //         size: 25,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  ///!
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> myDialogBlueWarning(BuildContext context, String label) {
  ///
  // ignore: unused_local_variable
  late Timer timerButtonOver;

  ///
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      ///
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });

      ///
      return Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width <= 281 ? 260 : 350,
              height: 110,
              margin: const EdgeInsets.fromLTRB(5, 20, 0, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xff3655b3),
              ),
              child: Stack(
                children: <Widget>[
                  ///!
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      color: const Color(0xff3655b3),
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: const Icon(
                        Icons.warning,
                       // FontAwesomeIcons.circleExclamation,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  ///!
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(47, 10, 47, 5),
                      child: Material(
                        color: const Color(0xff3655b3),
                        child: SizedBox(
                          child: Text(
                            label,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  ///!
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: Material(
                  //     color: Colors.transparent,
                  //     child: IconButton(
                  //       onPressed: () {
                  //         Navigator.pop(context);
                  //       },
                  //       icon: const Icon(
                  //         Icons.close,
                  //         size: 25,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  ///!
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> myDialogDone(BuildContext context, String label) {
  ///
  // ignore: unused_local_variable
  late Timer timerButtonOver;

  ///
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      ///
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });

      ///
      return Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width <= 281 ? 260 : 350,
              height: 110,
              margin: const EdgeInsets.fromLTRB(5, 20, 0, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green,
              ),
              child: Stack(
                children: <Widget>[
                  ///!
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      color: Colors.green,
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: const Icon(
                        Icons.done,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  ///!
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(47, 10, 47, 5),
                      child: Material(
                        color: Colors.green,
                        child: SizedBox(
                          child: Text(
                            label,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  ///!
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: Material(
                  //     color: Colors.transparent,
                  //     child: IconButton(
                  //       onPressed: () {
                  //         Navigator.pop(context);
                  //       },
                  //       icon: const Icon(
                  //         Icons.close,
                  //         size: 25,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  ///!
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

Future<void> myDialogApiResult(BuildContext context, String label) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        insetPadding: EdgeInsets.zero, // Ajusta los bordes exteriores del diálogo
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        contentPadding: EdgeInsets.zero, // Elimina el padding interno
        content: SizedBox(
          width: 400,
          height: 240,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ///
                    ///!  Label "Aviso"
                    Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        color: Color.fromARGB(255, 69, 139, 64),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: 20), // Espacio después del ícono
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 13,
                              child: Icon(
                                Icons.warning,
                               // FontAwesomeIcons.circleExclamation,
                                size: 24,
                                color: Color.fromARGB(255, 69, 139, 64),
                              ),
                            ),
                            SizedBox(width: 20), // Espacio después del ícono
                            Text(
                              '¡Aviso!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Texto en color blanco
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    ///! Texto
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: SizedBox(
                          height: 120,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Material(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Ajusta el radio de la esquina según tus preferencias
                                    border: Border.all(
                                      color: Colors.grey[300]!, // Color gris suave
                                      width: 1.0, // Ancho del contorno
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      child: Text(
                                        'XXX',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          //color: Colors.black,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    ///!  Cerrar y Copiar a memoria
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 140),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 69, 139, 64),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                "Cerrar",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              tooltip:
                                  "Copiar a Memoria",
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text:
""                                  ),
                                );
                                final snackBar = SnackBar(
                                  content: Text("Copiado a Memoria"),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              },
                              icon: const Icon(
                                Icons.copy,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Agregamos el botón de copiar aquí
        ),
      );
},
);
}