import 'dart:developer';
import 'package:front_end/controls/servicio_back/RespuestaGenerica.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front_end/controls/util/Utiles.dart';

class Conexion {
  // CASA
  final String URL = "http://192.168.0.105:3000/maptrip/";
  
  static bool NO_TOKEN = false;
  //anime-token
  Future<RespuestaGenerica> solicitudGet(String recurso, bool token) async {
    Map<String, String> header = {"Content-Type": "application/json"};

    if (token) {
      Utiles util = Utiles();
      String? tokenA = await util.getValue("token");
      header = {
        "Content-Type": "application/json",
        "anime-token": tokenA.toString(),
      };
    }

    final String url = URL + recurso;
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri, headers: header);

      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          return _response(404, "Recurso no encontrado", []);
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          return _response(mapa['code'], mapa['msg'], mapa['datos']);
        }
      } else {
        log(response.body);
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        return _response(mapa['code'], mapa['msg'], mapa['datos']);
      }
    } catch (e) {
      return _response(500, "Error Inesperado", []);
    }
  }

  Future<RespuestaGenerica> solicitudPost(
      String recurso, bool token, Map<dynamic, dynamic> mapa) async {
    Map<String, String> header = {'Content-Type': 'application/json'};
    if (token) {
      Utiles util = Utiles();
      String? token = await util.getValue('token');
      header = {
        'Content-Type': 'application/json',
        'anime-token': token.toString(),
      };
    }

    final String url = URL + recurso;
    final uri = Uri.parse(url);

    try {
      final response = await http.post(
        uri,
        headers: header,
        body: jsonEncode(mapa),
      );

      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          return _response(404, "Recurso no encontrado", []);
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          return _response(mapa['code'], mapa['msg'], mapa['datos']);
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        return _response(mapa['code'], mapa['msg'], mapa['datos']);
      }
    } catch (e) {
      return _response(500, "Error inesperado", []);
    }
  }

  Future<RespuestaGenerica> solicitudPut(
      String recurso, bool token, Map<dynamic, dynamic> mapa) async {
    Map<String, String> header = {'Content-Type': 'application/json'};
    if (token) {
      Utiles util = Utiles();
      String? token = await util.getValue('token');
      header = {
        'Content-Type': 'application/json',
        'anime-token': token.toString(),
      };
    }

    final String url = URL + recurso;
    final uri = Uri.parse(url);

    try {
      final response = await http.put(
        uri,
        headers: header,
        body: jsonEncode(mapa),
      );

      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          return _response(404, "Recurso no encontrado", []);
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          return _response(mapa['code'], mapa['msg'], mapa['datos']);
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        return _response(mapa['code'], mapa['msg'], mapa['datos']);
      }
    } catch (e) {
      return _response(500, "Error inesperado", []);
    }
  }

  RespuestaGenerica _response(int code, String msg, dynamic data) {
    var respuesta = RespuestaGenerica();
    respuesta.code = code;
    respuesta.datos = data;
    respuesta.msg = msg;
    return respuesta;
  }
}
