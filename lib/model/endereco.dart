class Endereco {
  int id;
  String rua;
  int numero;
  String setor;
  String complemento;


  Endereco({this.id, this.rua, this.numero, this.setor, this.complemento});

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      id: json["id"],
      rua: json["rua"],
      numero: json["numero"],
      setor: json["setor"],
      complemento: json["complemento"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "rua": rua,
      "numero": numero,
      "setor": setor,
      "complemento": complemento
    };
  }

  }