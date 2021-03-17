import 'package:flutter/cupertino.dart';
import 'package:flutter_auth/model/pontos_cristal.dart';
import 'package:flutter_auth/model/pontos_ofensiva.dart';

import 'endereco.dart';
import 'imagem.dart';

class Cliente {
  int id;
  Imagem imagem;
  String nome;
  String senha;
  String login;
  String telefone;
  String sexo;
  String cpf;
  Endereco endereco;
  List<PontosCristal> pontocristal;
  PontosOfensiva pontosOfensiva;
  String nome_do_melhor_amigo_de_infancia;
  String genero_de_filme_preferido;
  String nome_do_primeiro_cachorro;
  bool ofensiva_diaria_concluida;

  Cliente(
      {this.id,
      this.imagem,
      this.nome,
      this.senha,
      this.login,
      this.telefone,
      this.sexo,
      this.cpf,
      this.endereco,
      this.pontocristal,
      this.pontosOfensiva,
      this.nome_do_melhor_amigo_de_infancia,
      this.genero_de_filme_preferido,
      this.nome_do_primeiro_cachorro,
      this.ofensiva_diaria_concluida});

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
        id: json["id"],
        imagem: Imagem.fromJson(json["imagem"]),
        nome: json["nome"],
        senha: json["senha"],
        login: json["login"],
        telefone: json["telefone"],
        sexo: json["sexo"],
        cpf: json["cpf"],
        endereco: Endereco.fromJson(json["endereco"]),
        pontosOfensiva: PontosOfensiva.fromJson(json["pontosOfensiva"]),
        nome_do_melhor_amigo_de_infancia:
            json["nome_do_melhor_amigo_de_infancia"],
        genero_de_filme_preferido: json["genero_de_filme_preferido"],
        nome_do_primeiro_cachorro: json["nome_do_primeiro_cachorro"],
        ofensiva_diaria_concluida: json["ofensiva_diaria_concluida"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "imagem": imagem.toJson(),
      "nome": nome,
      "senha": senha,
      "login": login,
      "telefone": telefone,
      "sexo": sexo,
      "cpf": cpf,
      "pontosOfensiva": pontosOfensiva.toJson(),
      "endereco": endereco.toJson(),
      "nome_do_melhor_amigo_de_infancia": nome_do_melhor_amigo_de_infancia,
      "genero_de_filme_preferido": genero_de_filme_preferido,
      "nome_do_primeiro_cachorro": nome_do_primeiro_cachorro,
      "ofensiva_diaria_concluida": ofensiva_diaria_concluida
    };
  }

  Map<String, dynamic> toJsonLogin() {
    return {
      "senha": senha,
      "login": login,
    };
  }

  Map<String, dynamic> toJsonRecuperarSenha() {
    return {
      "login": login,
      "nome_do_melhor_amigo_de_infancia": nome_do_melhor_amigo_de_infancia,
      "genero_de_filme_preferido": genero_de_filme_preferido,
      "nome_do_primeiro_cachorro": nome_do_primeiro_cachorro,
      "senha": senha
    };
  }
}
