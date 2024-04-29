import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/colors.dart';
import 'package:flutter_application_1/widget/task.dart';
import 'package:flutter_application_1/translator/translator.dart';
import 'package:flutter_application_1/translator/stream/stream.dart';

class Home extends StatefulWidget {
  final TranslatorStream stream;
  final String currentLanguage;
  const Home({
    Key? key,
    required this.stream,
    required this.currentLanguage
  }) : super(key: key);


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map> tasksMaps = [];
  int lastId = 0;
  // String currentLang = "en";
  late Translator translator;

  @override
  void initState(){
    super.initState();
    translator = Translator(widget.currentLanguage);
  }

  void deleteTask(Map<String, dynamic> deleteableTask){
    List<Map> newTasks = [];

    for (int i = 0; i < tasksMaps.length; i++) {
      if(tasksMaps[i]["id"]!=deleteableTask["id"]){
        newTasks.add(tasksMaps[i]);
      }
    }

    setState(() {
      tasksMaps = newTasks;
    });
  }

  void updateTaskStatus(Map<String, dynamic> updatedTask){
    int? searchedIndex;
    for (int i = 0; i < tasksMaps.length; i++) {
      if(tasksMaps[i]["id"]==updatedTask["id"]){
        searchedIndex = i;
        break;
      }
    }

    if(searchedIndex!=null){
      tasksMaps[searchedIndex] = updatedTask;
    }
  }

  void updateTaskName(Map<String, dynamic> updatedTask){
    List<Map> newTasks = [];

    for (int i = 0; i < tasksMaps.length; i++) {
      if(tasksMaps[i]["id"]!=updatedTask["id"]){
        newTasks.add(tasksMaps[i]);
      } else {
        newTasks.add(updatedTask);
      }
    }

    setState(() {
      tasksMaps = newTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    translator = Translator(widget.currentLanguage);

    return Scaffold(
      backgroundColor: lightGrayBckgnd,
      appBar: AppBar(
        backgroundColor: lightGrayBckgnd,
        leading: IconButton(
          icon: const Icon(Icons.settings), // Ícono predefinido de Material Icons
          onPressed: () {
            // Acción al presionar el botón
            showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                backgroundColor: lightGrayBckgnd,
                title: Text(translator.translate('selectLang')),
                content: DropdownButton<String>(
                  value: widget.currentLanguage,
                  onChanged: (value) {
                    value = value!;
                    widget.stream.addEvent(value);
                    Navigator.of(context).pop(); 
                  },
                  items: translator.getAcceptedLanguajes()
                    .map<DropdownMenuItem<String>>((Map<String, String> language) {
                      return DropdownMenuItem<String>(
                        value: language["code"],
                        child: Text(language["name"]!),
                      );
                    })
                  .toList(),

                ),
                actions: [
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(lightRed), 
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); 
                    },
                  child: Text(translator.translate("cancel")),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(lightGreen), 
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Cerrar el popup
                    },
                    child: Text(translator.translate('confirm')),
                  ),
                ],
              );
            });
          },
        ),
      ),
      body: Scaffold(
        backgroundColor: lightGrayBckgnd,
        appBar: AppBar(
          backgroundColor: lightGrayBckgnd,
          title: Text(translator.translate('tasksTitle')),
          actions: [
            IconButton(
              icon: const Icon(Icons.add), // First icon
              onPressed: () {
                // Muestra el popup al presionar el botón de agregar
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String newTask = ""; // Variable para almacenar la nueva tarea
                      return AlertDialog(
                        backgroundColor: lightGrayBckgnd,
                        title: Text(translator.translate('taskName')),
                        content: TextField(
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
                              Map<String, dynamic> newMap = {
                                'id': lastId,
                                '_completed': false,
                                'taskName': newTask,
                              };
                              // Agregar la nueva tarea a la lista
                              setState(() {
                                lastId +=1;
                                
                                tasksMaps.add(newMap);
                              });
                              // setState(() {
                              //   tasks.add("ddd");
                              // });
                              Navigator.of(context).pop(); // Cerrar el popup
                            },
                            child: Text(translator.translate('confirm')),
                          ),
                        ],
                      );
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.clear_all), // Second icon
              onPressed: () {
                setState(() {
                  tasksMaps.removeWhere((task) => task["_completed"]);
                });

              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: tasksMaps.length,
          itemBuilder: (BuildContext context, int index) {
            return TaskWidget(
              taskName: tasksMaps[index]["taskName"],
              id: tasksMaps[index]["id"],
              completed: tasksMaps[index]["_completed"],
              onComplete: updateTaskStatus,
              deleteTask: deleteTask,
              updateTaskName: updateTaskName,
              currentLanguage:widget.currentLanguage
            );
          },
        ),
      ),
    );
  }
}