import 'cliente.dart';

class HistoricoGanhadoresPremiosCristais{

  int id;
  String data;
  Cliente cliente;
  String title;
  String descricao;
  int posicao;
  String urlImagem;
  bool premioResgatado;
  int valorTotalCristal;

  HistoricoGanhadoresPremiosCristais({int id, String data, Cliente cliente, String title, String descricao, int posicao, String urlImagem, bool premioResgatado, int valorTotalCristal}) {


    this.id = id;
    this.data = data;
    this.cliente = cliente;
    this.title = title;
    this.descricao = descricao;
    this.posicao = posicao;
    this.urlImagem = urlImagem;
    this.premioResgatado = premioResgatado;
    this.valorTotalCristal = valorTotalCristal;
  }

  factory HistoricoGanhadoresPremiosCristais.fromJson(Map<String, dynamic> json) {
    return HistoricoGanhadoresPremiosCristais(
        id: json["id"],
        data : json["data"],
        cliente : Cliente.fromJson(json["cliente"]),
        title: json["title"],
        descricao: json["descricao"],
        posicao: json["posicao"],
        urlImagem: json["urlImagem"],
        premioResgatado: json["premioResgatado"],
        valorTotalCristal: json["valorTotalCristais"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
     "data": data,
      "cliente" : cliente,
      "title": title,
      "descricao": descricao,
      "posicao": posicao,
      "urlImagem" : urlImagem,
      "premioResgatado": premioResgatado,
      "valorTotalCristais": valorTotalCristal
    };
  }


}