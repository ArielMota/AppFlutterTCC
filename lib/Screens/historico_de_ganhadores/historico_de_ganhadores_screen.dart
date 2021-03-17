import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:flutter_auth/widgets/custom_drawer_adm.dart';

import '../../constants.dart';
import 'components/body.dart';

class HistoricoDeGanhadoresScreen extends StatefulWidget {
  static const List<String> choices = <String>["Logar Como Administrador"];
  PageController pageController;



  HistoricoDeGanhadoresScreen(this.pageController);

  @override
  _HistoricoDeGanhadoresScreenState createState() => _HistoricoDeGanhadoresScreenState();
}

class _HistoricoDeGanhadoresScreenState extends State<HistoricoDeGanhadoresScreen> {
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      drawer: CustomDrawerAdm(widget.pageController),

      appBar: AppBar(
        title: Text("Historico de Ganhadores"),
        centerTitle: true,

      ),
      body: Body(),
    );

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
