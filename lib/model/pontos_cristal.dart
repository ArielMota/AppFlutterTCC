import 'cliente.dart';

class PontosCristal{
   int id;
   String data;
   double valor_pontos;
   Cliente cliente;


   PontosCristal({this.id, this.data, this.valor_pontos, this.cliente});

   factory PontosCristal.fromJson(Map<String, dynamic> json) {
      return PontosCristal(
          id: json["id"],
          data: json["data"],
          valor_pontos: json["valor_pontos"],
          cliente: Cliente.fromJson(json["cliente"])
      );
   }

   Map<String, dynamic> toJson() {
      return {
         "id": id,
         "data": data,
         "valor_pontos": valor_pontos,
         "cliente": cliente,
      };
   }

}