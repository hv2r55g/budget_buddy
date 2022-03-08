import 'package:budget_buddy/pages/root_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../utils/authentication.dart';

class GoogleTestSignInButton extends StatefulWidget {
  const GoogleTestSignInButton({Key? key}) : super(key: key);

  @override
  _GoogleTestSignInButtonState createState() => _GoogleTestSignInButtonState();
}

class _GoogleTestSignInButtonState extends State<GoogleTestSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : GestureDetector(
        onTap: () async{

          setState(() {
            _isSigningIn = true;
          });
          User? user =
          await Authentication.signInWithGoogle(context: context);

          setState(() {
            _isSigningIn = false;
          });

          if (user != null) {
            Navigator.of(context).pushReplacement(_createRouteRootpage(user));
          };
        },
            child: OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _isSigningIn = true;
                  });
                  User? user =
                      await Authentication.signInWithGoogle(context: context);

                  setState(() {
                    _isSigningIn = false;
                  });

                  if (user != null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => RootApp(
                          user: user,
                        ),
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Image(
                        image: AssetImage("assets/images/google_logo.png"),
                        height: 35.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ),
    );
  }
}

Route _createRouteRootpage(User user) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => RootApp(
      user: user,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
