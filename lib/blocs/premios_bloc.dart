import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_auth/model/Historico_ganhadores_premios_cristais.dart';
import 'package:flutter_auth/model/Historico_ganhadores_premios_ofensiva.dart';
import 'package:flutter_auth/model/premios_cristal.dart';
import 'package:flutter_auth/model/premios_ofensiva.dart';
import 'package:http/http.dart' as http;

import '../api.dart';

class PremiosBloc implements BlocBase {
  String url = Api.URL;
  List<PremiosCristal> listPremiosCristals;
  List<HistoricoGanhadoresPremiosCristais> listHistoricoGanhadoresPremiosCristais;

  List<PremiosCfensiva> listPremiosCfensivas;
  List<HistoricoGanhadoresPremiosOfensiva> listHistoricoGanhadoresPremiosOfensiva;

  final StreamController<List<HistoricoGanhadoresPremiosOfensiva>> _HistoricoGanhadoresPremiosOfensivaController =
  StreamController<List<HistoricoGanhadoresPremiosOfensiva>>.broadcast();

  Stream get outHistoricoGanhadoresPremiosOfensiva => _HistoricoGanhadoresPremiosOfensivaController.stream;

  final StreamController<List<HistoricoGanhadoresPremiosCristais>> _HistoricoGanhadoresPremiosCristalController =
  StreamController<List<HistoricoGanhadoresPremiosCristais>>.broadcast();

  Stream get outHistoricoGanhadoresPremiosCristal => _HistoricoGanhadoresPremiosCristalController.stream;

  final StreamController<List<PremiosCristal>> _premiosCristalController =
      StreamController<List<PremiosCristal>>.broadcast();

  Stream get outPremiosCristal => _premiosCristalController.stream;

  final StreamController<List<PremiosCfensiva>> _premiosOfensivaController =
      StreamController<List<PremiosCfensiva>>.broadcast();

  Stream get outPremiosCfensiva => _premiosOfensivaController.stream;

  @override
  void dispose() {
    // TODO: implement dispose
    _HistoricoGanhadoresPremiosOfensivaController.close();
    _HistoricoGanhadoresPremiosCristalController.close();
    _premiosCristalController.close();
    _premiosOfensivaController.close();
  }

  Future<http.Response> editarGanhadorCristal(HistoricoGanhadoresPremiosCristais historicoGanhadoresPremiosCristais, String token) async {
    var response = await http.post(
        Uri.parse("${url}/administrador/editarGanhadorCristal"),
        headers: {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: token},
        body: jsonEncode(historicoGanhadoresPremiosCristais.toJson())
    );


    return response;

  }

  Future<http.Response> editarGanhadorOfensiva(HistoricoGanhadoresPremiosOfensiva historicoGanhadoresPremiosOfensiva, String token) async {
    var response = await http.post(
        Uri.parse("${url}/administrador/editarGanhadorOfensiva"),
        headers: {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: token},
        body: jsonEncode(historicoGanhadoresPremiosOfensiva.toJson())
    );


    return response;

  }

  Future<http.Response> editarPremiosCristal(PremiosCristal premiosCristal, String token) async {

    var response = await http.put(
        Uri.parse("${url}/administrador/admin/editarPremiosCristal/"),
        headers: {HttpHeaders.contentTypeHeader: "application/json",  HttpHeaders.authorizationHeader: token},
        body: jsonEncode(premiosCristal.toJson())
    );

   // _premiosCristalController.sink.add(listPremiosCristals);



    return response;

  }
  Future<http.Response> editarPremiosOfensiva(PremiosCfensiva premiosCfensiva, String token) async {

    var response = await http.put(
        Uri.parse("${url}/administrador/admin/editarPremiosOfensiva/"),
        headers: {HttpHeaders.contentTypeHeader: "application/json",  HttpHeaders.authorizationHeader: token},
        body: jsonEncode(premiosCfensiva.toJson())
    );

    // _premiosCristalController.sink.add(listPremiosCristals);



    return response;

  }

