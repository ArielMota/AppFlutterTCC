import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Screens/Splash/components/background.dart';
import 'package:flutter_auth/Screens/home/home_screen.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import 'components/body.dart';



class SplashScreen extends StatefulWidget {
  static const List<String> choices = <String>["Logar Como Administrador"];

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  
  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: Body(),

    );




  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
