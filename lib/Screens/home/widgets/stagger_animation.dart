
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/home/widgets/fade_container.dart';
import 'package:flutter_auth/Screens/home/widgets/home_top.dart';
import 'package:flutter_auth/Screens/home/widgets/list_data.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/blocs/pontoscristal_bloc.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';


class StaggerAnimation extends StatefulWidget {
  final AnimationController controller;
  Cliente cliente;


  StaggerAnimation({@required this.controller, this.cliente})
      : containerGrow = CurvedAnimation(parent: controller, curve: Curves.ease),
        listSlidePosition = EdgeInsetsTween(
                begin: EdgeInsets.only(bottom: 0),
                end: EdgeInsets.only(bottom: 80))
            .animate(CurvedAnimation(
                parent: controller,
                curve: Interval(0.325, 0.8, curve: Curves.ease))),
        fadeAnimation = ColorTween(
          begin: kPrimaryColor,
          end: Color.fromRGBO(247, 64, 106, 0.0),
        ).animate(
            CurvedAnimation(parent: controller, curve: Curves.decelerate));

  final Animation<double> containerGrow;
  final Animation<EdgeInsets> listSlidePosition;
  final Animation<Color> fadeAnimation;

  @override
  _StaggerAnimationState createState() => _StaggerAnimationState();
}

class _StaggerAnimationState extends State<StaggerAnimation> {
  Widget _buildAnimation(BuildContext context, Widget child) {
    Size screenSize = MediaQuery.of(context).size;




    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Stack(
              children: [
                HomeTop(containerGrow: widget.containerGrow, cliente: widget.cliente,),
                Positioned(
                    left: 0,
                    child: widget.cliente.ofensiva_diaria_concluida
                        ? Container(
                      alignment: Alignment.bottomCenter,
                      width: screenSize.width * 0.15,
                      height: screenSize.height * 0.07,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                        color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/sucesso.png"),
                            fit: BoxFit.fill,
                          )),
                      child: Container(
                        margin: EdgeInsets.only(top: 2),
                        width: screenSize.width * 0.12,
                        height: screenSize.height * 0.020,
                        alignment: Alignment.center,
                        child: Text(
                          "ofensiva diária concluída",
                          style: TextStyle(
                            fontSize: screenSize.width * 0.015,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5),
                            color: kPrimaryColor),
                      ),
                    )
                        : Container())

              ],
            ),
            StreamBuilder(
              initialData: 0,
                stream: BlocProvider.getBloc<ClienteBloc>().outCategoria,
                builder: (context,snapshot){
              if(snapshot.data == 0){
                BlocProvider.getBloc<ClienteBloc>().buscarTodosClientes();
                return StreamBuilder(
                  stream: BlocProvider.getBloc<ClienteBloc>().outClientes,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {

                      return Expanded(
                        child: RefreshIndicator(
                          onRefresh: reloadListCristais,
                          child: ListView.builder(itemCount:snapshot.data.length ,itemBuilder: (context, index) {

                            //final _byteImage = Base64Decoder().convert(snapshot.data[index].imagem.path);
                          //  Image image = Image.memory(_byteImage);




                            return ListData(
                              title: "Funcionou",
                              posicao: index + 1,
                              image:  AssetImage("assets/images/perfil.jpg"),
                              cliente: snapshot.data[index],
                              function: () async {
                                Cliente cli = snapshot.data[index];
                                http.Response body = await BlocProvider.getBloc<PontosCristalBloc>().buscarSomaTotalPontosCristalDeTodosClientes(cli.id).then((value){
                                  return value;
                                });
                                return body.body;
                              },

                            );
                          }),
                        ),
                      );
                    }else{
                      return Expanded(
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                          ),
                        ),
                      );
                    }
                  },
                );
              }else{
                BlocProvider.getBloc<ClienteBloc>().buscarTodosClientesPorOfensiva();
                return StreamBuilder(
                  stream: BlocProvider.getBloc<ClienteBloc>().outClientes,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: RefreshIndicator(
                          onRefresh: reloadListPontosOfensivas,
                          child: ListView.builder(itemCount:snapshot.data.length ,itemBuilder: (context, index) {



                            return ListData(
                              title: "Funcionou",
                              posicao: index + 1,
                              image: AssetImage("assets/images/perfil.jpg"),
                              cliente: snapshot.data[index],
                              function: () async {
                                Cliente cli = snapshot.data[index];
                                http.Response body = await BlocProvider.getBloc<PontosCristalBloc>().buscarSomaTotalPontosCristalDeTodosClientes(cli.id).then((value){
                                  return value;
                                });
                                return body.body;
                              },

                            );
                          }),
                        ),
                      );
                    }else{
                      return Expanded(
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                          ),
                        ),
                      );
                    }
                  },
                );
              }
            })
          ],
        ),
        IgnorePointer(
          child: FadeContainer(
            fadeAnimation: widget.fadeAnimation,
          ),
        )
      ],
    );
  }




  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: AnimatedBuilder(animation: widget.controller, builder: _buildAnimation),
      ),
    );
  }

  Future<void> reloadListCristais() async {
    await Future.delayed(Duration(seconds: 2), () {BlocProvider.getBloc<
        ClienteBloc>(
        )
        .buscarTodosClientes();

    BlocProvider.getBloc<
        PontosCristalBloc>(
        ).buscarSomaTotalPontosCristalDoCliente(widget.cliente.id);

    });

  }
  Future<void> reloadListPontosOfensivas() async {
    await Future.delayed(Duration(seconds: 2), () async {
      BlocProvider.getBloc<
        ClienteBloc>(
        )
        .buscarTodosClientesPorOfensiva();



    });

  }
}
