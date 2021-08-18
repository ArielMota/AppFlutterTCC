import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_auth/Screens/gerenciar_premios/gerenciar_premios_screen.dart';
import 'package:flutter_auth/Screens/historico_de_ganhadores/historico_de_ganhadores_screen.dart';
import 'package:flutter_auth/Screens/home_adm/widgets/stagger_animation_adm.dart';
import 'package:flutter_auth/Screens/scanear_qr_code/scanear_qr_code_screen.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/delegates/data_search.dart';
import 'package:flutter_auth/widgets/custom_drawer_adm.dart';



class HomeAdmScreen extends StatefulWidget {
  HomeAdmScreen();

  @override
  _HomeAdmScreenState createState() => _HomeAdmScreenState();
}

class _HomeAdmScreenState extends State<HomeAdmScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));

    _controller.forward();
  }

  @override
  void dispose() {


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    timeDilation = 1;

    return WillPopScope(
      onWillPop: () {},
      child: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Scaffold(
            drawer: CustomDrawerAdm(_pageController),
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              elevation: 0.0,
              actions: [


                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      String result = await showSearch(
                          context: context, delegate: DataSearch());
                      if (result != null) {
                        BlocProvider.getBloc<ClienteBloc>()
                            .inSearch
                            .add(result);
                      }
                    })
              ],
            ),
            body: StaggerAnimation(
              controller: _controller.view,
            ),
          ),
          ScanearQrCodeScreen(_pageController),
          GerenciarPremiosScreen(_pageController),
          HistoricoDeGanhadoresScreen(_pageController)
        ],
      ),
    );
  }
}
