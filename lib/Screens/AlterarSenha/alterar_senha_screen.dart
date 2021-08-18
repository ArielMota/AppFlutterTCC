import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/body.dart';

class AlterarSenhaScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0.0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: kPrimaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Body(scaffoldKey: scaffoldKey,),
    );
  }
}
