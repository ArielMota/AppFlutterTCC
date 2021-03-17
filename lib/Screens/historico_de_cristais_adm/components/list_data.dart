import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/blocs/pontoscristal_bloc.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/model/pontos_cristal.dart';
import 'package:flutter_auth/model/pontos_ofensiva.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_auth/model/cliente.dart';

class ListData extends StatefulWidget {
  PontosCristal pontosCristal;

  String dia = "00/00";
  String mes = "00/00";



  ListData({this.pontosCristal});

  @override
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  final imgCristal = AssetImage("assets/images/perfil.jpg");



  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    widget.dia = "${widget.pontosCristal.data[8]}${widget.pontosCristal.data[9]}";
    widget.mes = "${widget.pontosCristal.data[5]}${widget.pontosCristal.data[6]}";


    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top:
                  BorderSide(color: kPrimaryLightColor, width: size.width * 0.01),
              bottom: BorderSide(
                  color: kPrimaryLightColor, width: size.width * 0.005))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: kPrimaryLightColor),
            width: size.width * 0.15,
            height: size.height * 0.15,
            child: Container(
              margin: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
              width: size.width * 0.15,
              height: size.height * 0.15,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: GoogleFonts.amethysta(
                        textStyle: Theme.of(context).textTheme.display1,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: " ${widget.dia}/${widget.mes}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.040),
                        )
                      ]),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Ganhou:",
                  style: TextStyle(
                    fontSize: size.width * 0.035,
                    fontWeight: FontWeight.w300,
                  )),
              SizedBox(
                height: size.height * 0.015,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: GoogleFonts.portLligatSans(
                      textStyle: Theme.of(context).textTheme.display1,
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                    children: [
                      TextSpan(
                        text: "+ ${widget.pontosCristal.valor_pontos.toStringAsPrecision(2)}",
                        style: TextStyle(
                            color: kPrimaryColor, fontSize: size.width * 0.060),
                      ),
                      TextSpan(
                        text: " CRISTAIS",
                        style: TextStyle(
                            color: Colors.blue, fontSize: size.width * 0.050),
                      )
                    ]),
              ),
            ],
          ),
          SizedBox(
            width: size.width * 0.075,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(4),
              child: StreamBuilder(
                  stream: BlocProvider.of<ClienteBloc>(context).outCategoria,
                  initialData: 0,
                  builder: (context, snapshote) {
                    if (snapshote.hasData) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: size.width * 0.03),
                            alignment: Alignment.bottomCenter,
                            width: size.width * 0.15,
                            height: size.height * 0.07,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage("assets/images/cristal.png"),
                              fit: BoxFit.fill,
                            )),
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        height: size.height * 0.02,
                        width: size.width * 0.04,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}
