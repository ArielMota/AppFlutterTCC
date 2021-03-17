import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/administrador_bloc.dart';
import 'package:flutter_auth/model/cristal.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_top.png",
              width: size.width * 0.3,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "assets/images/main_bottom.png",
              width: size.width * 0.2,
            ),
          ),
          Positioned(
            bottom: 0,
            child: _valorCristal(context, size.width, size)
          ),

          child,
        ],
      ),
    );
  }

  Widget _valorCristal(BuildContext context, double fonteSize, final screenSize) {
    return  FutureBuilder<Cristal>(
      future: BlocProvider.of<AdministradorBloc>(context).buscarValorDoCristal(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Column(
            children: [
            RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style: GoogleFonts.portLligatSans(
                  textStyle: Theme.of(context).textTheme.display1,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                ),
                children: [
                  TextSpan(
                    text: '1 Cristal = ',
                    style: TextStyle(color: Colors.blue, fontSize: screenSize.width * 0.04),
                  ),
                  TextSpan(
                    text: 'R\$ ${snapshot.data.valorDoCristal.toStringAsPrecision(3).replaceFirst(".", ",")}',
                    style: TextStyle(color: kPrimaryColor, fontSize: screenSize.width * 0.04),
                  ),
                ]),
          ),

            ],
          );
        }else{
          return Container();
        }
      },
    );

  }
}
