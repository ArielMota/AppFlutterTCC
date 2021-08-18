import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/api.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:flutter_auth/model/pontos_cristal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class PontosCristalBloc implements BlocBase {
  Api api;
  String url = Api.URL;
  bool loginSucesso;
  List<PontosCristal> pontosCristal;
  int totalPontoCristal;

  final StreamController<List<PontosCristal>> _pontosCristalController =
  StreamController<List<PontosCristal>>.broadcast();

  Stream get outPontosCristals => _pontosCristalController.stream;

  final _totalPontosCristalController = BehaviorSubject<int>();

  Stream get outTotalPontosCristals => _totalPontosCristalController.stream;

  final StreamController<bool> _concluiuOfensiva =
  StreamController<bool>.broadcast();

  Stream get outConcluiuOfensiva => _concluiuOfensiva.stream;

  PontosCristalBloc(){
    api = Api();
  }

  Future<http.Response> removePontoCristal(int index, PontosCristal pts, String token) async {

    var response = await http.delete(
        Uri.parse("${url}/admin/pontoscristal/${pts.id}"),
        headers: {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: token}
    );


    //pontosCristal.removeAt(index);
    _pontosCristalController.sink.add(pontosCristal);

    verificarStatusOkOuCreatedOfensiva(response.statusCode, pts);


    return response;



  }

  Future<http.Response> editarPontosCristal(double valor, PontosCristal pts, String token) async {
    pts.valor_pontos = valor;

    var response = await http.put(
        Uri.parse("${url}/admin/pontoscristal/"),
        headers: {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: token},
        body: jsonEncode(pts.toJson())
    );

    _pontosCristalController.sink.add(pontosCristal);


    verificarStatusOkOuCreatedOfensiva(response.statusCode, pts);

    return response;

  }


  Future<http.Response> cadastrarPontosCristal(PontosCristal pontosCristal, String token) async {
    var response = await http.post(
      Uri.parse("${url}/admin/pontoscristal/"),
      headers: {HttpHeaders.contentTypeHeader: "application/json", HttpHeaders.authorizationHeader: token},
      body: jsonEncode(pontosCristal.toJson())
    );




    verificarStatusOkOuCreatedOfensiva(response.statusCode, pontosCristal);

    return response;

  }

  Future<void> verificarStatusOkOuCreatedOfensiva(int status, PontosCristal pontosCristal) async {

    if(status == 200 || status == 201){

      http.Response responseOfensivaConcluida = await verificarOfensivaDiariaConcluida(pontosCristal.cliente.login).then((value) => value);

      int cristaisGanhosDia = await buscarTotalPontosCristalGanhosNoDiaCliente(pontosCristal.cliente.id).then((value) => value);



      if(responseOfensivaConcluida.body == "false" && cristaisGanhosDia >= 5){
        await concluirOfensivaCliente(pontosCristal.cliente.login);
        await adcionarUmPontoOfensivaCliente(pontosCristal.cliente.login);

        _concluiuOfensiva.sink.add(true);

        Fluttertoast.showToast(
            msg: "O cliente ${pontosCristal.cliente.login} completou a ofensiva diaria!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 20.0,
        );


      }else if(responseOfensivaConcluida.body == "true" && cristaisGanhosDia < 5  ){
       await cancelarOfensivaCliente(pontosCristal.cliente.login);
        await removerUmPontoOfensivaCliente(pontosCristal.cliente.login);

        _concluiuOfensiva.sink.add(false);

        Fluttertoast.showToast(
          msg: "O cliente ${pontosCristal.cliente.login} teve a ofensiva diaria cancelada!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 20.0,
        );



      }
    }


  }

  Future<void> concluirOfensivaCliente(String login) async {
    var response = await http.get(
      Uri.parse("${url}/concluir_ofensiva_diaria_concluida/${login}"),
      headers: {"Content-Type": "application/json"},
    );



  }

  Future<void> cancelarOfensivaCliente(String login) async {
    var response = await http.get(
      Uri.parse("${url}/cancelar_ofensiva_diaria_concluida/${login}"),
      headers: {"Content-Type": "application/json"},
    );


  }

  Future<void> adcionarUmPontoOfensivaCliente(String login) async {
    var response = await http.get(
      Uri.parse("${url}/adcionar_um_ponto_ofensiva_cliente/${login}"),
      headers: {"Content-Type": "application/json"},
    );

  }
  Future<void> removerUmPontoOfensivaCliente(String login) async {
    var response = await http.get(
      Uri.parse("${url}/remover_um_ponto_ofensiva_cliente/${login}"),
      headers: {"Content-Type": "application/json"},
    );

  }


    Future<int> buscarTotalPontosCristalGanhosNoDiaCliente(int id) async {
    var response = await http.get(
      Uri.parse("${url}/somapontoscristaldiario/${id}"),
      headers: {"Content-Type": "application/json"},
    );

    
    if(response.body.isNotEmpty){
      return int.parse(response.body);

    }else{
      return 0;
    }


  }

  Future<http.Response> verificarOfensivaDiariaConcluida(String login) async {

    var response = await http.get(
      Uri.parse("${url}/verificar_ofensiva_diaria_concluida/${login}"),
      headers: {"Content-Type": "application/json"},
    );

    return response;

  }



  Future<List<PontosCristal>> buscarTodosPontosCristalDoCliente(int id) async {
    var response = await http.get(
      Uri.parse("${url}/pontoscristalcliente/${id}"),
      headers: {"Content-Type": "application/json"},
    );

    pontosCristal = decodePontosCristal(response);


    _pontosCristalController.sink.add(pontosCristal);



  }


  Future<int> buscarSomaTotalPontosCristalDoCliente(int id) async {
    var response = await http.get(
      Uri.parse("${url}/somapontoscristalcliente/${id}"),
      headers: {"Content-Type": "application/json"},
    );

if(response.body.isNotEmpty){
  totalPontoCristal = int.parse(response.body);

}


    _totalPontosCristalController.sink.add(totalPontoCristal);
  }

  Future<http.Response> buscarSomaTotalPontosCristalDeTodosClientes(int id) async {
    var response = await http.get(
      Uri.parse("${url}/somapontoscristalcliente/${id}"),
      headers: {"Content-Type": "application/json"},
    );

    return response;
  }



  List<PontosCristal> decodePontosCristal(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);

      List<PontosCristal> listPontosCristal = decoded.map<PontosCristal>((map) {
        return PontosCristal.fromJson(map);
      }).toList();

      return listPontosCristal;
    } else {
      throw Exception("Failed to load pontos cristal");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pontosCristalController.close();
    _totalPontosCristalController.close();
    _concluiuOfensiva.close();
  }

  @override
  void addListener(listener) {
      // TODO: implement addListener
    }
  
    @override
    // TODO: implement hasListeners
    bool get hasListeners => throw UnimplementedError();
  
    @override
    void notifyListeners() {
      // TODO: implement notifyListeners
    }
  
    @override
    void removeListener(listener) {
    // TODO: implement removeListener
  }


}




