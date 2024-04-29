import 'package:flutter_application_1/translator/en.dart';
import 'package:flutter_application_1/translator/es.dart';
import 'package:flutter_application_1/translator/fr.dart';
import 'package:flutter_application_1/translator/pr.dart';
import 'package:flutter_application_1/translator/stream/stream.dart';


class Translator{
  late String _defaultLanguage;
  final TranslatorStream _stream = TranslatorStream();
  final List<Map<String, String>> _acceptedLanguajes = [
    {"code":"en", "name":"English"},
    {"code":"es", "name":"Español"},
    {"code":"fr", "name":"Français"},
    {"code":"pr", "name":"Português"}
  ];

  Translator(String defaultLanguage) {
    _defaultLanguage = defaultLanguage;
  }

  String translate(String key,  {String text = ""}){
    String response = "";
    late Map<String, String> translationMaps;

    switch (_defaultLanguage) {
      case 'es':
        translationMaps = Es.getTranslations(text);
        break;
      case 'fr':
        translationMaps = Fr.getTranslations(text);
        break;
      case 'pr':
        translationMaps = Pr.getTranslations(text);
        break;
      default:
        translationMaps = En.getTranslations(text);
        break;
    }
    
    response = translationMaps[key]??"";
    return response;   
  }

  List<Map<String, String>> getAcceptedLanguajes(){
    return _acceptedLanguajes;
  }
  TranslatorStream getStream(){
    return _stream;
  }
}