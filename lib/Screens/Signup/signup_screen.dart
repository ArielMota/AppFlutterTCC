import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/body.dart';

class SignUpScreen extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,


      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0.0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: kPrimaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Body(scaffoldKey),
    );
  }
}
