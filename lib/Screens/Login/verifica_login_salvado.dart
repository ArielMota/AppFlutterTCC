import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Splash/splash_screen.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/Screens/home/home_screen.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/blocs/pontoscristal_bloc.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class VerificaLoginSalvado extends StatefulWidget {

  @override
  _VerificaLoginSalvadoState createState() => _VerificaLoginSalvadoState();
}

class _VerificaLoginSalvadoState extends State<VerificaLoginSalvado> {
  bool isLoggedIn;
  Cliente cli;

  Future<bool> getLoginState() async {
    SharedPreferences pf = await SharedPreferences.getInstance();
    bool loginState = pf.getBool('loginState') ?? false;
    String login = pf.getString('login') ?? null ;

    if(loginState == true && login != null){
      cli = await BlocProvider.of<ClienteBloc>(context)
          .buscarExistenciaClientes(login)
          .then((value) {
        return value;
      });
    }

    print(loginState);

    return loginState;
    // return pf.commit();
  }

  @override
  Widget build(BuildContext context) {


    return FutureBuilder<bool>(
      future: getLoginState(),
      initialData: false,
      builder: (context,snapshot) {

        if(snapshot.data == true){
          BlocProvider.of<PontosCristalBloc>(context)
              .buscarSomaTotalPontosCristalDoCliente(cli.id);
          return HomeScreen(cliente: cli,);
        }else if (!snapshot.hasData && cli != null){
          return Expanded(
            child: Container(
              height: 40.0,
              width: 40.0,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            ),
          );

        }else{
          return WelcomeScreen();

        }
    },

    );

  }
}
