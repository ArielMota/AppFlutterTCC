import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Screens/historico_de_cristais_adm/components/list_data.dart';
import 'package:flutter_auth/Screens/historico_de_cristais_adm/historico_de_cristais_screen_adm.dart';
import 'package:flutter_auth/blocs/administrador_bloc.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/blocs/pontoscristal_bloc.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:flutter_auth/model/pontos_cristal.dart';
import 'package:flutter_auth/widgets/custom_drawer.dart';
import 'package:flutter_auth/widgets/custom_drawer_adm.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;

import '../../constants.dart';
import 'components/body.dart';

class ScanearQrCodeScreen extends StatefulWidget {
  static const List<String> choices = <String>["Logar Como Administrador"];
  PageController pageController;
  Cliente cliente;
  bool erroClienteEncontrado = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  ScanearQrCodeScreen(this.pageController);

  @override
  _ScanearQrCodeScreenState createState() => _ScanearQrCodeScreenState();
}

class _ScanearQrCodeScreenState extends State<ScanearQrCodeScreen> {
  final valorCristalTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    void _choiceAction(String action) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen(
              logarComoAdm: true,
            );
          },
        ),
      );
    }

    return Scaffold(
      drawer: CustomDrawerAdm(widget.pageController),
      appBar: AppBar(
        title: Text(" Escanear Qr Code"),
        centerTitle: true,
        actions: [
          StreamBuilder(
            stream: BlocProvider.of<ClienteBloc>(context).outScannerCliente,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _showDialog2(context, widget.cliente);
                    });
              } else {
                return Container();
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () async {
          String value = await scanner.scan();

          try {
            widget.cliente = await BlocProvider.of<ClienteBloc>(context)
                .buscarExistenciaClientes(value);

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HistoricoDeCristaisScreenAdm(
                      widget.cliente,
                      chamadoScanner: true,
                      pageController: widget.pageController,
                    )));
          } catch (e) {

            setState(() {
              widget.erroClienteEncontrado = true;

            });
          }
        },
        child: SvgPicture.asset(
          "assets/icons/qrcodescan.svg",
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          Body(widget.cliente, widget.pageController),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(screenSize.width * 0.1),
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
                      text: !widget.erroClienteEncontrado ? "Pressione o botão abaixo e aponte a câmera para o Qr Code de um cliente!"
                          : "Nenhum cliente corresponde ao Qr code escaneado!",
                      style: TextStyle(fontSize: screenSize.width * 0.05, color: !widget.erroClienteEncontrado ? kPrimaryColor : Colors.red),
                    ),
                  ]),
            )


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
                                        fit: BoxFit.cover,
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
                          hintText: "0.00",
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
                                  valor_pontos: double.parse(
                                      valorCristalTextEditingController.text
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
                                Navigator.pop(context);

                                BlocProvider.of<ClienteBloc>(context)
                                    .buscarTodosClientes();

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
      duration: Duration(seconds: 3),
    ));
  }

  void _onFail(String text, BuildContext context) {
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text, style: TextStyle(fontWeight: FontWeight.w500)),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 3),
    ));
  }

  @override
  void dispose() {
    widget.erroClienteEncontrado = false;
    // TODO: implement dispose
    super.dispose();
  }
}
