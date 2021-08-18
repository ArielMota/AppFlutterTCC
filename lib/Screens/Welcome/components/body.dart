import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../../constants.dart';
import 'background.dart';


class Body extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _title(context, size.width),
            SizedBox(height: size.height * 0.05),
            Image.asset(
              "assets/images/welcome.png",
              height: size.height * 0.40,
              
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "LOGIN",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            RoundedButton(
              text: "CADASTRO",
              color: kPrimaryLightColor,
              textColor: kPrimaryColor,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _title(BuildContext context, double fonteSize) {
    return SafeArea(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.display1,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.red,
            ),
            children: [
              TextSpan(
                text: 'Seja ',
                style: TextStyle(color: Colors.black, fontSize: fonteSize * 0.08),
              ),
              TextSpan(
                text: 'Bem Vindo!',
                style: TextStyle(color: kPrimaryColor, fontSize: fonteSize * 0.08),
              ),
            ]),
      ),
    );
  }


}
