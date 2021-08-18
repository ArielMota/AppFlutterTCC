import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/blocs/pontoscristal_bloc.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/model/pontos_ofensiva.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_auth/model/cliente.dart';

class ListData extends StatefulWidget {
  final String title;
  final int posicao;
  final ImageProvider image;
  final EdgeInsets margin;
  final Cliente cliente;
  Function function;
  String pontos;

  ListData(
      {this.title,
      this.posicao,
      this.image,
      this.margin,
      this.cliente,
      this.function});

  @override
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  final imgCristal = AssetImage("assets/images/perfil.jpg");

  @override
  Widget build(BuildContext context) {
    Future<String> future = widget.function();
    future.then((value) {
      widget.pontos = value;
    });

    Size size = MediaQuery.of(context).size;

    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top:
                  BorderSide(color: Colors.grey[100], width: size.width * 0.01),
              bottom: BorderSide(
                  color: Colors.grey[100], width: size.width * 0.008))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: size.height * 0.03,bottom: size.height * 0.03, left: size.width * 0.02, right: size.width * 0.02),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
              color: _corTresPrimeiros(widget.posicao)
                ),
            width: size.width * 0.16,
            height: size.height * 0.06,
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.003, bottom: size.height * 0.003, left:  size.width * 0.02, right:  size.width * 0.02),
              width: size.width * 0.18,
              height: size.height * 0.11,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: Image.asset("${widget.cliente.imagem.path}").image,
                    fit: BoxFit.scaleDown,
                  )),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("${widget.posicao}º Posição",
                  style: TextStyle(
                    fontSize: size.width * 0.035,
                    color: _corTresPrimeiros(widget.posicao),
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
                        text: widget.cliente.login,
                        style: TextStyle(
                            color: Colors.black, fontSize: size.width * 0.045),
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
                  stream:  BlocProvider.getBloc<ClienteBloc>().outCategoria,
                  initialData: 0,
                  builder: (context, snapshote){
                    if(snapshote.hasData){
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.bottomCenter,
                            width: size.width * 0.15,
                            height: size.height * 0.07,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(snapshote.data == 0 ? "assets/images/cristal.png" :"assets/images/chama.png"),
                                  fit: BoxFit.fill,
                                )),
                            child: Container(
                              width: size.width * 0.10,
                              height: size.height * 0.020,
                              alignment: Alignment.center,
                              child: FutureBuilder(
                                  future: future,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData && snapshot.data != "") {
                                      return Text(
                                        snapshote.data == 0 ? snapshot.data : "${widget.cliente.pontosOfensiva.quantidade}",
                                        style: TextStyle(
                                          fontSize: size.width * 0.03,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      );
                                    } else if (snapshot.data == "") {
                                      return Text(
                                        "0",
                                        style: TextStyle(
                                          fontSize: size.width * 0.03,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        height: size.height * 0.01,
                                        width: size.width * 0.02,
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                        ),
                                      );
                                    }
                                  }),
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5),
                                  color: kPrimaryColor),
                            ),
                          ),
                        ],
                      );
                    }else{
                      return Container(
                        height: size.height * 0.02,
                        width: size.width * 0.04,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white),
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

  Color _corTresPrimeiros(int index) {
    if (index == 1) {
      return kPrimaryColor;
    } else if (index == 2) {
      return Colors.blue;
    } else if (index == 3) {
      return Colors.pinkAccent;
    } else {
      return Colors.grey;
    }

    return Colors.lightBlue;
  }
}

