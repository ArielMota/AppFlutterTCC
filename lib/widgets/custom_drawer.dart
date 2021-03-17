import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/editar_cliente/editar_cliente_screen.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:flutter_auth/tiles/drawer_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;
  Cliente cliente;

  CustomDrawer(this.pageController, this.cliente);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    Widget _buildBodyBack() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 200, 180, 241),
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        );

    return Drawer(
      child: Stack(
        children: [
          _buildBodyBack(),
          Positioned(
              top: screenSize.height * 0.01,
              left: screenSize.width * 0.02,
              child: SafeArea(
                  child: Text(
                "Usuario:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ))),
          Positioned(
              top: screenSize.height * 0.025,
              left: screenSize.width * 0.02,
              child: SafeArea(
                  child: Text(
                "@${cliente.login}",
                style: TextStyle(color: kPrimaryColor),
              ))),

          ListView(
            padding: EdgeInsets.only(
                left: screenSize.width * 0.05, top: screenSize.height * 0.01, right: screenSize.width * 0.05,),
            children: [

              Container(
                  margin: EdgeInsets.only(bottom: 4.0, top: 4.0),
                  height: 170.0,
                  child: SafeArea(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage("${cliente.imagem.path}"),
                              )),
                        ),
                      ),
                    ],
                  ))),
              FlatButton(color: kPrimaryColor,onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditarClienteScreen(cliente)));
              },
                child: Text("Editar Perfil", style: TextStyle(color: Colors.white),),),
              Divider(),
              DrawerTile(Icons.home, "Início", pageController, 0),
              DrawerTile(Icons.apps, "Gerar QR Code", pageController, 1),
              DrawerTile(Icons.auto_awesome, "Histórico de Cristais",
                  pageController, 2),
              DrawerTile(Icons.chat, "Dúvidas?", pageController, 3),
              GestureDetector(
                onTap: () async {


                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: DrawerTile(Icons.exit_to_app, "Sair", pageController, 4),
              ),
            ],
          )
        ],
      ),
    );
  }
}
