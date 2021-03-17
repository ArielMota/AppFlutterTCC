import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/constants.dart';

class DrawerTileAdm extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController pageController;
  final int page;

  DrawerTileAdm(this.icon, this.text, this.pageController, this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          if(page != 4) {
            pageController.jumpToPage(page);
          }else{
            _showDialog(context);
          }

        },
        child: Container(
          height: 60.0,
          child: Row(
            children: [
              Icon(
                icon,
                size: 32.0,
                color: pageController.page.round() == page
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700],
              ),
              SizedBox(
                width: 32.0,
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: pageController.page.round() == page
                      ? Theme.of(context).primaryColor
                      : Colors.grey[700],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alerta", style: TextStyle(color: kPrimaryColor),),
          content: new Text("Você deseja sair desta conta?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              color: kPrimaryColor,
              child: new Text("SIM", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => WelcomeScreen()));
              },
            ),
            new FlatButton(
              color: kPrimaryLightColor,
              child: new Text("NÃO", style: TextStyle(color: kPrimaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
