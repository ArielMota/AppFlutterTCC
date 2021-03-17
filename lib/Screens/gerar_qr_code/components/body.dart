import 'package:flutter/material.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:qr_flutter/qr_flutter.dart';


import '../../../constants.dart';
import 'background.dart';


class Body extends StatelessWidget {
  Cliente cliente;
  Body(this.cliente);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // This size provide us total height and width of our screen
    return Background(
      child: Container(

        child: QrImage(
            size: size.width * 0.85,version: 1,
            data: "${cliente.login}"),

      )
    );
  }
}
