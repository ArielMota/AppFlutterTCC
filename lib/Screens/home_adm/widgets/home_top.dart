import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/model/cliente.dart';

import 'category_view.dart';

class HomeTop extends StatefulWidget {

  final Animation<double> containerGrow;

  HomeTop({@required this.containerGrow});

  @override
  _HomeTopState createState() => _HomeTopState();
}

class _HomeTopState extends State<HomeTop> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height * 0.35,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover),
      ),
      child: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            width: widget.containerGrow.value * 120,
            height: widget.containerGrow.value * 120,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: AssetImage("assets/images/ranking.png"),
                  fit: BoxFit.cover,
                )),

          ),
          CategoryView()
        ],
      )),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }
}
