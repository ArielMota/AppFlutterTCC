import 'cliente.dart';

class HistoricoGanhadoresPremiosOfensiva {
  int id;
  String data;
  Cliente cliente;
  String title;
  String descricao;
  int posicao;
  String urlImagem;
  bool premioResgatado;
  int valorTotalOfensiva;

   HistoricoGanhadoresPremiosOfensiva({int id, String data, Cliente cliente, String title, String descricao, int posicao, String urlImagem, bool premioResgatado, int valorTotalOfensiva}) {

     this.id = id;
    this.data = data;
    this.cliente = cliente;
    this.title = title;
    this.descricao = descricao;
    this.posicao = posicao;
    this.urlImagem = urlImagem;
    this.premioResgatado = premioResgatado;
    this.valorTotalOfensiva = valorTotalOfensiva;
  }

  factory HistoricoGanhadoresPremiosOfensiva.fromJson(Map<String, dynamic> json) {
    return HistoricoGanhadoresPremiosOfensiva(
        id: json["id"],
        data : json["data"],
        cliente : Cliente.fromJson(json["cliente"]),
        title: json["title"],
        descricao: json["descricao"],
        posicao: json["posicao"],
        urlImagem: json["urlImagem"],
        premioResgatado: json["premioResgatado"],
        valorTotalOfensiva: json["valorTotalOfensiva"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "data": data,
      "cliente": cliente,
      "title": title,
      "descricao": descricao,
      "posicao": posicao,
      "urlImagem": urlImagem,
      "premioResgatado": premioResgatado,
      "valorTotalOfensiva": valorTotalOfensiva
    };
  }
}
