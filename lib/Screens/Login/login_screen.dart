import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/components/bodyComoAdm.dart';

import 'components/body.dart';

class LoginScreen extends StatelessWidget {
  bool logarComoAdm = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  LoginScreen({this.logarComoAdm : false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: logarComoAdm ? BodyComoAdm(scaffoldKey: _scaffoldKey) : Body(scaffoldKey: _scaffoldKey,),
    );
  }
}
