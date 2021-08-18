import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_auth/Screens/chatboot_ajuda/chatboot_ajuda_screen.dart';
import 'package:flutter_auth/Screens/gerar_qr_code/gerar_qr_code_screen.dart';
import 'package:flutter_auth/Screens/historico_de_cristais/historico_de_cristais_screen.dart';
import 'package:flutter_auth/Screens/home/widgets/list_data_premios.dart';
import 'package:flutter_auth/Screens/home/widgets/stagger_animation.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/blocs/pontoscristal_bloc.dart';
import 'package:flutter_auth/blocs/premios_bloc.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:flutter_auth/model/premios_cristal.dart';
import 'package:flutter_auth/model/premios_ofensiva.dart';
import 'package:flutter_auth/widgets/custom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  Cliente cliente;
  String login;

  int categoria;

  HomeScreen({this.cliente, this.login});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();


    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));

    _controller.forward();


  }




  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    timeDilation = 1;

    return WillPopScope(
      onWillPop: () {},
      child: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: kPrimaryColor,
              child: Icon(Icons.card_giftcard),
              onPressed: () {
                if (widget.categoria == 0) {
                  BlocProvider.getBloc<PremiosBloc>()
                      .buscaTodosPremiosCristais();
                  _showDialogPremioCristal(context);
                }else{
                  BlocProvider.getBloc<PremiosBloc>()
                      .buscaTodosPremiosCfensiva();
                  _showDialogPremioOfensiva(context);
                }
              },
            ),
            drawer: CustomDrawer(_pageController, widget.cliente),
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              elevation: 0.0,
              actions: [
                StreamBuilder(
                    stream: BlocProvider.getBloc<ClienteBloc>().outCategoria,
                    initialData: 0,
                    builder: (context, snapshot1) {
                      if (snapshot1.hasData) {
                        widget.categoria = snapshot1.data;
                        if (snapshot1.data == 0) {
                          return Row(
                            children: [
                              Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Text("Cristais:")),
                              Container(
                                  alignment: Alignment.bottomCenter,
                                  width: size.width * 0.15,
                                  height: size.height * 0.07,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/cristal.png"),
                                    fit: BoxFit.fill,
                                  )),
                                  child: StreamBuilder(
                                    stream: BlocProvider.getBloc<PontosCristalBloc>(
                                            )
                                        .outTotalPontosCristals,
                                    builder: (context, snapshot2) {
                                      if (snapshot2.hasData) {
                                        return Container(
                                          width: size.width * 0.09,
                                          height: size.height * 0.020,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "${snapshot2.data}",
                                            style: TextStyle(
                                              fontSize: size.width * 0.03,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.lightBlue),
                                        );
                                      } else {
                                        return Container(
                                          width: size.width * 0.09,
                                          height: size.height * 0.020,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "0",
                                            style: TextStyle(
                                              fontSize: size.width * 0.03,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.lightBlue),
                                        );
                                      }
                                    },
                                  )),
                            ],
                          );
                        } else {
                          BlocProvider.getBloc<ClienteBloc>()
                              .buscarTodosClientesPorOfensiva();

                          return Row(
                            children: [
                              Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Text("Ofensivas:")),
                              Container(
                                  alignment: Alignment.bottomCenter,
                                  width: size.width * 0.15,
                                  height: size.height * 0.07,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/chama.png"),
                                    fit: BoxFit.fill,
                                  )),
                                  child: StreamBuilder<List<Cliente>>(
                                    initialData: [],
                                    stream:
                                        BlocProvider.
                                        getBloc<ClienteBloc>()
                                            .outClientes,
                                    builder: (context, snapshot3) {
                                      if (snapshot3.hasData) {
                                        List<Cliente> clientes = snapshot3.data;

                                        clientes.forEach((element) {
                                          if (widget.cliente.id == element.id) {
                                            widget.cliente = element;
                                          }
                                        });

                                        return Container(
                                          width: size.width * 0.09,
                                          height: size.height * 0.020,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "${widget.cliente.pontosOfensiva.quantidade}",
                                            style: TextStyle(
                                              fontSize: size.width * 0.03,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.lightBlue),
                                        );
                                      } else {
                                        return Container(
                                          width: size.width * 0.09,
                                          height: size.height * 0.020,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "0",
                                            style: TextStyle(
                                              fontSize: size.width * 0.03,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.lightBlue),
                                        );
                                      }
                                    },
                                  )),
                            ],
                          );
                        }
                      } else {
                        return Container();
                      }
                    })
              ],
            ),
            body: StaggerAnimation(
              controller: _controller.view,
              cliente: widget.cliente,
            ),
          ),
          GerarQrCodeScreen(_pageController, widget.cliente),
          HistoricoDeCristaisScreen(_pageController, widget.cliente),
          ChatBootAjuda(_pageController, widget.cliente)

        ],
      ),
    );
  }

  void _showDialogPremioCristal(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(screenSize.width * 0.04))),
          contentPadding: EdgeInsets.only(top: 0.0),
          content: Container(
            width: screenSize.width * 1,
            height: screenSize.height * 0.77,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: screenSize.height * 0.07,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.vertical(
                                  top:
                                      Radius.circular(screenSize.width * 0.04)),
                            ),
                            child: SafeArea(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                RichText(
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                      style: GoogleFonts.portLligatSans(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .display1,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Premiação ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  screenSize.width * 0.040),
                                        ),
                                        TextSpan(
                                          text: 'Ranking de Cristais',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  screenSize.width * 0.040),
                                        ),
                                      ]),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder<List<PremiosCristal>>(
                      stream: BlocProvider.getBloc<PremiosBloc>()
                          .outPremiosCristal,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return ListDataPremios(
                                    posicao: index + 1,
                                    premiosCristal: snapshot.data[index],
                                    categoria: 0,
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
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                        screenSize.width * 0.04),
                                    bottomRight: Radius.circular(
                                        screenSize.width * 0.04)),
                              ),
                              child: Text(
                                "Voltar",
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void _showDialogPremioOfensiva(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(screenSize.width * 0.04))),
          contentPadding: EdgeInsets.only(top: 0.0),
          content: Container(
            width: screenSize.width * 1,
            height: screenSize.height * 0.77,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: screenSize.height * 0.07,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.vertical(
                                  top:
                                      Radius.circular(screenSize.width * 0.04)),
                            ),
                            child: SafeArea(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                RichText(
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                      style: GoogleFonts.portLligatSans(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .display1,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Premiação  ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  screenSize.width * 0.040),
                                        ),
                                        TextSpan(
                                          text: 'Ranking de Ofensivas',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  screenSize.width * 0.040),
                                        ),
                                      ]),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder<List<PremiosCfensiva>>(
                      stream: BlocProvider.getBloc<PremiosBloc>()
                          .outPremiosCfensiva,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return ListDataPremios(
                                    posicao: index + 1,
                                    premiosCfensiva: snapshot.data[index],
                                    categoria: 1,
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
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                        screenSize.width * 0.04),
                                    bottomRight: Radius.circular(
                                        screenSize.width * 0.04)),
                              ),
                              child: Text(
                                "Voltar",
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
