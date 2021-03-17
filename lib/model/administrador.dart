class Administrador {
  int id;
  String nome;
  String login;
  String senha;

  Administrador({this.id, this.nome, this.login, this.senha});

  factory Administrador.fromJson(Map<String, dynamic> json) {
    return Administrador(
      id: json["id"],
      nome: json["nome"],
      senha: json["senha"],
      login: json["login"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nome": nome,
      "senha": senha,
      "login": login,
    };
  }
}
