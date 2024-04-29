import 'dart:async';
import 'package:flutter/material.dart'; // Importa esto

class TranslatorStream {
  final StreamController<String> _controller = StreamController.broadcast();
  final List<VoidCallback> _subscribedFunctionsList = [];
  late StreamSubscription _subscription;
  String _currenntLenguaje = "en";

  TranslatorStream(){
    Stream stream = _controller.stream;
    _subscription = stream.listen((value) {
      notifySubscribers();
    });
  }

  void subscribeFunction(VoidCallback function) { // Cambio en el tipo de función
    _subscribedFunctionsList.add(function);
  }

  void clearFunctions() {
    _subscribedFunctionsList.clear();
  }

  void notifySubscribers() {
    for (int i = 0; i < _subscribedFunctionsList.length; i++) {
      _subscribedFunctionsList[i]();
    }
  }

  StreamSubscription getSubscription() {
    Stream stream = _controller.stream;
    _subscription.cancel();
    _subscription = stream.listen((value) {
      print('Valor escuchado $value');
      notifySubscribers();
    });
    return _subscription;
  }

  void addEvent(String value) {
    getSubscription();
    _currenntLenguaje = value;
    _controller.add(value);
  }

  String getCurrentLenguaje(){
    return _currenntLenguaje;
  }
}
