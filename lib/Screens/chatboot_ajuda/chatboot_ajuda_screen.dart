import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:flutter_auth/widgets/custom_drawer.dart';

import '../../constants.dart';
import 'components/body.dart';

class ChatBootAjuda extends StatefulWidget {
  static const List<String> choices = <String>["Logar Como Administrador"];
  PageController pageController;
  Cliente cliente;

  ChatBootAjuda(this.pageController, this.cliente);

  @override
  _ChatBootAjudaState createState() => _ChatBootAjudaState();
}

class _ChatBootAjudaState extends State<ChatBootAjuda> {
  @override
  Widget build(BuildContext context) {

    void _choiceAction(String action) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ),
      );
    }

    return Scaffold(
      drawer: CustomDrawer(widget.pageController, widget.cliente),

      appBar: AppBar(
        title: Text("Atendimento - ChatBot"),
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
