import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Clima {
  var temperatura, feelslike, humedad;
  Clima({this.temperatura, this.feelslike, this.humedad});
  Clima.fromJsonMap(Map<String, dynamic> json) {
    temperatura = json['temp'];
    feelslike = json['feels_like'];
    humedad = json['humidity'];
  }
}

class ClimaParam {
  static Map<String, dynamic> _datos;
  static String _url =
      "https://api.openweathermap.org/data/2.5/weather?id=3658666&appid=161de5e0e093bc332b4e8ccdaa52b834";
  static Future<Clima> obtenerDatos() async {
    final resp = await http.get(_url);
    final decodeData = json.decode(resp.body);
    _datos = decodeData['main'];
    final clima = new Clima.fromJsonMap(_datos);
    return clima;
  }
}
