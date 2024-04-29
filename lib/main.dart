import 'dart:async';

import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'package:flutter_application_1/translator/stream/stream.dart';  


void main() {
  runApp(const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TranslatorStream translatorStream = TranslatorStream();
  String  currentLanguage = "en";

  @override
  void initState() {
    super.initState();
    translatorStream.subscribeFunction(updateHomeOnLanguageChange);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskManager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 16, 213, 125)),
        useMaterial3: true,
      ),
      home: Home(stream: translatorStream, currentLanguage: currentLanguage),
    );
  }

  void updateHomeOnLanguageChange() {
    setState(() {
      currentLanguage = translatorStream.getCurrentLenguaje();
    });
    setState(() {
      // Actualizar la interfaz de usuario de Home cuando cambie el idioma
    });
  }
}
