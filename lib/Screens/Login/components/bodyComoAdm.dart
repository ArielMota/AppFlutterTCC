import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/AlterarSenha/alterar_senha_screen.dart';
import 'package:flutter_auth/Screens/Login/components/stagger_animation.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Screens/home_adm/home_adm_screen.dart';
import 'package:flutter_auth/blocs/administrador_bloc.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/model/administrador.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import 'package:google_fonts/google_fonts.dart';


import 'background.dart';


class BodyComoAdm extends StatefulWidget {

Administrador administrador;
var scaffoldKey = GlobalKey<ScaffoldState>();




   BodyComoAdm({
    Key key,
    this.scaffoldKey
  }) : super(key: key);

  @override
  _BodyComoAdmState createState() => _BodyComoAdmState();
}

class _BodyComoAdmState extends State<BodyComoAdm> with SingleTickerProviderStateMixin {
  TextEditingController nomeUsuarioTextEditingController =
  TextEditingController();
  TextEditingController senhaTextEditingController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AnimationController _animationController;

  bool loginRealizado = false;
  String senha;


  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeAdmScreen()));
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    print("Logar como adm!")
    ;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0.0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: kPrimaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Background(
        child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: size.height * 0.03),
                      _title(context, size.width),
                      SizedBox(height: size.height * 0.03),
                      Image.asset(
                        "assets/images/adm.jpg",
                        height: size.height * 0.35,
                      ),
                      SizedBox(height: size.height * 0.03),
                      RoundedInputField(
                        textEditingController: nomeUsuarioTextEditingController,
                        hintText: "Nome de usuário",
                        onChanged: (value) {},
                      ),
                      RoundedPasswordField(
                        onChanged: (value) {
                          senha = value;
                        },
                      ),
                      Padding(padding: EdgeInsets.only(bottom: size.height * 0.02)),
                      SizedBox(height: size.height * 0.12),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: size.height * 0.02),
                  child: StaggerAnimation(
                      controller: _animationController.view,
                      function: ()  async {
                        loginRealizado =  await pressLogin().then((value){
                          return value;
                        });

                        return loginRealizado;
                      }

                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget _title(BuildContext context, double fontSize) {
    return SafeArea(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            style: GoogleFonts.portLligatSans(
              textStyle: Theme
                  .of(context)
                  .textTheme
                  .display1,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.red,
            ),
            children: [
              TextSpan(
                text: 'LOGIN ',
                style: TextStyle(color: Colors.black, fontSize: fontSize * 0.06),
              ),
              TextSpan(
                text: 'ADMINISTRADOR',
                style: TextStyle(color: kPrimaryColor, fontSize: fontSize * 0.06),
              ),
            ]),
      ),
    );
  }

  Widget _recuperarSenha() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AlterarSenhaScreen();
            },
          ),
        );
      },
      child: Container(
        color: kPrimaryLightColor,
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Esqueceu a senha ?",
              style: TextStyle(color: kPrimaryColor),
            ),
            Text(
              " RECUPERAR SENHA",
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> pressLogin() async {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).requestFocus(new FocusNode());
      Administrador administrador =
      Administrador(login: nomeUsuarioTextEditingController.text, senha: senha);

      http.Response status = await BlocProvider.of<AdministradorBloc>(context)
          .autenticarAdministrador(administrador)
          .then((value) {
        return value;
      });




      if (status.statusCode == 200) {
        await BlocProvider.of<AdministradorBloc>(context).buscarValorDoCristal();

        /* widget.cliente = await BlocProvider.of<ClienteBloc>(context).buscarExistenciaClientes(nomeUsuarioTextEditingController.text).then((value){

          return value;
        });*/



      //  BlocProvider.of<PontosCristalBloc>(context).buscarSomaTotalPontosCristalDoCliente(int.parse(status.headers["idclienteauth"]));
        //BlocProvider.of<ClienteBloc>(context).buscarTodosClientes();
        _onSucess();
        loginRealizado = true;
        return true;
      } else if (status.statusCode == 403) {
        _onFail();
        loginRealizado = false;
        return false;
      }
    }
  }

  void _onSucess() {
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Sucesso ao Entrar!"),
      backgroundColor: Colors.greenAccent,
      duration: Duration(seconds: 2),
    ));
  }

  void _onFail() {
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao Entrar!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }


}
