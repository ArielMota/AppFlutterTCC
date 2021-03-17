import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:flutter_auth/widgets/custom_drawer_adm.dart';

import '../../constants.dart';
import 'components/body.dart';

class GerenciarPremiosScreen extends StatefulWidget {
  static const List<String> choices = <String>["Logar Como Administrador"];
  PageController pageController;



  GerenciarPremiosScreen(this.pageController);

  @override
  _GerenciarPremiosScreenState createState() => _GerenciarPremiosScreenState();
}

class _GerenciarPremiosScreenState extends State<GerenciarPremiosScreen> {
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      drawer: CustomDrawerAdm(widget.pageController),

      appBar: AppBar(
        title: Text("Gerenciar Prêmios"),
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
