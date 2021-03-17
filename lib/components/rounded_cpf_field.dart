import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../constants.dart';


class RoundedCpfField extends StatelessWidget {
  var maskFormatter = new MaskTextInputFormatter(mask: '###.###.###-##', filter: { "#": RegExp(r'[0-9]') });


  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  TextEditingController  textEditingController = TextEditingController();

   RoundedCpfField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.textEditingController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        inputFormatters: [maskFormatter],
        keyboardType: TextInputType.number,
        controller: textEditingController,
        validator: (value) {
          if (value.isEmpty) {
            return ("[campo obrigatório]");
          }else if(!CPF.isValid(value)){
            return "Este CPF é inválido";
          }else{
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
}
