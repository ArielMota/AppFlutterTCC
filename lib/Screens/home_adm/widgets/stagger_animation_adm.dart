import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/home_adm/widgets/fade_container.dart';
import 'package:flutter_auth/Screens/home_adm/widgets/home_top.dart';
import 'package:flutter_auth/Screens/home_adm/widgets/list_data.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/blocs/pontoscristal_bloc.dart';
import 'package:flutter_auth/model/cliente.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';


class StaggerAnimation extends StatefulWidget {
  final AnimationController controller;


  StaggerAnimation({@required this.controller,})
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
   // BlocProvider.of<ClienteBloc>(context).inSearch.add("ariel");


    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            HomeTop(containerGrow: widget.containerGrow),
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
                        child: ListView.builder(itemCount:snapshot.data.length ,itemBuilder: (context, index) {



                          return ListData(
                            title: "Funcionou",
                            posicao: index + 1,
                            image: snapshot.data[index].sexo == "Masculino" ?  AssetImage("assets/images/perfil.jpg") : AssetImage("assets/images/cristal.png"),
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
                        child: ListView.builder(itemCount:snapshot.data.length ,itemBuilder: (context, index) {



                          return ListData(
                            title: "Funcionou",
                            posicao: index + 1,
                            image: snapshot.data[index].sexo == "Masculino" ?  AssetImage("assets/images/perfil.jpg") : AssetImage("assets/images/cristal.png"),
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
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: AnimatedBuilder(animation: widget.controller, builder: _buildAnimation),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}
