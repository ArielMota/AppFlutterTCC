import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/blocs/pontoscristal_bloc.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:google_fonts/google_fonts.dart';
import 'list_data.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  Cliente cliente;

  Body(this.cliente);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    // This size provide us total height and width of our screen
    return Column(
      children: [
        Container(
            alignment: Alignment.topCenter,
            height: screenSize.height * 0.3,
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
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                ),
                StreamBuilder(
                    stream: BlocProvider.getBloc<ClienteBloc>().outClientes,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Cliente> clientes = snapshot.data;
                        int valor;
                        for (int i = 0; i < clientes.length; i++) {
                          if (clientes[i].id == widget.cliente.id) {
                            valor = i + 1;
                          }
                        }
                        return Container(
                          margin: EdgeInsets.only(
                              top: 5, bottom: 5, left: 15, right: 15),
                          padding: EdgeInsets.all(screenSize.height * 0.003),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _corTresPrimeiros(valor)),
                          width: screenSize.width * 0.35,
                          height: screenSize.height * 0.15,
                          child: Container(
                            alignment: Alignment.topRight,
                            width: screenSize.width * 0.4,
                            height: screenSize.height * 0.3,
                            decoration: BoxDecoration(
                                color: _corTresPrimeiros(valor),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                      "${widget.cliente.imagem.path}"),
                                )),
                            child: Container(
                              width: screenSize.width * 0.07,
                              height: screenSize.height * 0.07,
                              margin: EdgeInsets.only(left: 80),
                              alignment: Alignment.center,
                              child: Text(
                                "${valor}º",
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.03,
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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        );
                      }
                    }),
              ],
            ))),
        StreamBuilder<List>(
          //     initialData: [],
          stream: BlocProvider.getBloc<PontosCristalBloc>().outPontosCristals,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.isNotEmpty) {
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: reloadListCristais,
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return ListData(
                            pontosCristal: snapshot.data[index],
                          );
                        }),
                  ),
                );
              } else {
                return Expanded(
                    child: Center(
                        child: _ListaCristaisVazia(context, screenSize.width)));
              }
            } else {
              return Expanded(
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                  ),
                ),
              );
            }
          },
        )
      ],
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

  Widget _ListaCristaisVazia(BuildContext context, double fonteSize) {
    return SafeArea(
      child: RichText(
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
                text: 'Histórico de cristais vazio!',
                style:
                    TextStyle(color: kPrimaryColor, fontSize: fonteSize * 0.05),
              ),
            ]),
      ),
    );
  }

  Future<void> reloadListCristais() async {
    await Future.delayed(Duration(seconds: 2), () {
      BlocProvider.getBloc<ClienteBloc>().buscarTodosClientes();
      BlocProvider.getBloc<PontosCristalBloc>()
          .buscarTodosPontosCristalDoCliente(widget.cliente.id);
    });
  }
}
