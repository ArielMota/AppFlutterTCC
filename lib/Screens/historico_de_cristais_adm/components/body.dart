import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/administrador_bloc.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/blocs/pontoscristal_bloc.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:flutter_auth/model/pontos_cristal.dart';
import 'package:flutter_auth/widgets/custom_drawer_adm.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

import 'list_data.dart';

import '../../../constants.dart';
import 'background.dart';

class Body extends StatefulWidget {
  Cliente cliente;
  PageController pageController;
  bool chamadoScanner;

  final valorEditarCristalTextEditingController = TextEditingController();
  final valorCristalTextEditingController = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  Body(this.cliente, {this.pageController, this.chamadoScanner});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    // This size provide us total height and width of our screen
    return Scaffold(
      key: widget.scaffoldKey,
      appBar: !widget.chamadoScanner
          ? AppBar(
              title: Text("Historico de Cristais"),
              centerTitle: true,
              actions: [
                IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _showDialog2(
                        context,
                        widget.cliente,
                      );
                    })
              ],
            )
          : AppBar(
              actions: [
                IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _showDialog2(
                        context,
                        widget.cliente,
                      );
                    })
              ],
            ),
      body: Column(
        children: [
          Stack(
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
                        "Cliente: ${widget.cliente.login}",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w300,
                            color: Colors.white),
                      ),
                      StreamBuilder(
                          stream:
                              BlocProvider.of<ClienteBloc>(context).outClientes,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              print(widget.cliente.login);
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
                                padding:
                                    EdgeInsets.all(screenSize.height * 0.003),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _corTresPrimeiros(valor)),
                                width: screenSize.width * 0.4,
                                height: screenSize.height * 0.2,
                                child: Container(
                                  alignment: Alignment.topRight,
                                  width: screenSize.width * 0.3,
                                  height: screenSize.height * 0.3,
                                  decoration: BoxDecoration(
                                      color: _corTresPrimeiros(valor),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "${widget.cliente.imagem.path}"),
                                      )),
                                  child: Container(
                                    width: screenSize.width * 0.09,
                                    height: screenSize.height * 0.09,
                                    margin: EdgeInsets.only(
                                        left: screenSize.width * 0.02),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${valor}º",
                                      style: TextStyle(
                                        fontSize: screenSize.width * 0.04,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Color.fromRGBO(80, 210, 194, 1.0)),
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                height: screenSize.height * 0.015,
                                width: screenSize.width * 0.03,
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              );
                            }
                          }),
                    ],
                  ))),

              Positioned(
                  right: 0,
                  child: StreamBuilder(
                      stream: BlocProvider.of<PontosCristalBloc>(context).outConcluiuOfensiva,
                      initialData: widget.cliente.ofensiva_diaria_concluida,
                      builder: (context, snapshott){

                      if(snapshott.hasData){
                        if(snapshott.data == true){
                          return Container(
                            alignment: Alignment.bottomCenter,
                            width: screenSize.width * 0.15,
                            height: screenSize.height * 0.07,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/ofensivaconcluida.png"),
                                  fit: BoxFit.fill,
                                )),
                            child: Container(
                              margin: EdgeInsets.only(top: 2),
                              width: screenSize.width * 0.12,
                              height: screenSize.height * 0.020,
                              alignment: Alignment.center,
                              child: Text(
                                "ofensiva diária concluída",
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.015,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5),
                                  color: kPrimaryColor),
                            ),
                          );
                        }else{
                          return Container();
                        }
                      }else{
                        return Container();
                      }

                  }))

              ,
              Positioned(
                  right: 0,
                  child: widget.cliente.ofensiva_diaria_concluida
                      ? Container(
                          alignment: Alignment.bottomCenter,
                          width: screenSize.width * 0.15,
                          height: screenSize.height * 0.07,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(
                                "assets/images/ofensivaconcluida.png"),
                            fit: BoxFit.fill,
                          )),
                          child: Container(
                            margin: EdgeInsets.only(top: 2),
                            width: screenSize.width * 0.12,
                            height: screenSize.height * 0.020,
                            alignment: Alignment.center,
                            child: Text(
                              "ofensiva diária concluída",
                              style: TextStyle(
                                fontSize: screenSize.width * 0.015,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5),
                                color: kPrimaryColor),
                          ),
                        )
                      : Container())
            ],
          ),
          StreamBuilder<List<PontosCristal>>(
            initialData: [],
            stream:
                BlocProvider.of<PontosCristalBloc>(context).outPontosCristals,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                              key: Key(DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString()),
                              background: Container(
                                color: Colors.red,
                                child: Align(
                                    alignment: Alignment(-0.9, 0.0),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    )),
                              ),
                              secondaryBackground: Container(
                                color: Colors.green,
                                child: Align(
                                    alignment: Alignment(0.9, 0.0),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    )),
                              ),
                              direction: DismissDirection.horizontal,
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  bool show = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      screenSize.width *
                                                          0.04))),
                                          contentPadding:
                                              EdgeInsets.only(top: 0.0),
                                          title: Container(
                                            margin: EdgeInsets.only(
                                                bottom:
                                                    screenSize.height * 0.02),
                                            child: Text(
                                              "Você deseja excluir esta pontuação em cristais?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.grey.shade500),
                                            ),
                                          ),
                                          content: Container(
                                            width: screenSize.width * 0.20,
                                            child: Stack(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () async {
                                                              http.Response response = await BlocProvider
                                                                      .of<PontosCristalBloc>(
                                                                          context)
                                                                  .removePontoCristal(
                                                                      index,
                                                                      snapshot.data[
                                                                          index],
                                                                      BlocProvider.of<AdministradorBloc>(
                                                                              context)
                                                                          .token);

                                                              if (response
                                                                      .statusCode ==
                                                                  200) {
                                                                BlocProvider.of<
                                                                            ClienteBloc>(
                                                                        context)
                                                                    .buscarTodosClientes();

                                                                BlocProvider.of<
                                                                            PontosCristalBloc>(
                                                                        context)
                                                                    .buscarTodosPontosCristalDoCliente(snapshot
                                                                        .data[
                                                                            index]
                                                                        .cliente
                                                                        .id);



                                                                _onSucess(
                                                                    "Cristais removidos com sucesso!",
                                                                    context);
                                                              } else {
                                                                _onFail(
                                                                    "Falha ao remover cristais!",
                                                                    context);

                                                              }
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 20.0,
                                                                      bottom:
                                                                          20.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    kPrimaryColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius.circular(
                                                                      screenSize
                                                                              .width *
                                                                          0.04),
                                                                ),
                                                              ),
                                                              child: Text(
                                                                "Excluir",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 20.0,
                                                                      bottom:
                                                                          20.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                borderRadius: BorderRadius.only(
                                                                    bottomRight:
                                                                        Radius.circular(screenSize.width *
                                                                            0.04)),
                                                              ),
                                                              child: Text(
                                                                "Cancelar",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
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
                                      });

                                  return show;
                                } else if (direction ==
                                    DismissDirection.endToStart) {
                                  bool show = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      screenSize.width *
                                                          0.04))),
                                          contentPadding:
                                              EdgeInsets.only(top: 0.0),
                                          title: Container(
                                            margin: EdgeInsets.only(
                                                bottom:
                                                    screenSize.height * 0.02),
                                            child: Text(
                                              "Editar pontuação em cristais",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          content: Container(
                                            width: screenSize.width * 0.20,
                                            child: Stack(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 30.0,
                                                                right: 30.0),
                                                        child:
                                                            RoundedInputField(
                                                          icon: Icons.edit,
                                                          hintText:
                                                              "${snapshot.data[index].valor_pontos.toStringAsPrecision(2)}",
                                                          textInputType:
                                                              TextInputType
                                                                  .number,
                                                          textEditingController:
                                                              widget
                                                                  .valorEditarCristalTextEditingController,
                                                        )),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () async {
                                                              http.Response response = await BlocProvider
                                                                      .of<PontosCristalBloc>(
                                                                          context)
                                                                  .editarPontosCristal(
                                                                      double.parse(widget
                                                                          .valorEditarCristalTextEditingController
                                                                          .text),
                                                                      snapshot.data[
                                                                          index],
                                                                      BlocProvider.of<AdministradorBloc>(
                                                                              context)
                                                                          .token);

                                                              if (response
                                                                      .statusCode ==
                                                                  201) {

                                                                BlocProvider.of<
                                                                            ClienteBloc>(
                                                                        context)
                                                                    .buscarTodosClientes();

                                                                BlocProvider.of<
                                                                            PontosCristalBloc>(
                                                                        context)
                                                                    .buscarTodosPontosCristalDoCliente(snapshot
                                                                        .data[
                                                                            index]
                                                                        .cliente
                                                                        .id);
                                                                _onSucess(
                                                                    "Cristais editado com sucesso!",
                                                                    context);
                                                              } else {
                                                                _onFail(
                                                                    "Falha ao editar cristais!",
                                                                    context);

                                                              }
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 20.0,
                                                                      bottom:
                                                                          20.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    kPrimaryColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius.circular(
                                                                      screenSize
                                                                              .width *
                                                                          0.04),
                                                                ),
                                                              ),
                                                              child: Text(
                                                                "Editar",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 20.0,
                                                                      bottom:
                                                                          20.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                borderRadius: BorderRadius.only(
                                                                    bottomRight:
                                                                        Radius.circular(screenSize.width *
                                                                            0.04)),
                                                              ),
                                                              child: Text(
                                                                "Cancelar",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
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
                                      });

                                  return show;
                                } else {
                                  return false;
                                }
                              },
                              child: ListData(
                                pontosCristal: snapshot.data[index],
                              ));
                        }),
                  );
                } else {
                  return Expanded(
                      child: Center(
                          child:
                              _ListaCristaisVazia(context, screenSize.width)));
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
      ),
    );
  }

  void _showDialog2(BuildContext context, Cliente cli) {
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
            width: screenSize.width * 0.20,
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
                            height: screenSize.height * 0.20,
                            decoration: BoxDecoration(
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
                                          text: 'Adcionar ',
                                          style: TextStyle(
                                              color: kPrimaryColor,
                                              fontSize:
                                                  screenSize.width * 0.035),
                                        ),
                                        TextSpan(
                                          text: 'cristais',
                                          style: TextStyle(
                                              color: kPrimaryColor,
                                              fontSize:
                                                  screenSize.width * 0.035),
                                        ),
                                      ]),
                                ),
                                Container(
                                  alignment: Alignment.topRight,
                                  width: screenSize.width * 0.19,
                                  height: screenSize.height * 0.09,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/cristal.png"),
                                        fit: BoxFit.contain,
                                      )),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 30.0, right: 30.0),
                        child: RoundedInputField(
                          icon: Icons.attach_money,
                          hintText: "Valor em reais \$",
                          textInputType: TextInputType.number,
                          textEditingController:
                              widget.valorCristalTextEditingController,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              PontosCristal pontoCristal = new PontosCristal(
                                  cliente: cli,
                                  valor_pontos: double.parse(widget
                                      .valorCristalTextEditingController.text
                                      .trim()),
                                  data: DateTime.now().toString());

                              pontoCristal.data =
                                  DateTime.now().toLocal().toString();

                              http.Response response =
                                  await BlocProvider.of<PontosCristalBloc>(
                                          context)
                                      .cadastrarPontosCristal(
                                          pontoCristal,
                                          BlocProvider.of<AdministradorBloc>(
                                                  context)
                                              .token);

                              if (response.statusCode == 201) {
                                BlocProvider.of<ClienteBloc>(context)
                                    .buscarTodosClientes();


                                widget.valorCristalTextEditingController.text =
                                    "";

                                BlocProvider.of<PontosCristalBloc>(context)
                                    .buscarTodosPontosCristalDoCliente(
                                        pontoCristal.cliente.id);

                                _onSucess("Cristais adcionados com sucesso!",
                                    context);
                              } else {
                                Navigator.pop(context);
                                _onFail("Falha ao cadastar cristais!", context);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.only(
                                  bottomLeft:
                                      Radius.circular(screenSize.width * 0.04),
                                ),
                              ),
                              child: Text(
                                "Adcionar",
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
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
                                    bottomRight: Radius.circular(
                                        screenSize.width * 0.04)),
                              ),
                              child: Text(
                                "Cancelar",
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

  void _onSucess(String text, BuildContext context) {
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ));

    Navigator.pop(context);

  }

  void _onFail(String text, BuildContext context) {
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text, style: TextStyle(fontWeight: FontWeight.w500)),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));

    Navigator.pop(context);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                text: 'Lista de cristais vazia!',
                style:
                    TextStyle(color: kPrimaryColor, fontSize: fonteSize * 0.05),
              ),
            ]),
      ),
    );
  }
}
