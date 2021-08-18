import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/blocs/pontoscristal_bloc.dart';
import 'package:flutter_auth/model/cliente.dart';

import '../../constants.dart';
import 'components/body.dart';

class HistoricoDeCristaisScreenAdm extends StatefulWidget {
  static const List<String> choices = <String>["Logar Como Administrador"];
  Cliente cliente;
  bool chamadoScanner;
  PageController pageController;

  HistoricoDeCristaisScreenAdm(this.cliente,
      {this.chamadoScanner: false, this.pageController});

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _HistoricoDeCristaisScreenAdmState createState() =>
      _HistoricoDeCristaisScreenAdmState();
}

class _HistoricoDeCristaisScreenAdmState
    extends State<HistoricoDeCristaisScreenAdm> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.getBloc<ClienteBloc>().buscarTodosClientes();
    BlocProvider.getBloc<PontosCristalBloc>()
        .buscarTodosPontosCristalDoCliente(widget.cliente.id);

    void _choiceAction(String action) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen(
            );
          },
        ),
      );
    }

    if (widget.chamadoScanner == false) {
      return Body(
        widget.cliente,
        chamadoScanner: widget.chamadoScanner,
      );
    } else {
      return Body(
        widget.cliente,
        pageController: widget.pageController,
        chamadoScanner: widget.chamadoScanner,
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
