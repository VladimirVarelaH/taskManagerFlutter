import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/colors.dart';
import 'package:flutter_application_1/translator/translator.dart';  

class TaskWidget extends StatefulWidget {
  final String taskName;
  final int id;
  bool completed;
  String currentLanguage;

  final Function(Map<String, dynamic>)? onComplete;
  final Function(Map<String, dynamic>)? deleteTask;
  final Function(Map<String, dynamic>)? updateTaskName;

  TaskWidget({
    Key? key,
    required this.taskName,
    required this.id,
    required this.completed,
    required this.currentLanguage,
    this.onComplete,
    this.deleteTask,
    this.updateTaskName,
  }) : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  late Translator translator;

  @override
  Widget build(BuildContext context) {
    translator = Translator(widget.currentLanguage);
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              widget.taskName,
              style: widget.completed ? TextStyle(decoration: TextDecoration.lineThrough) : null,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
                // Muestra el popup al presionar el botón de agregar
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String newTask = ""; // Variable para almacenar la nueva tarea
                    final TextEditingController controller = TextEditingController(text: widget.taskName);
                    return AlertDialog(
                      backgroundColor: lightGrayBckgnd,
                      title: Text(translator.translate('editTask')),
                      content: TextField(
                        controller: controller,
                        decoration: InputDecoration(hintText: translator.translate('newTaskPlaceholder')),
                        onChanged: (value) {
                          newTask = value; // Actualiza la nueva tarea cuando cambia el texto
                        },
                      ),
                      actions: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(lightRed), // Cambia el color de fondo del botón
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Cerrar el popup
                          },
                        child: Text(translator.translate("cancel")),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(lightGreen), // Cambia el color de fondo del botón
                          ),
                          onPressed: () {
                            widget.updateTaskName!({
                              "id":widget.id,
                              "_completed":widget.completed,
                              "taskName":newTask,
                            });
                            Navigator.of(context).pop(); // Cerrar el popup
                          },
                          child: Text(translator.translate("confirm")),
                        ),
                      ],
                    );
                  },
                );
              },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: lightGrayBckgnd,
                      title: Text(translator.translate("warning")),
                      content: Text(translator.translate('deleteWarningMessage', text:widget.taskName)),
                      actions: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(lightRed), // Cambia el color de fondo del botón
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Cerrar el popup
                          },
                        child: Text(translator.translate("cancel")),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(lightGreen), // Cambia el color de fondo del botón
                          ),
                          onPressed: () {
                            widget.deleteTask!({
                              'id': widget.id,
                              '_completed': widget.completed,
                              'taskName': widget.taskName,
                            });
                            Navigator.of(context).pop(); // Cerrar el popup
                          },
                          child: Text(translator.translate("confirm")),
                        ),
                      ],
                    );
                  },
                );
              // Acción al presionar el botón de eliminar
              
            },
          ),
        ],
      ),
      leading: Checkbox(
        value: widget.completed,
        onChanged: (newValue) {
          setState(() {
            // Cambia el estado interno del widget
            widget.completed = newValue!;
          });
          // Llama a la función onComplete si está definida
          if (widget.onComplete != null) {
            Map<String, dynamic> miMapa = {
              'id': widget.id,
              '_completed': widget.completed,
              'taskName': widget.taskName,
            };
            widget.onComplete!(miMapa);
          }
        },
      ),
    );
  }
}
