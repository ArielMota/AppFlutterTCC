import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Screens/home/home_screen.dart';
import 'package:flutter_auth/blocs/administrador_bloc.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import 'components/body.dart';



class WelcomeScreen extends StatefulWidget {
  static const List<String> choices = <String>["Logar Como Administrador"];

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  
  @override
  Widget build(BuildContext context) {


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

    return WillPopScope(

      onWillPop: (){},
      child: Scaffold(
        extendBodyBehindAppBar: true,


        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              margin: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(20)),
              child: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.person,
                    color: kPrimaryColor,
                  ),
                  onSelected: _choiceAction,
                  itemBuilder: (context) {
                    return WelcomeScreen.choices.map((String choice) {
                      return PopupMenuItem(
                          value: choice,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                choice,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: kPrimaryColor),
                              ),
                              Icon(Icons.input, color: kPrimaryColor,)
                            ],
                          ));
                    }).toList();
                  }),
            )
          ],
        ),
        body: Body(),
      ),
    );

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

}
