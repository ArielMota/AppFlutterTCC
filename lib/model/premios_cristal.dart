class PremiosCristal{
  int id;
  String title;
  String descricao;
  String urlImagem;

  PremiosCristal({this.id, this.title, this.descricao, this.urlImagem});

  factory PremiosCristal.fromJson(Map<String, dynamic> json) {
    return PremiosCristal(
        id: json["id"],
        title: json["title"],
        descricao: json["descricao"],
        urlImagem:  json["urlImagem"]
    );

  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "descricao": descricao,
      "urlImagem": urlImagem
    };
  }
}