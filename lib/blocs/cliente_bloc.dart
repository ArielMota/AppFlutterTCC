import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_auth/api.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:flutter_auth/model/pontos_cristal.dart';
import 'package:flutter_auth/model/pontos_ofensiva.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class ClienteBloc implements BlocBase {
  Api api;
  String url = Api.URL;
  bool loginSucesso;
  List<Cliente> clientes;
  List<Cliente> clientesOfensiva;
  Cliente cliente;
  PontosOfensiva pontosOfensiva;

  final StreamController<Cliente> _clienteLembrouLoginController =
  StreamController<Cliente>.broadcast();

  Stream get outclienteLembrouLogin => _clienteLembrouLoginController.stream;


  final StreamController<int> _pontosOfensivaController =
  StreamController<int>.broadcast();

  Stream get outPontosofensiva=> _pontosOfensivaController.stream;

  final StreamController<int> _categoriaController =
  StreamController<int>.broadcast();

  Stream get outCategoria=> _categoriaController.stream;


  final StreamController<List<Cliente>> _clientesController =
      StreamController<List<Cliente>>.broadcast();

  Stream get outClientes => _clientesController.stream;


  final StreamController<Cliente> _clienteScannerController =
  StreamController<Cliente>.broadcast();

  Stream get outScannerCliente => _clienteScannerController.stream;


  final StreamController<List<Cliente>> _searchClientesController =
  StreamController<List<Cliente>>.broadcast();

  Stream get outSearchClientes => _clientesController.stream;

  final StreamController<String> _searchController = StreamController<String>();

  Sink get inSearch => _searchController.sink;

  ClienteBloc() {
    api = Api();

    _searchController.stream.listen(_search);

  }

  Future<void> addClienteLembrouLogin(Cliente cli){

    _clienteLembrouLoginController.sink.add(cli);
  }



  Future<List<Cliente>> _search(String search) async {

    if(search != null){
      _searchClientesController.sink.add([]);

      http.Response response = await http.get(
          "${url}/buscar_cliente/${search}");


      clientes = decodeCliente(response);

    }
    _searchClientesController.sink.add(clientes);

    return clientes;
  }

  Future<void>  adcionarClienteScanner(Cliente cli){

    cliente = cli;
    _clienteScannerController.sink.add(cliente);
  }




  Future<void> adcionarTotalPontosOfensivaCliente(Cliente cliente){


    pontosOfensiva = cliente.pontosOfensiva;
    _pontosOfensivaController.sink.add(pontosOfensiva.quantidade);
  }



  Future<int> buscaPosicaoRankingClienteCristais(Cliente cli) async {

    var response = await http.post(
        Uri.parse("${url}/cliente/posicao_ranking_cristais"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(cli.toJson()));



    return int.parse(response.body);

  }

  void indexSelectcategoria(int index){
    _categoriaController.sink.add(index);

  }

  Future<http.Response> cadastrarCliente(Cliente cli) async {
    var response = await http.post(
        Uri.parse("${url}/cliente"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(cli.toJson()));

    return response;

  }


  Future<http.Response> autenticarCliente(Cliente cli) async {
    var response;
    try{
       response = await http.post(
          Uri.parse("${url}/cliente/autenticar"),
          headers: {"Content-Type": "application/json"},
          body: json.encode(cli.toJsonLogin()));
    }catch(e){
      return null;
    }


    return response;
  }
  Future<http.Response> RecuperarSenhaCliente(Cliente cli) async {
    var response = await http.post(
        Uri.parse("${url}/cliente/recuperar_senha"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(cli.toJsonRecuperarSenha()));




    return response;
  }

  Future<List<Cliente>> buscarTodosClientes() async {
    var response = await http.get(
      Uri.parse("${url}/cliente"),
      headers: {"Content-Type": "application/json"},
    );

    clientes = decodeCliente(response);
    _clientesController.sink.add(clientes);


  }
  Future<List<Cliente>> buscarTodosClientesPorOfensiva() async {
    var response = await http.get(
      Uri.parse("${url}/clienteOfensiva"),
      headers: {"Content-Type": "application/json"},
    );

    clientes = decodeCliente(response);
    _clientesController.sink.add(clientes);

  }


  Future<Cliente> buscarExistenciaClientes(String login) async {
    var response = await http.get(
      Uri.parse("${url}/cliente_existe/${login}"),
      headers: {"Content-Type": "application/json", "charset":"utf-8"},
    );

    String body = utf8.decode(response.bodyBytes);

    print(response.body);

    Cliente cli = Cliente.fromJson(json.decode(body));
    return cli;
  }

  List<Cliente> decodeCliente(http.Response response) {



    if (response.statusCode == 200  && response.body.isNotEmpty) {

      var decoded = json.decode(response.body);
      List<Cliente> clientes = decoded.map<Cliente>((map) {
        return Cliente.fromJson(map);
      }).toList();


      return clientes;
    } else {
      throw Exception("Failed to load clientes");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _clientesController.close();
    _clienteLembrouLoginController.close();
    _categoriaController.close();
    _searchController.close();
    _searchClientesController.close();
    _clienteScannerController.close();
    _pontosOfensivaController.close();

  }
}
