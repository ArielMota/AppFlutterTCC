import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_auth/api.dart';
import 'package:flutter_auth/model/administrador.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:flutter_auth/model/cristal.dart';
import 'package:flutter_auth/model/pontos_cristal.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class AdministradorBloc implements BlocBase {
  Api api;
  String url = Api.URL;
  bool loginSucesso;
  List<Cliente> clientes;
  String token;
  List<Cristal> cristais;

  final StreamController<Cristal> _cristalValorController =
      StreamController<Cristal>.broadcast();

  Stream get outCristalValor => _cristalValorController.stream;

  AdministradorBloc() {
    api = Api();
  }

  Future<Cristal> buscarValorDoCristal() async {
    var response = await http.get(
      Uri.parse("${url}/administrador/buscarValorDoCristal"),
      headers: {"Content-Type": "application/json"},
    );


    cristais = decodeCristal(response);

    _cristalValorController.sink.add(cristais.first);

    return cristais.first;
  }

  Future<http.Response> editarValorDoCristal(Cristal cristal) async {
    var response = await http.post(
        Uri.parse("${url}/administrador/admin/editarValorDoCristal"),
        headers: {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: token},
        body: json.encode(cristal.toJson()));

    print(response.body);

    _cristalValorController.sink.add(cristal);
    await buscarValorDoCristal();

    return response;
  }

  Future<http.Response> autenticarAdministrador(
      Administrador administrador) async {
    var response = await http.post(Uri.parse("${url}/administrador/autenticar"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(administrador.toJson()));

    if (response.statusCode == 200) {
      token = response.headers["authorization"];

     await buscarValorDoCristal();
    }

    print(response.statusCode);
    return response;
  }

  List<Cristal> decodeCristal(http.Response response) {
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      var decoded = json.decode(response.body);
      List<Cristal> list_cristal = decoded.map<Cristal>((map) {
        return Cristal.fromJson(map);
      }).toList();

      return list_cristal;
    } else {
      throw Exception("Failed to load cristal");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _cristalValorController.close();
  }
}
