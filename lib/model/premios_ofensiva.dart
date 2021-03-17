class PremiosCfensiva{
  int id;
  String title;
  String descricao;
  String urlImagem;

  PremiosCfensiva({this.id, this.title, this.descricao, this.urlImagem});

  factory PremiosCfensiva.fromJson(Map<String, dynamic> json) {
    return PremiosCfensiva(
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