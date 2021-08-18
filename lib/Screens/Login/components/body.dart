import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/AlterarSenha/alterar_senha_screen.dart';
import 'package:flutter_auth/Screens/Login/components/stagger_animation.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Screens/home/home_screen.dart';
import 'package:flutter_auth/Screens/home_adm/home_adm_screen.dart';
import 'package:flutter_auth/blocs/administrador_bloc.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/blocs/pontoscristal_bloc.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'background.dart';

class Body extends StatefulWidget {
  Cliente cliente;

  int clienteAuthId;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  Body({Key key, this.scaffoldKey}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  TextEditingController nomeTextEditingController = TextEditingController();
  TextEditingController nomeUsuarioTextEditingController =
      TextEditingController();
  TextEditingController senhaTextEditingController = TextEditingController();
  bool loginRealizado = false;
  bool todasPermissoes = false;

  String senha;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AnimationController _animationController;

  bool checkedValue = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed &&
          loginRealizado == true &&
          todasPermissoes == false) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomeScreen(
                  cliente: widget.cliente,
                )));
      } else if (status == AnimationStatus.completed &&
          loginRealizado == true &&
          todasPermissoes == true) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeAdmScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  "assets/images/login.jpg",
                  height: size.height * 0.25,
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
                SizedBox(height: size.height * 0.02),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.11),
                  decoration: BoxDecoration(
                      color: checkedValue ? kPrimaryLightColor : Colors.white,
                      borderRadius: BorderRadius.circular(size.width * 0.04),
                      border: Border.all(width: 2.0, color: kPrimaryColor)),
                  child: CheckboxListTile(
                    activeColor: kPrimaryColor,
                    title: Text(
                      "Lembrar login",
                      style: TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.w900),
                    ),
                    value: checkedValue,
                    onChanged: (newValue) {
                      setState(() {
                        checkedValue = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                _alterarSenha(),
                SizedBox(height: size.height * 0.01),
                AlreadyHaveAnAccountCheck(
                  press: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignUpScreen();
                        },
                      ),
                    );
                  },
                ),
                Padding(padding: EdgeInsets.only(bottom: size.height * 0.02)),
                SizedBox(height: size.height * 0.12),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: size.height * 0.02),
            child: SafeArea(
              child: StaggerAnimation(
                  controller: _animationController.view,
                  function: () async {
                    loginRealizado = await pressLogin().then((value) {
                      return value;
                    });

                    return loginRealizado;
                  }),
            ),
          ),
        ],
      ))),
    );
  }

  Widget _title(BuildContext context, double fonteSize) {
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
                text: 'LOGIN ',
                style:
                    TextStyle(color: Colors.black, fontSize: fonteSize * 0.08),
              ),
              TextSpan(
                text: 'CLIENTE',
                style:
                    TextStyle(color: kPrimaryColor, fontSize: fonteSize * 0.08),
              ),
            ]),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget _alterarSenha() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
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
              " ALTERAR SENHA",
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
      Cliente cli =
          Cliente(login: nomeUsuarioTextEditingController.text, senha: senha);

      http.Response status = await BlocProvider.getBloc<ClienteBloc>()
          .autenticarCliente(cli)
          .then((value) {
        return value;
      });

      if (status != null) {
        if (status.statusCode == 200) {
          if (status.headers["tipologin"] == "adm") {
            BlocProvider.getBloc<AdministradorBloc>().token = status.headers["authorization"];
            todasPermissoes = true;
          } else if (status.headers["tipologin"] == "cli") {
            todasPermissoes = false;
          }

          widget.cliente = await BlocProvider.getBloc<ClienteBloc>()
              .buscarExistenciaClientes(nomeUsuarioTextEditingController.text)
              .then((value) {
            return value;
          });

          if (checkedValue == true) {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setBool('loginState', true);
            preferences.setString('login', widget.cliente.login);
          }

          BlocProvider.getBloc<PontosCristalBloc>()
              .buscarSomaTotalPontosCristalDoCliente(
                  int.parse(status.headers["idclienteauth"]));

          BlocProvider.getBloc<ClienteBloc>().buscarTodosClientes();

          _onSucess();
          loginRealizado = true;
          return true;
        } else if (status.statusCode == 403) {
          _onFail("Falha ao logar, verifique os dados e tente novamente!");
          loginRealizado = false;

          return false;
        } else {
          _onFail("Falha ao logar!");
        }
      } else {
        _onFail("Falha ao conectar ao servidor, tente novamente mais tarde!");
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

  void _onFail(String text) {
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
