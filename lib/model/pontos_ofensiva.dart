class PontosOfensiva{
   int id;
   int quantidade = 0;

   PontosOfensiva({this.id, this.quantidade});

   factory PontosOfensiva.fromJson(Map<String, dynamic> json) {
     return PontosOfensiva(
         id: json["id"],
         quantidade: json["quantidade"],
     );
   }

   Map<String, dynamic> toJson() {
     return {
       "id": id,
       "quantidade": quantidade,

     };
   }

}