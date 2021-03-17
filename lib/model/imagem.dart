import 'cliente.dart';

class Imagem {

  int id;
  String path;

  Imagem({this.id, this.path});

  factory Imagem.fromJson(Map<String, dynamic> json) {
    return Imagem(
        id: json["id"],
        path: json["path"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "path": path
    };
  }
}