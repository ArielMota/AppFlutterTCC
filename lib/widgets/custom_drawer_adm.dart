import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/blocs/administrador_bloc.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/model/cristal.dart';
import 'package:flutter_auth/tiles/drawer_tile_adm.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;


import '../constants.dart';


class CustomDrawerAdm extends StatefulWidget {
  final PageController pageController;

  CustomDrawerAdm(this.pageController);

  @override
  _CustomDrawerAdmState createState() => _CustomDrawerAdmState();
}

class _CustomDrawerAdmState extends State<CustomDrawerAdm> {
  final valorCristalTextEditingController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;


    Widget _buildBodyBack() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 200, 180, 241),
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        );

    return Drawer(
      child: Stack(
        children: [
          _buildBodyBack(),
          ListView(
            padding: EdgeInsets.only(
              left: screenSize.width * 0.05, top: screenSize.height * 0.01, right: screenSize.width * 0.05,),
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: 4.0, top: 4.0),
                  height: 170.0,
                  child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: AssetImage("assets/images/cristal.png"),
                                  )),
                            ),
                          ),
                        ],
                      ))),
              FutureBuilder<Cristal>(
                future: BlocProvider.of<AdministradorBloc>(context).buscarValorDoCristal(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Column(
                      children: [
                        _valorCristal("${snapshot.data.valorDoCristal.toStringAsPrecision(3)}", context, screenSize),
                        FlatButton(color: kPrimaryColor,onPressed: () {


                          _showDialogEditarCristal(context, snapshot.data);

                        },
                          child: Text("Editar valor do cristal", style: TextStyle(color: Colors.white),),),

                      ],
                    );
                  }else{
                    return Column(
                      children: [
                        _valorCristal("1.00", context, screenSize),
                        FlatButton(color: kPrimaryColor,onPressed: () {


                          _showDialogEditarCristal(context, snapshot.data);

                        },
                          child: Text("Editar valor do cristal", style: TextStyle(color: Colors.white),),),

                      ],
                    );
                  }
                },
              ),
              Divider(),
              DrawerTileAdm(Icons.home, "Início", widget.pageController, 0),
              DrawerTileAdm(Icons.apps, "Scanner Qr Code", widget.pageController, 1),
              DrawerTileAdm(Icons.card_giftcard, "Gerenciar Prêmios", widget.pageController, 2),
              DrawerTileAdm(Icons.whatshot, "Historico de ganhadores", widget.pageController, 3),



              GestureDetector(
                onTap: (){
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: DrawerTileAdm(
                    Icons.exit_to_app, "Sair", widget.pageController, 4),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _valorCristal(String valor, BuildContext context, final screenSize ){

    return   RichText(
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
              text: '1 Cristal = ',
              style: TextStyle(color: Colors.blue, fontSize: screenSize.width * 0.04),
            ),
            TextSpan(
              text: 'R\$ ${valor.replaceFirst(".", ",")}',
              style: TextStyle(color: kPrimaryColor, fontSize: screenSize.width * 0.04),
            ),
          ]),
    );


  }

  void _showDialogEditarCristal(BuildContext context, Cristal cristal) {
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
            child: Form(
              key: _formKey,
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
                                                text: 'Editar Valor dos ',
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
                            valorCristalTextEditingController,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {

                                if(_formKey.currentState.validate()) {

                                  cristal.valorDoCristal = double.parse(double.parse(valorCristalTextEditingController.text).toStringAsPrecision(3));

                                  http.Response response =
                                  await BlocProvider.of<AdministradorBloc>(
                                      context)
                                      .editarValorDoCristal(
                                    cristal,
                                  );


                                  if (response.statusCode == 200) {
                                    BlocProvider.of<AdministradorBloc>(context)
                                        .buscarValorDoCristal();

                                    Navigator.pop(context);

                                    valorCristalTextEditingController
                                        .text = "";



                                    _onSucess(
                                        "Cristais adcionados com sucesso!",
                                        context);
                                  } else {
                                    Navigator.pop(context);
                                    _onFail(
                                        "Falha ao cadastar cristais!", context);
                                  }
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
          ),
        );
      },
    );
  }

  void _onSucess(String text, BuildContext context) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
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
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 20.0,
    );
  }
}
