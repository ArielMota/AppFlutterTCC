import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/historico_de_ganhadores/components/home_top.dart';
import 'package:flutter_auth/Screens/historico_de_ganhadores/components/list_data.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/blocs/premios_bloc.dart';
import 'package:flutter_auth/model/Historico_ganhadores_premios_cristais.dart';
import 'package:flutter_auth/model/Historico_ganhadores_premios_ofensiva.dart';
import 'package:flutter_auth/model/premios_cristal.dart';
import 'package:flutter_auth/model/premios_ofensiva.dart';

import 'package:qr_flutter/qr_flutter.dart';

import '../../../constants.dart';
import 'background.dart';

class Body extends StatefulWidget {


  Body();

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // This size provide us total height and width of our screen
    return Background(
        child: Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            HomeTop(),
            StreamBuilder(
                initialData: 0,
                stream: BlocProvider.of<ClienteBloc>(context).outCategoria,
                builder: (context, snapshotPai) {
                  if (snapshotPai.data == 0) {
                    BlocProvider.of<PremiosBloc>(context)
                        .buscaHistoricoGanhadoresPremiosCristais();
                    return StreamBuilder<List<HistoricoGanhadoresPremiosCristais>>(
                      stream: BlocProvider.of<PremiosBloc>(context)
                          .outHistoricoGanhadoresPremiosCristal,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {

                          return Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {

                                  return ListData(
                                    posicao: snapshot.data[index].posicao,
                                    historicoGanhadoresPremiosCristais: snapshot.data[index],
                                    categoria: snapshotPai.data,
                                  );
                                }),
                          );
                        } else {
                          return Expanded(
                            child: Container(
                              height: 40.0,
                              width: 40.0,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    kPrimaryColor),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  } else {
                    BlocProvider.of<PremiosBloc>(context)
                        .buscaHistoricoGanhadoresPremiosOfensiva();

                    return StreamBuilder<List<HistoricoGanhadoresPremiosOfensiva>>(
                      stream: BlocProvider.of<PremiosBloc>(context)
                          .outHistoricoGanhadoresPremiosOfensiva,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return ListData(
                                    posicao: snapshot.data[index].posicao,
                                    historicoGanhadoresPremiosOfensiva: snapshot.data[index],
                                    categoria: snapshotPai.data,
                                  );
                                }),
                          );
                        } else {
                          return Expanded(
                            child: Container(
                              height: 40.0,
                              width: 40.0,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    kPrimaryColor),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }
                })
          ],
        ),
      ],
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
