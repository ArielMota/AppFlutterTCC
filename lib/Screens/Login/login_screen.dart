import 'package:flutter/material.dart';

import 'components/body.dart';

class LoginScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  LoginScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body:  Body(scaffoldKey: _scaffoldKey,),
    );
  }
}
