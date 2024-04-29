import 'package:flutter/material.dart';


class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget>{
  @override
  Widget build(BuildContext context) {
    String dataFromChild = ""; // Variable para almacenar los datos del widget hijo

    // Función de devolución de llamada para recibir datos del widget hijo
    void onDataReceived(String data) {
      setState(() {
        print("3312");
        dataFromChild = data; // Almacena los datos recibidos del widget hijo
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Widget'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Datos del widget hijo: $dataFromChild'),
          SizedBox(height: 20),
          // Construye el widget hijo y pasa la función de devolución de llamada
          ChildWidget(onDataReceived: onDataReceived),
        ],
      ),
    );
  }
}

class ChildWidget extends StatelessWidget {
  final Function(String) onDataReceived; // Función de devolución de llamada

  ChildWidget({required this.onDataReceived}); // Constructor

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Al presionar el botón, llama a la función de devolución de llamada
        onDataReceived("sfsf");
      },
      child: Text('Enviar Datos al Padre'),
    );
  }
}

