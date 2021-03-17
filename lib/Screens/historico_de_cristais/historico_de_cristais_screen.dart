import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/blocs/pontoscristal_bloc.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:flutter_auth/widgets/custom_drawer.dart';

import '../../constants.dart';
import 'components/body.dart';

class HistoricoDeCristaisScreen extends StatefulWidget {
  static const List<String> choices = <String>["Logar Como Administrador"];
  PageController pageController;
  Cliente cliente;

  HistoricoDeCristaisScreen(this.pageController, this.cliente);

  @override
  _HistoricoDeCristaisScreenState createState() => _HistoricoDeCristaisScreenState();
}

class _HistoricoDeCristaisScreenState extends State<HistoricoDeCristaisScreen> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ClienteBloc>(context).buscarTodosClientes();
    BlocProvider.of<PontosCristalBloc>(context).buscarTodosPontosCristalDoCliente(widget.cliente.id);



    void _choiceAction(String action) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen(logarComoAdm: true,);
          },
        ),
      );
    }

    return Scaffold(
      drawer: CustomDrawer(widget.pageController, widget.cliente),

      appBar: AppBar(
        title: Text("Historico de Cristais"),
        centerTitle: true,

      ),
      body: Body(widget.cliente),
    );

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