  Future<List<PremiosCristal>> buscaHistoricoGanhadoresPremiosCristais() async {
    var response = await http.get(
      Uri.parse("${url}/administrador/HistoricoGanhadoresPremiosCristais"),
      headers: {"Content-Type": "application/json"},
    );


    listHistoricoGanhadoresPremiosCristais = decodeHistoricoGanhadoresPremiosCristais(response);
    _HistoricoGanhadoresPremiosCristalController.sink.add(listHistoricoGanhadoresPremiosCristais);
  }
  Future<List<PremiosCristal>> buscaHistoricoGanhadoresPremiosOfensiva() async {
    var response = await http.get(
      Uri.parse("${url}/administrador/HistoricoGanhadoresPremiosOfensiva"),
      headers: {"Content-Type": "application/json"},
    );

    print(response.body);


    listHistoricoGanhadoresPremiosOfensiva = decodeHistoricoGanhadoresPremiosOfensiva(response);
    _HistoricoGanhadoresPremiosOfensivaController.sink.add(listHistoricoGanhadoresPremiosOfensiva);
  }

  Future<List<PremiosCristal>> buscaTodosPremiosCristais() async {
    var response = await http.get(
      Uri.parse("${url}/administrador/todosPremiosCristal"),
      headers: {"Content-Type": "application/json"},
    );


    listPremiosCristals = decodePremiosCristal(response);
    _premiosCristalController.sink.add(listPremiosCristals);
  }

  Future<List<PremiosCfensiva>> buscaTodosPremiosCfensiva() async {
    var response = await http.get(
      Uri.parse("${url}/administrador/todosPremiosOfensiva"),
      headers: {"Content-Type": "application/json"},
    );


    listPremiosCfensivas = decodePremiosOfensiva(response);
    _premiosOfensivaController.sink.add(listPremiosCfensivas);
  }

  List<PremiosCristal> decodePremiosCristal(http.Response response) {
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      var decoded = json.decode(response.body);
      List<PremiosCristal> listPremiosCristais =
          decoded.map<PremiosCristal>((map) {
        return PremiosCristal.fromJson(map);
      }).toList();

      return listPremiosCristais;
    } else {
      throw Exception("Failed to load PremiosCristal");
    }
  }

  List<PremiosCfensiva> decodePremiosOfensiva(http.Response response) {
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      var decoded = json.decode(response.body);
      List<PremiosCfensiva> listPremiosCfensiva =
      decoded.map<PremiosCfensiva>((map) {
        return PremiosCfensiva.fromJson(map);
      }).toList();

      return listPremiosCfensiva;
    } else {
      throw Exception("Failed to load PremiosCfensiva");
    }
  }
  List<HistoricoGanhadoresPremiosCristais> decodeHistoricoGanhadoresPremiosCristais(http.Response response) {
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      var decoded = json.decode(response.body);
      List<HistoricoGanhadoresPremiosCristais> listGanhadoresPremiosCristais =
      decoded.map<HistoricoGanhadoresPremiosCristais>((map) {
        return HistoricoGanhadoresPremiosCristais.fromJson(map);
      }).toList();

      return listGanhadoresPremiosCristais;
    } else {
      throw Exception("Failed to load HistoricoGanhadoresPremiosCristais");
    }
  }

  List<HistoricoGanhadoresPremiosOfensiva> decodeHistoricoGanhadoresPremiosOfensiva(http.Response response) {
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      var decoded = json.decode(response.body);
      List<HistoricoGanhadoresPremiosOfensiva> listGanhadoresPremiosOfensiva =
      decoded.map<HistoricoGanhadoresPremiosOfensiva>((map) {
        return HistoricoGanhadoresPremiosOfensiva.fromJson(map);
      }).toList();

      return listGanhadoresPremiosOfensiva;
    } else {
      throw Exception("Failed to load HistoricoGanhadoresPremiosCristais");
    }
  }
}
