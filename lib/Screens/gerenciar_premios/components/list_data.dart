import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/administrador_bloc.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/blocs/pontoscristal_bloc.dart';
import 'package:flutter_auth/blocs/premios_bloc.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/model/pontos_cristal.dart';
import 'package:flutter_auth/model/pontos_ofensiva.dart';
import 'package:flutter_auth/model/premios_cristal.dart';
import 'package:flutter_auth/model/premios_ofensiva.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_auth/model/cliente.dart';

class ListData extends StatefulWidget {
  int posicao;
  PremiosCristal premiosCristal;
  PremiosCfensiva premiosCfensiva;
  int categoria;

  ListData(
      {@required this.posicao,
      this.premiosCristal,
      this.premiosCfensiva,
      this.categoria});

  @override
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final tituloTextEditingController = TextEditingController();
  final urlImagemTextEditingController = TextEditingController();
  final descricaoTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: _corTresPrimeiros(widget.posicao),
        child: Align(
            alignment: Alignment(-0.9, 0.0),
            child: Icon(
              Icons.edit,
              color: Colors.white,
            )),
      ),
      secondaryBackground: Container(
        color: _corTresPrimeiros(widget.posicao),
        child: Align(
            alignment: Alignment(0.9, 0.0),
            child: Icon(
              Icons.edit,
              color: Colors.white,
            )),
      ),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) {
        if (direction == DismissDirection.startToEnd || direction == DismissDirection.endToStart ) {
          if (widget.categoria == 0) {
            tituloTextEditingController.text = widget.premiosCristal.title;
            urlImagemTextEditingController.text = widget.premiosCristal.urlImagem;
            descricaoTextEditingController.text = widget.premiosCristal.descricao;
            _showDialogPremioCristal(
                context, widget.premiosCristal, widget.posicao);
          } else {
            tituloTextEditingController.text = widget.premiosCfensiva.title;
            urlImagemTextEditingController.text = widget.premiosCfensiva.urlImagem;
            descricaoTextEditingController.text = widget.premiosCfensiva.descricao;
            _showDialogPremioOfensiva(
                context, widget.premiosCfensiva, widget.posicao);
          }

          return null;
        } else {
          return null;
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(
                    color: kPrimaryLightColor, width: size.width * 0.004),
                bottom: BorderSide(
                    color: kPrimaryLightColor, width: size.width * 0.005))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: size.height * 0.03,
                  bottom: size.height * 0.03,
                  left: size.width * 0.02,
                  right: size.width * 0.02),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: kPrimaryLightColor),
              width: size.width * 0.15,
              height: size.height * 0.15,
              child: Container(
                margin: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
                width: size.width * 0.15,
                height: size.height * 0.15,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _corTresPrimeiros(widget.posicao)),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: GoogleFonts.aBeeZee(
                          textStyle: Theme.of(context).textTheme.display1,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: " ${widget.posicao}º",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.040),
                          )
                        ]),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.only(
                    top: size.height * 0.003,
                    bottom: size.height * 0.003,
                    left: size.width * 0.005,
                    right: size.width * 0.005),
                decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Text("Prêmio: ",
                            style: TextStyle(
                              fontSize: size.width * 0.035,
                              fontWeight: FontWeight.w300,
                            )),
                        SizedBox(
                          height: size.height * 0.015,
                        ),
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                            text: TextSpan(
                                style: GoogleFonts.portLligatSans(
                                  fontSize: size.width * 0.035,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.categoria == 0
                                        ? "${widget.premiosCristal.title ?? "Não Disponivel!"}"
                                        : "${widget.premiosCfensiva.title  ?? "Não Disponivel!"}",
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: size.width * 0.045,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: size.width * 0.60,
                            height: size.height * 0.16,
                            margin: EdgeInsets.all(4),
                            child: StreamBuilder(
                                stream: BlocProvider.of<ClienteBloc>(context)
                                    .outCategoria,
                                initialData: 0,
                                builder: (context, snapshote) {
                                  if (snapshote.hasData) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.bottomCenter,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: _imagemPremio(
                                                          widget.categoria)
                                                      .image,
                                                  fit: BoxFit.fill,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0)),
                                          ),
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
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    );
                                  }
                                }),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.075,
            ),
          ],
        ),
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

  Image _imagemPremio(int index) {
    if (index == 0) {
      return widget.premiosCristal.urlImagem != null
          ? (Image.network(
              widget.premiosCristal.urlImagem,
            ))
          : Image.asset("assets/images/imagemnaodisponivel.png");
    } else if (index == 1) {
      return widget.premiosCfensiva.urlImagem != null
          ? Image.network(widget.premiosCfensiva.urlImagem)
          : Image.asset("assets/images/imagemnaodisponivel.png");
    } else {
      return Image.asset("assets/images/imagemnaodisponivel.png");
    }
  }

  void _showDialogPremioCristal(
      BuildContext context, PremiosCristal pmc, int posicao) {
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
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
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
                                    top: Radius.circular(
                                        screenSize.width * 0.04)),
                              ),
                              child: SafeArea(
                                  child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                            text: 'Editar premiação do ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    screenSize.width * 0.040),
                                          ),
                                          TextSpan(
                                            text: '${posicao}º lugar',
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
                      Padding(
                          padding: EdgeInsets.only(left: 30.0, right: 30.0),
                          child: RoundedInputField(
                            icon: Icons.title,
                            hintText: "Titulo",
                            textInputType: TextInputType.text,
                            textEditingController: tituloTextEditingController,
                          )),
                      Padding(
                          padding: EdgeInsets.only(left: 30.0, right: 30.0),
                          child: RoundedInputField(
                            icon: Icons.add_photo_alternate_outlined,
                            hintText: "Url da imagem",
                            textInputType: TextInputType.text,
                            textEditingController:
                                urlImagemTextEditingController,
                          )),
                      Padding(
                          padding: EdgeInsets.only(left: 30.0, right: 30.0),
                          child: RoundedInputField(
                            icon: Icons.description,
                            hintText: "Descrição",
                            textInputType: TextInputType.text,
                            textEditingController:
                                descricaoTextEditingController,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                if (_formKey.currentState.validate()) {
                                  PremiosCristal premiosCristal =
                                      new PremiosCristal(
                                          id: pmc.id,
                                          title:
                                              tituloTextEditingController.text,
                                          descricao:
                                              descricaoTextEditingController
                                                  .text,
                                          urlImagem:
                                              urlImagemTextEditingController
                                                  .text);

                                  if (Uri.parse(premiosCristal.urlImagem)
                                          .isAbsolute ==
                                      true) {
                                    var resp = await http.get(
                                      Uri.parse(premiosCristal.urlImagem),
                                      headers: {
                                        "Content-Type": "application/json"
                                      },
                                    );

                                    if (resp.statusCode != 200) {
                                      premiosCristal.urlImagem = null;
                                    }
                                  } else {
                                    premiosCristal.urlImagem = null;
                                  }

                                  String token =
                                      BlocProvider.of<AdministradorBloc>(
                                              context)
                                          .token;

                                  http.Response response =
                                      await BlocProvider.of<PremiosBloc>(
                                              context)
                                          .editarPremiosCristal(
                                              premiosCristal, token);

                                  if (response.statusCode == 201) {
                                    BlocProvider.of<PremiosBloc>(context)
                                        .buscaTodosPremiosCristais();

                                    Navigator.pop(context);

                                    _onSucess("Premiação alterada com sucesso!",context);
                                  } else {
                                    Navigator.pop(context);
                                    _onFail("Falha ao alterar premiação!",context);
                                  }
                                }
                              },
                              child: Container(
                                padding:
                                    EdgeInsets.only(top: 20.0, bottom: 20.0),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                        screenSize.width * 0.04),
                                  ),
                                ),
                                child: Text(
                                  "Editar",
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
                                padding:
                                    EdgeInsets.only(top: 20.0, bottom: 20.0),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDialogPremioOfensiva(
      BuildContext context, PremiosCfensiva pmc, int posicao) {
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
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
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
                                    top: Radius.circular(
                                        screenSize.width * 0.04)),
                              ),
                              child: SafeArea(
                                  child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                            text: 'Editar premiação do ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    screenSize.width * 0.040),
                                          ),
                                          TextSpan(
                                            text: '${posicao}º lugar',
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
                      Padding(
                          padding: EdgeInsets.only(left: 30.0, right: 30.0),
                          child: RoundedInputField(
                            icon: Icons.title,
                            hintText: "Titulo",
                            textInputType: TextInputType.text,
                            textEditingController: tituloTextEditingController,
                          )),
                      Padding(
                          padding: EdgeInsets.only(left: 30.0, right: 30.0),
                          child: RoundedInputField(
                            icon: Icons.add_photo_alternate_outlined,
                            hintText: "Url da imagem",
                            textInputType: TextInputType.text,
                            textEditingController:
                                urlImagemTextEditingController,
                          )),
                      Padding(
                          padding: EdgeInsets.only(left: 30.0, right: 30.0),
                          child: RoundedInputField(
                            icon: Icons.description,
                            hintText: "Descrição",
                            textInputType: TextInputType.text,
                            textEditingController:
                                descricaoTextEditingController,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                if (_formKey.currentState.validate()) {
                                  PremiosCfensiva premiosOfensiva =
                                      new PremiosCfensiva(
                                          id: pmc.id,
                                          title:
                                              tituloTextEditingController.text,
                                          descricao:
                                              descricaoTextEditingController
                                                  .text,
                                          urlImagem:
                                              urlImagemTextEditingController
                                                  .text);

                                  if (Uri.parse(premiosOfensiva.urlImagem)
                                          .isAbsolute ==
                                      true) {
                                    var resp = await http.get(
                                      Uri.parse(premiosOfensiva.urlImagem),
                                      headers: {
                                        "Content-Type": "application/json"
                                      },
                                    );

                                    if (resp.statusCode != 200) {
                                      premiosOfensiva.urlImagem = null;
                                    }
                                  } else {
                                    premiosOfensiva.urlImagem = null;
                                  }

                                  String token =
                                      BlocProvider.of<AdministradorBloc>(
                                              context)
                                          .token;

                                  http.Response response =
                                      await BlocProvider.of<PremiosBloc>(
                                              context)
                                          .editarPremiosOfensiva(
                                              premiosOfensiva, token);

                                  if (response.statusCode == 201) {
                                    BlocProvider.of<PremiosBloc>(context)
                                        .buscaTodosPremiosCfensiva();

                                    Navigator.pop(context);

                                    _onSucess("Premiação alterada com sucesso!",context);
                                  } else {
                                    Navigator.pop(context);
                                    _onFail("Falha ao alterar premiação!",context);
                                  }
                                }
                              },
                              child: Container(
                                padding:
                                    EdgeInsets.only(top: 20.0, bottom: 20.0),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                        screenSize.width * 0.04),
                                  ),
                                ),
                                child: Text(
                                  "Editar",
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
                                padding:
                                    EdgeInsets.only(top: 20.0, bottom: 20.0),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSucess(String text, BuildContext context) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 20.0,
    );
  }

  void _onFail(String text, BuildContext context) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 20.0,
    );
  }
}
