import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/administrador_bloc.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/blocs/pontoscristal_bloc.dart';
import 'package:flutter_auth/blocs/premios_bloc.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/model/Historico_ganhadores_premios_cristais.dart';
import 'package:flutter_auth/model/Historico_ganhadores_premios_ofensiva.dart';
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
  HistoricoGanhadoresPremiosCristais historicoGanhadoresPremiosCristais;
  HistoricoGanhadoresPremiosOfensiva historicoGanhadoresPremiosOfensiva;
  int categoria;

  ListData(
      {@required this.posicao,
      this.historicoGanhadoresPremiosCristais,
      this.historicoGanhadoresPremiosOfensiva,
      this.categoria});

  @override
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final tituloTextEditingController = TextEditingController();
  final urlImagemTextEditingController = TextEditingController();
  final descricaoTextEditingController = TextEditingController();

  String dropdownValueCristal = "Escolha uma opção";
  String dropdownValueOfensiva = "Escolha uma opção";


  final List<String> _dropdownValues = [
    "Sim",
    "Não",
  ];

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

        if(widget.categoria == 0){
          _showDialogPremioCristal(context, widget.historicoGanhadoresPremiosCristais);

        }else{
          _showDialogPremioOfensiva(context, widget.historicoGanhadoresPremiosOfensiva);
        }

        return null;
      },
      child: Container(
          padding: EdgeInsets.only(
              top: size.height * 0.005,
              bottom: size.height * 0.005,
              left: size.width * 0.005,
              right: size.width * 0.005),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top:
                      BorderSide(color: Colors.white, width: size.width * 0.01),
                  bottom: BorderSide(
                      color: Colors.white, width: size.width * 0.01))),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: kPrimaryLightColor),
                    width: size.width * 0.15,
                    height: size.height * 0.15525,
                    child: Container(
                      margin:
                      EdgeInsets.only(top: size.width * 0.002, bottom: size.width * 0.002, left: size.height * 0.004, right: size.height * 0.002),
                      width: size.width * 0.15,
                      height: size.height * 0.15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(size.width * 0.12)),
                          shape: BoxShape.rectangle,
                          color: _corTresPrimeiros(widget.posicao)),
                      child: Center(
                        child: Transform.rotate(
                          angle: 270 * 3.14 / 180,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style: GoogleFonts.aBeeZee(
                                  textStyle:
                                      Theme.of(context).textTheme.display1,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.categoria == 0
                                        ? widget
                                            .historicoGanhadoresPremiosCristais
                                            .data
                                        : widget
                                            .historicoGanhadoresPremiosOfensiva
                                            .data,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.width * 0.027),
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: kPrimaryLightColor),
                    width: size.width * 0.15,
                    height: size.height * 0.15525,
                    child: Container(
                      margin:
                      EdgeInsets.only(top: size.width * 0.002, bottom: size.width * 0.002, left: size.height * 0.004, right: size.height * 0.002),
                      width: size.width * 0.15,
                      height: size.height * 0.15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(size.width * 0.12)),
                          shape: BoxShape.rectangle,
                          color: _corTresPrimeiros(widget.posicao)),
                      child: Center(
                        child: Transform.rotate(
                          angle: 270 * 3.14 / 180,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style: GoogleFonts.aBeeZee(
                                  textStyle:
                                      Theme.of(context).textTheme.display1,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                ),
                                children: [
                                  TextSpan(
                                    text: " ${widget.posicao}º Lugar",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.width * 0.030),
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(

                      width: size.width * 0.75,
                      height:  size.height * 0.11,
                      padding: EdgeInsets.only(
                          top: size.height * 0.005,
                          bottom: size.height * 0.005,
                          left: size.width * 0.005,
                          right: size.width * 0.005),
                      decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: <Widget>[
                              Text("Cliente: ",
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
                                              ? "${"${widget.historicoGanhadoresPremiosCristais.cliente.login}" ?? "Não Disponivel!"}"
                                              : "${"${widget.historicoGanhadoresPremiosOfensiva.cliente.login}" ?? "Não Disponivel!"}",
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _corTresPrimeiros(widget.posicao)),
                                width: size.width * 0.16,
                                height: size.height * 0.06,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: size.height * 0.003,
                                      bottom: size.height * 0.003,
                                      left: size.width * 0.02,
                                      right: size.width * 0.02),
                                  width: size.width * 0.18,
                                  height: size.height * 0.11,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: widget.categoria == 0
                                            ? Image.asset(widget
                                                        .historicoGanhadoresPremiosCristais
                                                        .cliente
                                                        .imagem
                                                        .path ??
                                                    "assets/images/semimage.jpg")
                                                .image
                                            : Image.asset(widget
                                                        .historicoGanhadoresPremiosOfensiva
                                                        .cliente
                                                        .imagem
                                                        .path ??
                                                    "assets/images/semimage.jpg")
                                                .image,
                                        fit: BoxFit.scaleDown,
                                      )),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _corTresPrimeiros(widget.posicao)),
                                width: size.width * 0.16,
                                height: size.height * 0.06,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: size.height * 0.003,
                                      bottom: size.height * 0.003,
                                      left: size.width * 0.02,
                                      right: size.width * 0.02),
                                  width: size.width * 0.18,
                                  height: size.height * 0.11,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: widget.categoria == 0
                                            ? Image.asset(widget
                                                            .historicoGanhadoresPremiosCristais
                                                            .premioResgatado ==
                                                        true
                                                    ? "assets/images/sucesso.jpeg"
                                                    : "assets/images/falha.png")
                                                .image
                                            : Image.asset(widget
                                                            .historicoGanhadoresPremiosOfensiva
                                                            .premioResgatado ==
                                                        true
                                                    ? "assets/images/sucesso.jpeg"
                                                    : "assets/images/falha.png")
                                                .image,
                                        fit: BoxFit.scaleDown,
                                      )),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: size.width * 0.75,
                      padding: EdgeInsets.only(
                          top: size.height * 0.005,
                          bottom: size.height * 0.005,
                          left: size.width * 0.005,
                          right: size.width * 0.005),
                      decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                      ),
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
                                              ? "${widget.historicoGanhadoresPremiosCristais.title ?? "Não Disponivel!"}"
                                              : "${widget.historicoGanhadoresPremiosOfensiva.title ?? "Não Disponivel!"}",
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
                                      stream:
                                          BlocProvider.of<ClienteBloc>(context)
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
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: _imagemPremio(
                                                                widget
                                                                    .categoria)
                                                            .image,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0)),
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
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: kPrimaryLightColor),
                    width: size.width * 0.15,
                    height: size.height * 0.15525,
                    child: Container(
                      margin:
                      EdgeInsets.only(top: size.width * 0.002, bottom: size.width * 0.002, left: size.height * 0.002, right: size.height * 0.004),
                      width: size.width * 0.15,
                      height: size.height * 0.15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(size.width * 0.12)),
                          shape: BoxShape.rectangle,
                          color: _corTresPrimeiros(widget.posicao)),
                      child: Center(
                        child: Transform.rotate(
                          angle: 270 * 3.14 / 180,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style: GoogleFonts.aBeeZee(
                                  textStyle:
                                      Theme.of(context).textTheme.display1,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.categoria == 0
                                        ? "${widget.historicoGanhadoresPremiosCristais.valorTotalCristal} Cristais"
                                        : "${widget.historicoGanhadoresPremiosOfensiva.valorTotalOfensiva} Ofensivas",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.width * 0.027),
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: kPrimaryLightColor),
                    width: size.width * 0.15,
                    height: size.height * 0.15525,
                    child: Container(
                      margin:
                      EdgeInsets.only(top: size.width * 0.002, bottom: size.width * 0.002, left: size.height * 0.002, right: size.height * 0.004),
                      width: size.width * 0.15,
                      height: size.height * 0.15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(size.width * 0.12)),
                          shape: BoxShape.rectangle,
                          color: _corTresPrimeiros(widget.posicao)),
                      child: Center(
                        child: Transform.rotate(
                          angle: 270 * 3.14 / 180,
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            width: size.width * 0.15,
                            height: size.height * 0.07,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(widget.categoria == 0
                                      ? "assets/images/cristal.png"
                                      : "assets/images/chama.png"),
                                  fit: BoxFit.scaleDown,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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

  Image _imagemPremio(int index) {
    if (index == 0) {
      return widget.historicoGanhadoresPremiosCristais.urlImagem != null
          ? (Image.network(
              widget.historicoGanhadoresPremiosCristais.urlImagem,
            ))
          : Image.asset("assets/images/imagemnaodisponivel.png");
    } else if (index == 1) {
      return widget.historicoGanhadoresPremiosOfensiva.urlImagem != null
          ? Image.network(widget.historicoGanhadoresPremiosOfensiva.urlImagem)
          : Image.asset("assets/images/imagemnaodisponivel.png");
    } else {
      return Image.asset("assets/images/imagemnaodisponivel.png");
    }
  }

  void _showDialogPremioCristal(BuildContext context, HistoricoGanhadoresPremiosCristais historicoGanhadoresPremiosCristais) {
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
                                            text: 'Este prêmio foi resgatado? ',
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
                          child: TextFieldContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(children: [ Text("Cliente: "),Text(" ${historicoGanhadoresPremiosCristais.cliente.login}", style: TextStyle(color: kPrimaryColor),)
                                ],),
                                Row(children: [ Text("Ranking: "),Text(" Cristais", style: TextStyle(color: kPrimaryColor),)
                                ],),
                                Row(children: [ Text("Posição: "),Text(" ${historicoGanhadoresPremiosCristais.posicao}", style: TextStyle(color: kPrimaryColor),)
                                ],),
                                Row(children: [ Text("Data: "),Text(" ${historicoGanhadoresPremiosCristais.data}", style: TextStyle(color: kPrimaryColor),)
                                ],),
                                Row(children: [ Text("Premiação: "),Text(" ${historicoGanhadoresPremiosCristais.title}", style: TextStyle(color: kPrimaryColor),)
                                ],),

                              ],
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0, right: 30.0),
                        child: TextFieldContainer(
                          child: DropdownButtonFormField<String>(
                            validator: (value) {
                              if (value == null) {
                                return ("[campo obrigatório]");
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                icon: Icon(
                              Icons.star,
                              color: kPrimaryColor,
                            )),
                            hint: Text(dropdownValueCristal,style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenSize.width * 0.03) ),
                            items: _dropdownValues
                                .map((value) => DropdownMenuItem(
                                      child: value == "Sim" ? Row(
                                        children: [
                                          CircleAvatar(backgroundImage: Image.asset("assets/images/sucesso.jpeg").image,),
                                          Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: screenSize.width * 0.05),)
                                        ],
                                      ): Row(
                                        children: [
                                          CircleAvatar(backgroundImage: Image.asset("assets/images/falha.png").image,),
                                          Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: screenSize.width * 0.05))
                                        ],
                                      ),
                                      value: value,
                                    ))
                                .toList(),
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValueCristal = newValue;
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              });
                            },
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {

                                if(_formKey.currentState.validate()){

                                  http.Response response;
                                  
                                  print(dropdownValueCristal);

                                  if(dropdownValueCristal == "Sim"){
                                    widget.historicoGanhadoresPremiosCristais.premioResgatado = true;
                                    print(widget.historicoGanhadoresPremiosCristais.premioResgatado);
                                    response = await BlocProvider.of<PremiosBloc>(
                                        context)
                                        .editarGanhadorCristal(
                                        widget.historicoGanhadoresPremiosCristais,
                                        BlocProvider.of<AdministradorBloc>(
                                            context)
                                            .token);
                                  }else if(dropdownValueCristal == "Não"){
                                    widget.historicoGanhadoresPremiosCristais.premioResgatado = false;
                                    response = await BlocProvider.of<PremiosBloc>(
                                        context)
                                        .editarGanhadorCristal(
                                        widget.historicoGanhadoresPremiosCristais,
                                        BlocProvider.of<AdministradorBloc>(
                                            context)
                                            .token);

                                  }



                                  if (response.statusCode == 200) {
                                    dropdownValueCristal = "Escolha uma opção";

                                    BlocProvider.of<PremiosBloc>(context)
                                        .buscaHistoricoGanhadoresPremiosCristais();

                                    Navigator.pop(context);
                                    _onSucess("Alteração realizada com sucesso!", context);

                                  } else {
                                    _onFail("Falha ao realizar alteração!", context);
                                    Navigator.pop(context);
                                  }

                                }

                              },
                              child: Container(
                                padding:
                                    EdgeInsets.only(top: 20.0, bottom: 20.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                        screenSize.width * 0.04),
                                  ),
                                ),
                                child: Text(
                                  "Salvar",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                dropdownValueCristal= "Escolha uma opção";
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
      BuildContext context, HistoricoGanhadoresPremiosOfensiva historicoGanhadoresPremiosOfensiva) {
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
                                                text: 'Este prêmio foi resgatado? ',
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
                          child: TextFieldContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(children: [ Text("Cliente: "),Text(" ${historicoGanhadoresPremiosOfensiva.cliente.login}", style: TextStyle(color: kPrimaryColor),)
                                ],),
                                Row(children: [ Text("Ranking: "),Text(" Ofensivas", style: TextStyle(color: kPrimaryColor),)
                                ],),
                                Row(children: [ Text("Posição: "),Text(" ${historicoGanhadoresPremiosOfensiva.posicao}", style: TextStyle(color: kPrimaryColor),)
                                ],),
                                Row(children: [ Text("Data: "),Text(" ${historicoGanhadoresPremiosOfensiva.data}", style: TextStyle(color: kPrimaryColor),)
                                ],),
                                Row(children: [ Text("Premiação: "),Text(" ${historicoGanhadoresPremiosOfensiva.title}", style: TextStyle(color: kPrimaryColor),)
                                ],),


                              ],
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0, right: 30.0),
                        child: TextFieldContainer(
                          child: DropdownButtonFormField<String>(

                            validator: (value) {
                              if (value == null) {
                                return ("[campo obrigatório]");
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                icon: Icon(
                                  Icons.star,
                                  color: kPrimaryColor,
                                )),
                            hint: Text(dropdownValueOfensiva, style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenSize.width * 0.03)),
                            items: _dropdownValues
                                .map((value) => DropdownMenuItem(
                              child: value == "Sim" ? Row(
                                children: [
                                  CircleAvatar(backgroundImage: Image.asset("assets/images/sucesso.jpeg").image,),
                                  Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: screenSize.width * 0.05),)
                                ],
                              ): Row(
                                children: [
                                  CircleAvatar(backgroundImage: Image.asset("assets/images/falha.png").image,),
                                  Text(value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: screenSize.width * 0.05))
                                ],
                              ),
                              value: value,
                            ))
                                .toList(),
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValueOfensiva = newValue;
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              });
                            },
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {


                                if(_formKey.currentState.validate()){

                                  http.Response response;

                                  print(dropdownValueOfensiva);

                                  if(dropdownValueOfensiva == "Sim"){
                                    widget.historicoGanhadoresPremiosOfensiva.premioResgatado = true;
                                    print(widget.historicoGanhadoresPremiosOfensiva.premioResgatado);
                                    response = await BlocProvider.of<PremiosBloc>(
                                        context)
                                        .editarGanhadorOfensiva(
                                        widget.historicoGanhadoresPremiosOfensiva,
                                        BlocProvider.of<AdministradorBloc>(
                                            context)
                                            .token);
                                  }else if(dropdownValueOfensiva == "Não"){
                                    widget.historicoGanhadoresPremiosOfensiva.premioResgatado = false;
                                    response = await BlocProvider.of<PremiosBloc>(
                                        context)
                                        .editarGanhadorOfensiva(
                                        widget.historicoGanhadoresPremiosOfensiva,
                                        BlocProvider.of<AdministradorBloc>(
                                            context)
                                            .token);

                                  }



                                  if (response.statusCode == 200) {

                                    dropdownValueOfensiva = "Escolha uma opção";
                                    BlocProvider.of<PremiosBloc>(context)
                                        .buscaHistoricoGanhadoresPremiosOfensiva();

                                    Navigator.pop(context);
                                    _onSucess("Alteração realizada com sucesso!", context);

                                  } else {
                                    Navigator.pop(context);
                                    _onFail("Falha ao realizar alteração!", context);
                                  }

                                }


                              },
                              child: Container(
                                padding:
                                EdgeInsets.only(top: 20.0, bottom: 20.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                        screenSize.width * 0.04),
                                  ),
                                ),
                                child: Text(
                                  "Salvar",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                dropdownValueOfensiva = "Escolha uma opção";
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
