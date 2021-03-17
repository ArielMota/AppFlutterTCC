class Cristal{
  int id;
  double valorDoCristal;

  Cristal({this.id, this.valorDoCristal});

  factory Cristal.fromJson(Map<String, dynamic> json) {
    return Cristal(
        id: json["id"],
        valorDoCristal: json["valorDoCristal"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "valorDoCristal": valorDoCristal
    };
  }
}