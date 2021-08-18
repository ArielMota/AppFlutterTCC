import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/historico_de_cristais_adm/historico_de_cristais_screen_adm.dart';
import 'package:flutter_auth/blocs/administrador_bloc.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/blocs/pontoscristal_bloc.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/model/pontos_cristal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_auth/model/cliente.dart';

class ListData extends StatefulWidget {
  final String title;
  final ImageProvider image;
  final EdgeInsets margin;
  final Cliente cliente;
  Function function;
  String pontos;

  ListData({this.title, this.image, this.margin, this.cliente, this.function});

  @override
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  final imgCristal = AssetImage("assets/images/perfil.jpg");

  final novaSenhaTextEditingController = TextEditingController();
  final valorCristalTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<String> future = widget.function();
    future.then((value) {
      widget.pontos = value;
    });

    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        //print(widget.cliente.login);
        _showDialog(context, widget.cliente);
      },
      child: Container(
        margin: widget.margin,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(
                    color: Colors.grey[100], width: size.width * 0.01),
                bottom: BorderSide(
                    color: Colors.grey[100], width: size.width * 0.005))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: size.height * 0.02,
                  bottom: size.height * 0.02,
                  left: size.width * 0.04,
                  right: size.width * 0.06),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor),
              width: size.width * 0.15,
              height: size.height * 0.08,
              child: Container(
                margin: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
                width: size.width * 0.15,
                height: size.height * 0.15,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: Image.asset(widget.cliente.imagem.path).image)),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Cliente:",
                    style: TextStyle(
                      fontSize: size.width * 0.035,
                      color: kPrimaryColor,
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
                              color: Colors.black,
                              fontSize: size.width * 0.045),
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
                    stream: BlocProvider.getBloc<ClienteBloc>().outCategoria,
                    initialData: 0,
                    builder: (context, snapshote) {
                      if (snapshote.hasData) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              width: size.width * 0.15,
                              height: size.height * 0.07,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage(snapshote.data == 0
                                    ? "assets/images/cristal.png"
                                    : "assets/images/chama.png"),
                                fit: BoxFit.fill,
                              )),
                              child: Container(
                                width: size.width * 0.10,
                                height: size.height * 0.020,
                                alignment: Alignment.center,
                                child: FutureBuilder(
                                    future: future,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data != "") {
                                        return Text(
                                          snapshote.data == 0
                                              ? snapshot.data
                                              : "${widget.cliente.pontosOfensiva.quantidade}",
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
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
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
      ),
    );
  }

  void _showDialog(BuildContext context, Cliente cli) {
    final screenSize = MediaQuery.of(context).size;

    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          actions: <Widget>[
            Container(
              height: screenSize.height * 0.20,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background.jpg"),
                    fit: BoxFit.cover),
              ),
              child: SafeArea(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
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
                            text: 'Cliente: ',
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: screenSize.width * 0.035),
                          ),
                          TextSpan(
                            text: '${cli.login} ',
                            style: TextStyle(
                                color: kPrimaryLightColor,
                                fontSize: screenSize.width * 0.035),
                          ),
                        ]),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    width: screenSize.width * 0.2,
                    height: screenSize.height * 0.1,
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(cli.imagem.path),
                        )),
                  ),
                ],
              )),
            ),
            // usually buttons at the bottom of the dialog

            Container(
              color: kPrimaryLightColor,
              child: FlatButton(
                  color: kPrimaryLightColor,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            HistoricoDeCristaisScreenAdm(cli)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Histórico de cristais",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  )),
            ),
            Container(
              color: kPrimaryLightColor,
              child: FlatButton(
                  color: kPrimaryLightColor,
                  onPressed: () {
                    _showDialog2(context, cli);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Adcionar cristais",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                      Icon(Icons.add),
                    ],
                  )),
            ),
            Container(
              color: kPrimaryLightColor,
              child: FlatButton(
                  color: kPrimaryLightColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cancelar",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                      Icon(Icons.close),
                    ],
                  )),
            ),
          ],
        );
      },
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
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/background.jpg"),
                                  fit: BoxFit.cover),
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
                                          text: 'Cliente: ',
                                          style: TextStyle(
                                              color: kPrimaryColor,
                                              fontSize:
                                                  screenSize.width * 0.035),
                                        ),
                                        TextSpan(
                                          text: '${cli.login} ',
                                          style: TextStyle(
                                              color: kPrimaryLightColor,
                                              fontSize:
                                                  screenSize.width * 0.035),
                                        ),
                                      ]),
                                ),
                                Container(
                                  alignment: Alignment.topRight,
                                  width: screenSize.width * 0.2,
                                  height: screenSize.height * 0.1,
                                  decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage(cli.imagem.path),
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
                          hintText: "Valor em reais \$0.00",
                          textInputType: TextInputType.number,
                          textEditingController:
                              valorCristalTextEditingController,
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
                                  valor_pontos: double.parse(double.parse(
                                          valorCristalTextEditingController.text
                                              .replaceAll(",", ".")
                                              .trim())
                                      .toStringAsPrecision(2)),
                                  data: DateTime.now().toString());

                              pontoCristal.data =
                                  DateTime.now().toLocal().toString();

                              http.Response response = await BlocProvider
                                      .getBloc<PontosCristalBloc>()
                                  .cadastrarPontosCristal(
                                      pontoCristal,
                                      BlocProvider.getBloc<AdministradorBloc>()
                                          .token);

                              if (response.statusCode == 201) {
                                BlocProvider.getBloc<ClienteBloc>()
                                    .buscarTodosClientes();
                                BlocProvider.getBloc<PontosCristalBloc>()
                                    .buscarTodosPontosCristalDoCliente(cli.id);
                                Navigator.pop(context);
                                Navigator.pop(context);

                                _onSucess("Cristais adcionados com sucesso!");
                              } else {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                _onFail("Falha ao cadastar cristais!");
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

  void _onSucess(String text) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
    ));
  }

  void _onFail(String text) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text, style: TextStyle(fontWeight: FontWeight.w500)),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }
}
