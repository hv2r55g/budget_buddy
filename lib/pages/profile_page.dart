import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/authentication.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _user;
  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: firebaseNavy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(),
              _user.photoURL != null
                  ? ClipOval(
                child: Material(
                  color: firebaseGrey.withOpacity(0.3),
                  child: Image.network(
                    _user.photoURL!,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              )
                  : ClipOval(
                child: Material(
                  color: firebaseGrey.withOpacity(0.3),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: firebaseAmber,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Hello',
                style: TextStyle(
                  color: firebaseGrey,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                _user.displayName!,
                style: const TextStyle(
                  color: firebaseYellow,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '( ${_user.email!} )',
                style: const TextStyle(
                  color: firebaseOrange,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24.0),
              Text(
                'You are now signed in using your Google account. To sign out of your account click the "Sign Out" button below.',
                style: TextStyle(
                    color: firebaseGrey.withOpacity(0.8),
                    fontSize: 14,
                    letterSpacing: 0.2),
              ),
              const SizedBox(height: 16.0),
              _isSigningOut
                  ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.pink,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _isSigningOut = true;
                  });
                  await Authentication.signOut(context: context);
                  setState(() {
                    _isSigningOut = false;
                  });
                  Navigator.of(context)
                      .pushReplacement(_routeToSignInScreen());
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}