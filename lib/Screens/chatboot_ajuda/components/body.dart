import 'package:flutter/material.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:flutter_dialogflow/v2/auth_google.dart';
import 'package:flutter_dialogflow/v2/dialogflow_v2.dart';
import 'package:flutter_dialogflow/v2/message.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../constants.dart';
import 'background.dart';

class Body extends StatefulWidget {
  Cliente cliente;

  Body(this.cliente);

  @override
  _BodyState createState() => _BodyState();

}

class _BodyState extends State<Body> {
  final _messageList = <ChatMessage>[];
  final _controllerText = new TextEditingController();



  @override
  void initState() {
    super.initState();

    _sendMessage(text: "menu");

  }

  @override
  void dispose() {
    super.dispose();
    _controllerText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    return Scaffold(
      body: Background(
        child: Column(
          children: <Widget>[
            _buildList(),
            Divider(height: size.height * 0.02),
            _buildUserInput(),
          ],
        ),
      ),
    );
  }

  // Cria a lista de mensagens (de baixo para cima)
  Widget _buildList() {
    Size size = MediaQuery.of(context).size;

    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.all(size.width * 0.02),
        reverse: true,
        itemBuilder: (_, int index) => ChatMessageListItem(
          chatMessage: _messageList[index],
          size: size,
          cliente: widget.cliente,
        ),
        itemCount: _messageList.length,
      ),
    );
  }

  Future _dialogFlowRequest({String query}) async {
    // Adiciona uma mensagem temporária na lista
    _addMessage(
        name: 'Atendente',
        text: 'Escrevendo...',
        type: ChatMessageType.received);

    // Faz a autenticação com o serviço, envia a mensagem e recebe uma resposta da Intent
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/images/credentials.json").build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: "pt-BR");
    AIResponse response = await dialogflow.detectIntent(query);

    // remove a mensagem temporária
    setState(() {
      _messageList.removeAt(0);
    });

    // adiciona a mensagem com a resposta do DialogFlow
    _addMessage(
        name: 'Atendente',
        text: response.getMessage() ?? '',
        type: ChatMessageType.received);
  }

  // Envia uma mensagem com o padrão a direita
  void _sendMessage({String text}) {
    _controllerText.clear();
    _addMessage(
        name: '${widget.cliente.login}',
        text: text,
        type: ChatMessageType.sent);
  }

  // Adiciona uma mensagem na lista de mensagens
  void _addMessage({String name, String text, ChatMessageType type}) {
    var message = ChatMessage(text: text, name: name, type: type);
    setState(() {
      _messageList.insert(0, message);
    });

    if (type == ChatMessageType.sent) {
      // Envia a mensagem para o chatbot e aguarda sua resposta
      _dialogFlowRequest(query: message.text);
    }
  }

  // Campo para escrever a mensagem
  Widget _buildTextField() {
    return new Flexible(
      child: new TextField(
        controller: _controllerText,
        decoration: new InputDecoration.collapsed(
          hintText: "Enviar mensagem",
        ),
      ),
    );
  }

  // Botão para enviar a mensagem
  Widget _buildSendButton() {
    return new Container(
      margin: new EdgeInsets.only(left: 8.0),
      child: new IconButton(
          icon: new Icon(Icons.send, color: Theme.of(context).accentColor),
          onPressed: () {
            if (_controllerText.text.isNotEmpty) {
              _sendMessage(text: _controllerText.text);
            }
          }),
    );
  }

  // Monta uma linha com o campo de text e o botão de enviao
  Widget _buildUserInput() {
    Size size = MediaQuery.of(context).size;


    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: new Row(
        children: <Widget>[
          _buildTextField(),
          _buildSendButton(),
        ],
      ),
    );
  }
}

enum ChatMessageType { sent, received }

class ChatMessage {
  final String name;
  final String text;
  final ChatMessageType type;

  ChatMessage({
    this.name,
    this.text,
    this.type = ChatMessageType.sent,
  });
}

class ChatMessageListItem extends StatelessWidget {
  final ChatMessage chatMessage;
  Size size;
  Cliente cliente;

  ChatMessageListItem({this.chatMessage, this.size, this.cliente});

  @override
  Widget build(BuildContext context) {
    return chatMessage.type == ChatMessageType.sent
        ? _showSentMessage()
        : _showReceivedMessage();
  }

  Widget _showSentMessage({EdgeInsets padding, TextAlign textAlign}) {
    return Row(
      children: [

        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: size.width * 0.1, right: size.width * 0.01, top: size.height * 0.005, bottom: size.height * 0.005, ),
            decoration: BoxDecoration(color: kPrimaryColor,borderRadius: BorderRadius.circular(size.width * 0.03)),
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(
                  size.width * 0.08,size.height * 0.015, size.width * 0.02, size.height * 0.015),
              title: Text(chatMessage.name, textAlign: TextAlign.right, style: TextStyle(color: kPrimaryLightColor, fontWeight:  FontWeight.bold),),
              subtitle: Text(chatMessage.text, textAlign: TextAlign.right, style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        CircleAvatar(child: Image.asset(cliente.imagem.path), backgroundColor: kPrimaryColor,),

      ],
    );
  }

  Widget _showReceivedMessage() {
    return Row(
      children: [
        CircleAvatar(child: Image.asset("assets/images/atendente.png"), backgroundColor: Colors.blue,),

        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: size.width * 0.01, right: size.width * 0.1,  top: size.height * 0.005, bottom: size.height * 0.005,),
            decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(size.width * 0.03)),
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(
                  size.width * 0.08,size.height * 0.015, size.width * 0.02, size.height * 0.015),
              title: Text(chatMessage.name, textAlign: TextAlign.left, style: TextStyle(color: kPrimaryLightColor, fontWeight:  FontWeight.bold),),
              subtitle: Text(chatMessage.text, textAlign: TextAlign.left, style: TextStyle(color: Colors.white)),
            ),
          ),
        ),

      ],
    );
  }
}
