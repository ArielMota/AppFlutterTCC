import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';

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
            return LoginScreen();
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
