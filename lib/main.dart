import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/Screens/Login/verifica_login_salvado.dart';
import 'package:flutter_auth/Screens/Splash/splash_screen.dart';
import 'package:flutter_auth/blocs/administrador_bloc.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:flutter_auth/blocs/pontoscristal_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/Welcome/welcome_screen.dart';
import 'Screens/home/home_screen.dart';
import 'blocs/premios_bloc.dart';
import 'constants.dart';
import 'model/cliente.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  bool isLoggedIn;

  MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Cliente cli;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        dependencies: [],
        blocs: [
          Bloc((i) => ClienteBloc()),
          Bloc((i) => PontosCristalBloc()),
          Bloc((i) => AdministradorBloc()),
          Bloc((i) => PremiosBloc()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter TCC',
            theme: ThemeData(
              primaryColor: kPrimaryColor,
              scaffoldBackgroundColor: Colors.white,
            ),
            home: SplashScreen()));
  }
}
