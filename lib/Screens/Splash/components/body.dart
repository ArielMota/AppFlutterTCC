import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Login/verifica_login_salvado.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_svg/svg.dart';


import '../../../constants.dart';
import 'background.dart';


class Body extends StatefulWidget {


  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    Future.delayed(Duration(seconds: 5)).then((value){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => VerificaLoginSalvado() ));
    });

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen


    return Background(child:
    Container(
      width: size.width * 0.25,

        child: FlareActor("assets/images/donuts.flr", animation: "spin1",alignment:Alignment.center, ))
    );
  }
}
