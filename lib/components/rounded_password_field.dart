import 'package:flutter/material.dart';
import 'package:flutter_auth/components/text_field_container.dart';

import '../constants.dart';

class RoundedPasswordField extends StatefulWidget {



  TextEditingController  textEditingController = TextEditingController();

  final ValueChanged<String> onChanged;
   bool ocultarSenha;

   RoundedPasswordField({
    Key key,
    this.onChanged,
    this.textEditingController,
     this.ocultarSenha = true
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: widget.ocultarSenha,
        onChanged: widget.onChanged,
        validator: (value) {
          if (value.isEmpty) {
            return ("[campo obrigatório]");
          }else{
            return null;
          }
        },
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(Icons.lock),
          labelText: "Senha",
          labelStyle: TextStyle(
              color: kPrimaryColor,
              fontSize: 15
          ),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(Icons.visibility, color: widget.ocultarSenha? kPrimaryColor : Colors.grey),
            onPressed: (){
              setState(() {
                if(widget.ocultarSenha == true){
                  widget.ocultarSenha = false;
                }else{
                  widget.ocultarSenha = true;

                }
              });
            },
          ),

        ),
      ),
    );
  }
}
