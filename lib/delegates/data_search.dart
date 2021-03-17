import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/historico_de_cristais/historico_de_cristais_screen.dart';
import 'package:flutter_auth/api.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/blocs/pontoscristal_bloc.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'list_data_search.dart';

class DataSearch extends SearchDelegate<String> {
  String url = Api.URL;
  bool sugestaoSelecionada = false;
  Cliente cliente;


  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => "Buscar Cliente";

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
            //BlocProvider.of<ClienteBloc>(context).zerarSearchListClientes();
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration.zero).then((_) => close(context, query));
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    } else {
      return FutureBuilder<List>(
        future: suggestions(query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  List<Cliente> listCliente = snapshot.data;
                  Cliente cli = listCliente[index];

                  return  ListData(
                    title: "Funcionou",
                    image: AssetImage("assets/images/perfil.jpg"),
                    cliente: snapshot.data[index],
                    function: () async {
                      Cliente cli = snapshot.data[index];
                      http.Response body = await BlocProvider.of<PontosCristalBloc>(context).buscarSomaTotalPontosCristalDeTodosClientes(cli.id).then((value){
                        return value;
                      });
                      return body.body;
                    },

                  );
                });
          }
        },
      );
    }
  }

  Future<List<Cliente>> suggestions(String search) async {
    http.Response response =
        await http.get("${url}/sugestao_login_cliente/${search}");


    if (response.statusCode == 200) {
      return json.decode(response.body).map<Cliente>((v) {
        return Cliente.fromJson(v);
      }).toList();
    } else {
      throw Exception("Failed to load suggestions");
    }
  }
}
