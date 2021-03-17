import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Screens/home/home_screen.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'background.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  Cliente cliente;

  Body({Key key, this.scaffoldKey}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController nomeTextEditingController = TextEditingController();
  TextEditingController nomeUsuarioTextEditingController =
      TextEditingController();
  TextEditingController senhaTextEditingController = TextEditingController();
  TextEditingController nomeAmigoTextEditingController =
      TextEditingController();
  TextEditingController nomeCachorroTextEditingController =
      TextEditingController();
  TextEditingController novaSenhaTextEditingController =
      TextEditingController();

  bool errouLogin = false;
  String senha;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String dropdownFilmeValue = "Gênero de filme preferido";
  final List<String> _dropdownFilmeValues = [
    "Ação",
    "Animação",
    "Aventura",
    "Biografia",
    "Comédia",
    "Crime",
    "Documentário",
    "Drama",
    "Família",
    "Fantasia",
    "Faroeste",
    "Ficção Científica",
    "Guerra",
    "Mistério",
    "Musical",
    "Policial",
    "Romance",
    "Suspense",
    "Terror"
  ];

  String dropdownCachorroValue = "Gênero de filme preferido";
  final List<String> _dropdownCachorroValues = ["Duck", "nick", "jack", "hulk"];

  String dropdownAmigoValue = "Gênero de filme preferido";
  final List<String> _dropdownAmigoValues = [
    "Daniel",
    "Almir",
    "Aline",
    "Zélia"
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.05),
              _title(context, size.width),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/login.svg",
                height: size.height * 0.35,
                placeholderBuilder: (context){
                  return Container(
                    height: size.height * 0.35,
                    width: size.width * 0.35,

                    child: CircularProgressIndicator(
                      backgroundColor: kPrimaryLightColor,

                    ),
                  );
                },
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                textEditingController: nomeUsuarioTextEditingController,
                hintText: "Nome de usuário",
                onChanged: (value) {},
              ),
              RoundedInputField(
                icon: Icons.star,
                textEditingController: nomeAmigoTextEditingController,
                hintText: "Nome do melhor amigo(a) de infância",
                onChanged: (value) {},
              ),
              RoundedInputField(
                icon: Icons.star,
                textEditingController: nomeCachorroTextEditingController,
                hintText: "Nome do primeiro cachorro",
                onChanged: (value) {},
              ),
              TextFieldContainer(
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
                  hint: Text(dropdownFilmeValue),
                  items: _dropdownFilmeValues
                      .map((value) => DropdownMenuItem(
                            child: Text(value),
                            value: value,
                          ))
                      .toList(),
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownFilmeValue = newValue;
                      FocusScope.of(context).requestFocus(new FocusNode());

                    });
                  },
                ),
              ),
              RoundedButton(
                text: "ALTERAR SENHA",
                press: () async {
                  if (_formKey.currentState.validate()) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    Cliente cli = Cliente(
                        login: nomeUsuarioTextEditingController.text,
                        nome_do_melhor_amigo_de_infancia:
                            nomeAmigoTextEditingController.text,
                        nome_do_primeiro_cachorro:
                            nomeCachorroTextEditingController.text,
                        genero_de_filme_preferido: dropdownFilmeValue);

                    widget.cliente =
                        await BlocProvider.of<ClienteBloc>(context)
                            .buscarExistenciaClientes(cli.login)
                            .then((value) {
                      return value;
                    });

                    print(widget.cliente.genero_de_filme_preferido);

                    if (widget.cliente != null && widget.cliente.genero_de_filme_preferido == cli.genero_de_filme_preferido &&
                    widget.cliente.nome_do_primeiro_cachorro == cli.nome_do_primeiro_cachorro &&
                    widget.cliente.nome_do_melhor_amigo_de_infancia == cli.nome_do_melhor_amigo_de_infancia) {

                      _showDialog(context, cli);

                    } else {
                      _onFail();
                    }
                  }
                },
              ),
              SizedBox(height: size.height * 0.005),

            ],
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context, double fontSize) {
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
                text: 'ALTERAR ',
                style: TextStyle(color: Colors.black, fontSize: fontSize * 0.08),
              ),
              TextSpan(
                text: 'SENHA',
                style: TextStyle(color: kPrimaryColor, fontSize: fontSize * 0.08),
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

  void _showDialog(BuildContext context, Cliente cli) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Nova Senha",
            style: TextStyle(color: kPrimaryColor),
          ),
          content: new RoundedInputField(
            hintText: "Digite sua nova senha aqui",
            textEditingController: novaSenhaTextEditingController,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              color: kPrimaryColor,
              child: new Text("SALVAR", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                if (cli != null) {
                  cli.senha = novaSenhaTextEditingController.text;
                  http.Response response = await BlocProvider.of<ClienteBloc>(context)
                      .RecuperarSenhaCliente(cli).then((value){
                        return value;
                  });

                  if(response.statusCode == 200){
                    _onSucess();
                    Navigator.of(context).pop();


                }else{
                    _onFail();
                    Navigator.of(context).pop();
                  }
                } else {
                  _onFail();
                }
              },
            ),
            new FlatButton(
              color: kPrimaryLightColor,
              child:
                  new Text("CANCELAR", style: TextStyle(color: kPrimaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onFail() {
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao Recuperar Senha!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }

  void _onSucess() {
    MaterialPageRoute(builder: (context) => LoginScreen());
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Senha alterada com sucesso!"),
      backgroundColor: Colors.greenAccent,
      duration: Duration(seconds: 2),
    ));
  }

}
