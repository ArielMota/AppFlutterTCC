import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/home/home_screen.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_cpf_field.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_input_nome_usuario.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:flutter_auth/components/rounded_telefone_field.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:flutter_auth/model/endereco.dart';
import 'package:flutter_auth/model/imagem.dart';
import 'package:flutter_auth/model/pontos_ofensiva.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../constants.dart';
import 'background.dart';
import 'or_divider.dart';

class Body extends StatefulWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  String imgperfil;
  Cliente cliente;

  Body(this.scaffoldKey, this.cliente);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController nomeTextEditingController = TextEditingController();
  TextEditingController nomeUsuarioTextEditingController =
      TextEditingController();
  TextEditingController senhaTextEditingController = TextEditingController();
  TextEditingController cpfTextEditingController = TextEditingController();
  TextEditingController telefoneTextEditingController = TextEditingController();
  TextEditingController ruaTextEditingController = TextEditingController();
  TextEditingController setorTextEditingController = TextEditingController();
  TextEditingController numeroTextEditingController = TextEditingController();
  TextEditingController complementoTextEditingController =
      TextEditingController();
  TextEditingController nomeAmigoTextEditingController =
      TextEditingController();
  TextEditingController nomeCachorroTextEditingController =
      TextEditingController();
  String senha;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String dropdownValue = "Gênero de filme preferido";

  String dropdownValueSexo = "Sexo";

  final List<String> _dropdownValuesSexo = [
    "Masculino",
    "Feminino",
  ];

  final List<String> _dropdownValues = [
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

  File imgFile;
  String img64;
  int selectradio = 0;

  @override
  void initState() {
    super.initState();

    widget.imgperfil = widget.cliente.imagem.path;
    nomeTextEditingController.text = widget.cliente.nome;
    nomeUsuarioTextEditingController.text = widget.cliente.login;
    senhaTextEditingController.text = widget.cliente.senha;
    cpfTextEditingController.text = widget.cliente.cpf;
    telefoneTextEditingController.text = widget.cliente.telefone;
    dropdownValueSexo = widget.cliente.sexo;
    ruaTextEditingController.text = widget.cliente.endereco.rua;
    setorTextEditingController.text = widget.cliente.endereco.setor;
    complementoTextEditingController.text = widget.cliente.endereco.complemento;
    numeroTextEditingController.text =
        widget.cliente.endereco.numero.toString();
    nomeAmigoTextEditingController.text =
        widget.cliente.nome_do_melhor_amigo_de_infancia;
    dropdownValue = widget.cliente.genero_de_filme_preferido;
    nomeCachorroTextEditingController.text =
        widget.cliente.nome_do_primeiro_cachorro;
  }

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
              SizedBox(height: size.height * 0.07),
              _title(context),
              SizedBox(height: size.height * 0.03),
              InkWell(
                onTap: () => _showDialog2(context),
                child: Container(
                  alignment: Alignment.topRight,
                  width: size.width * 0.4,
                  height: size.height * 0.2,
                  decoration: BoxDecoration(
                      color: kPrimaryLightColor,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                            widget.imgperfil ?? "assets/images/semimage.jpg"),
                      )),
                  child: Container(
                    width: size.width * 0.1,
                    height: size.height * 0.1,
                    margin: EdgeInsets.only(left: 80),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: kPrimaryColor),
                  ),
                ),
              ),
              OrDivider(text: "DADOS PESSOAIS"),
              RoundedInputField(
                textEditingController: nomeTextEditingController,
                hintText: "Nome Completo",
                onChanged: (value) {},
              ),
              RoundedInputNomeUsuario(
                textEditingController: nomeUsuarioTextEditingController,
                hintText: "Nome de Usuário",
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                textEditingController: senhaTextEditingController,
                onChanged: (value) {
                  senha = value;
                },
              ),
              RoundedCpfField(
                textEditingController: cpfTextEditingController,
                hintText: "CPF",
                onChanged: (value) {},
              ),
              RoundedTelefoneField(
                textEditingController: telefoneTextEditingController,
                hintText: "Telefone",
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
                    Icons.person,
                    color: kPrimaryColor,
                  )),
                  hint: Text(dropdownValueSexo),
                  value: widget.cliente.sexo,
                  items: _dropdownValuesSexo
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
                      dropdownValue = newValue;
                    });
                  },
                ),
              ),
              OrDivider(text: "ENDEREÇO"),
              RoundedInputField(
                textEditingController: ruaTextEditingController,
                hintText: "Rua",
                onChanged: (value) {},
              ),
              RoundedInputField(
                textEditingController: setorTextEditingController,
                hintText: "Setor",
                onChanged: (value) {},
              ),
              RoundedInputField(
                textEditingController: numeroTextEditingController,
                hintText: "Número",
                textInputType: TextInputType.number,
                onChanged: (value) {},
              ),
              RoundedInputField(
                textEditingController: complementoTextEditingController,
                hintText: "Complemento",
                onChanged: (value) {},
              ),
              OrDivider(text: "DADOS PARA RECUPERAÇÃO DE SENHA"),
              RoundedInputField(
                icon: Icons.star,
                textEditingController: nomeAmigoTextEditingController,
                hintText: "Nome do melhor amigo(a) de infância",
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
                  hint: Text(dropdownValue),
                  value: widget.cliente.genero_de_filme_preferido,
                  items: _dropdownValues
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
                      dropdownValue = newValue;
                    });
                  },
                ),
              ),
              RoundedInputField(
                icon: Icons.star,
                textEditingController: nomeCachorroTextEditingController,
                hintText: "Nome do primeiro cachorro",
                onChanged: (value) {},
              ),
              RoundedButton(
                text: "Editar",
                press: () async {
                  if (_formKey.currentState.validate()) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    Cliente cli = Cliente(
                        id: widget.cliente.id,
                        nome: nomeTextEditingController.text,
                        login: nomeUsuarioTextEditingController.text,
                        senha: senha,
                        cpf: cpfTextEditingController.text,
                        telefone: telefoneTextEditingController.text,
                        sexo: dropdownValueSexo,
                        endereco: Endereco(
                            rua: ruaTextEditingController.text,
                            setor: setorTextEditingController.text,
                            numero: int.parse(numeroTextEditingController.text),
                            complemento: complementoTextEditingController.text),
                        nome_do_melhor_amigo_de_infancia:
                            nomeAmigoTextEditingController.text,
                        genero_de_filme_preferido: dropdownValue,
                        nome_do_primeiro_cachorro:
                            nomeCachorroTextEditingController.text,
                        imagem: Imagem(
                          path: widget.imgperfil,
                        ),
                        pontosOfensiva: PontosOfensiva(quantidade: 0),
                        ofensiva_diaria_concluida: false);

                    http.Response status =
                        await BlocProvider.getBloc<ClienteBloc>()
                            .cadastrarCliente(cli);

                    if (status.statusCode == 201) {
                      _onSucess();
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => HomeScreen(
                                  cliente: cli,
                                )));
                      });
                    } else if (status == null) {
                      _onFail();
                    } else {
                      _onFail();
                    }
                  }
                },
              ),
              RoundedButton(
                color: Colors.red,
                text: "Cancelar",
                press: () async {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context) {
    return RichText(
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
              text: 'EDITAR ',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'PERFIL',
              style: TextStyle(color: kPrimaryColor, fontSize: 30),
            ),
          ]),
    );
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Escolha uma opção:"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text("Galery"),
                    onTap: () {
                      _openGalery(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      _openCamera(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _onSucess() {
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Perfil editado com sucesso!"),
      backgroundColor: Colors.greenAccent,
      duration: Duration(seconds: 2),
    ));
  }

  void _onFail() {
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao editar perfil!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _openGalery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgFile = picture;
    });

    Uint8List bytes = picture.readAsBytesSync();
    img64 = base64Encode(bytes);
    print(img64);

    Navigator.pop(context);
  }

  Future<void> _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imgFile = picture;
    });

    Navigator.pop(context);
  }

  void _showDialog2(BuildContext context) {
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
            width: screenSize.width * 0.90,
            height: screenSize.height * 0.55,
            decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius:
                    BorderRadius.all(Radius.circular(screenSize.width * 0.04))),
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
                            height: screenSize.height * 0.535,
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
                                child: GridView.builder(
                                    itemCount: 12,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            widget.imgperfil =
                                                "assets/images/${index + 1}.png";
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(
                                              screenSize.width * 0.02),
                                          alignment: Alignment.topRight,
                                          width: screenSize.width * 0.19,
                                          height: screenSize.height * 0.10,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/${index + 1}.png"),
                                              )),
                                        ),
                                      );
                                    })),
                          ),
                        ),
                      ],
                    ),
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
