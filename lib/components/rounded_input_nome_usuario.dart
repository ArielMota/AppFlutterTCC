import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class RoundedInputNomeUsuario extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextInputType textInputType;
  final ValueChanged<String> onChanged;
  TextEditingController textEditingController = TextEditingController();

  RoundedInputNomeUsuario(
      {Key key,
      this.hintText,
      this.icon = Icons.person,
      this.textInputType = TextInputType.text,
      this.onChanged,
      this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        keyboardType: textInputType,
        maxLines: 2,
        controller: textEditingController,
        validator: (value) {
          int status;


          if (value.isEmpty) {
            return ("[campo obrigatório]");
          } else {
            return null;
          }
        },
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(icon),
          labelText: hintText,
          labelStyle: TextStyle(
              color: kPrimaryColor,
              fontSize: 15
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Future<bool> _clienteExiste(String text) async {
    var response = await http.get(
      Uri.parse("http://192.168.1.206:8080/cliente_existe/${text}"),
      headers: {"Content-Type": "application/json"},
    );

  }
}
