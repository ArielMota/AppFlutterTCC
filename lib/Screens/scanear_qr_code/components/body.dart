import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/historico_de_cristais_adm/historico_de_cristais_screen_adm.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../constants.dart';
import 'background.dart';

class Body extends StatelessWidget {
  Cliente cliente;
  PageController pageController;


  Body(this.cliente, this.pageController);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // This size provide us total height and width of our screen
    return Background(
        child: StreamBuilder(
      stream: BlocProvider.of<ClienteBloc>(context).outScannerCliente,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HistoricoDeCristaisScreenAdm(snapshot.data, chamadoScanner: true,pageController: pageController,);
        } else {
          return Container();
        }
      },
    ));
  }
}
