import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/model/cliente.dart';

import '../../../constants.dart';
import 'category_view.dart';

class HomeTop extends StatefulWidget {
  Cliente cliente;

  final Animation<double> containerGrow;

  HomeTop({@required this.containerGrow, this.cliente});

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
          Text(
            "Bem-vindo, ${widget.cliente.login}!",
            style: TextStyle(
                fontSize: screenSize.width * 0.06, fontWeight: FontWeight.w300, color: Colors.white),
          ),
        StreamBuilder(
            stream: BlocProvider.of<ClienteBloc>(context).outClientes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Cliente> clientes = snapshot.data;
                int valor;
                for(int i = 0; i < clientes.length; i++){
                  if(clientes[i].id == widget.cliente.id){
                    valor = i + 1;
                  }
                }
                return Container(
                  padding: EdgeInsets.all(screenSize.height * 0.003),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _corTresPrimeiros(valor)
                  ),
                  width: widget.containerGrow.value * 120,
                  height: widget.containerGrow.value * 120,
                  child: Container(
                    alignment: Alignment.topRight,
                    width: widget.containerGrow.value * 120,
                    height: widget.containerGrow.value * 120,
                    decoration: BoxDecoration(
                        color: _corTresPrimeiros(valor),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("${widget.cliente.imagem.path}"),
                        )),
                    child: Container(
                      width: widget.containerGrow.value * 35,
                      height: widget.containerGrow.value * 35,
                      margin: EdgeInsets.only(left: 80),
                      alignment: Alignment.center,
                      child:  Text(
                      "${valor}º",
                      style: TextStyle(
                        fontSize: widget.containerGrow.value * 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(80, 210, 194, 1.0)),
                  ),
                ),
              );
              } else {
                return Container(
                  height: screenSize.height * 0.015,
                  width: screenSize.width * 0.03,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              }
            }),

          CategoryView()
        ],
      )),
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

