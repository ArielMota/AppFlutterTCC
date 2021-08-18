import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/blocs/cliente_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryView extends StatefulWidget {

  CategoryView();

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {


  final List<String> categories = [
    "Ranking de Cristais",
    "Ranking de Ofensivas",
  ];

  int _category = 0;

  void selectForward(){
    setState(() {

    _category++;
    BlocProvider.getBloc<ClienteBloc>().indexSelectcategoria(_category);

    });
  }

  void selectBackward(){
    setState(() {

      _category--;
      BlocProvider.getBloc<ClienteBloc>().indexSelectcategoria(_category);


    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          disabledColor: Colors.white30,
          onPressed: _category > 0 ? selectBackward : null,
        ),

        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              style: GoogleFonts.portLligatSans(
                textStyle: Theme.of(context).textTheme.display1,
                letterSpacing: 1.2,
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              children: [
                TextSpan(
                  text: categories[_category].toUpperCase(),
                  style: TextStyle(
                      color: Colors.white, fontSize: size.width * 0.045),
                )
              ]),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          color: Colors.white,
          disabledColor: Colors.white30,
          onPressed: _category < categories.length - 1 ? selectForward : null,

        )
      ],
    );
  }
}
