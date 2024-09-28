import 'dart:convert';

import 'package:front_end/controls/Conexion.dart';
import 'package:front_end/controls/servicio_back/RespuestaGenerica.dart';
import 'package:front_end/controls/servicio_back/modelo/InicioSesionSW.dart';
import 'package:front_end/controls/servicio_back/modelo/LugarTipoSW.dart';
import 'package:http/http.dart' as http;

class Facadeservice {
  Conexion c = Conexion();
  //Inicio de Sesion
  Future<InicioSesionSW> inicioSesion(Map<String, String> mapa) async {
    Map<String, String> header = {'Content-Type': 'application/json'};
    final String url = '${c.URL}inicio_sesion';
    final uri = Uri.parse(url);
    InicioSesionSW isw = InicioSesionSW();
    try {
      final response =
          await http.post(uri, headers: header, body: jsonEncode(mapa));
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          isw.code = 404;
          isw.msg = "Error";
          isw.tag = "Recurso no encontrado";
          isw.datos = {};
        } else {
          Map<dynamic, dynamic> mapa = jsonDecode(response.body);
          isw.code = mapa['code'];
          isw.msg = mapa['msg'];
          isw.tag = mapa['tag'];
          isw.datos = mapa['datos'];
        }
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        isw.code = mapa['code'];
        isw.msg = mapa['msg'];
        isw.tag = mapa['tag'];
        isw.datos = mapa['datos'];
      }
    } catch (e) {
      isw.code = 500;
      isw.msg = "Error";
      isw.tag = "Error Inesperado";
      isw.datos = {};
    }
    return isw;
  }

  //Listar Lugares
  Future<RespuestaGenerica> listarLugares() async {
    return await c.solicitudGet("listar", true);
  }

  //Listar Lugares por Tipo
  Future<LugarTipoSW> listarLugaresTipo(String tipo) async {
    Map<String, String> header = {"Content-Type": "application/json"};
    final String url = '${c.URL}listar';
    final uri = Uri.parse(url);
    LugarTipoSW lts = LugarTipoSW();
    try {
      final response = await http.post(uri,
          headers: header, body: jsonEncode({"tipo": tipo}));
      if (response.statusCode != 200) {
        lts.code = response.statusCode;
        lts.msg = "Error";
        lts.tag = "Recurso no encontrado";
        lts.datos = {};
      } else {
        Map<dynamic, dynamic> mapa = jsonDecode(response.body);
        lts.code = mapa['code'];
        lts.msg = mapa['msg'];
        lts.tag = mapa['tag'];
        lts.datos = mapa['datos'];
      }
    } catch (e) {
      lts.code = 500;
      lts.msg = "Error";
      lts.tag = "Error Inesperado";
      lts.datos = {};
    }
    return lts;
  }
}
